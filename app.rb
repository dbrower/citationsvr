# myapp.rb
require 'sinatra'
require 'json'
require 'rsolr'
require 'citeproc'
require 'csl/styles'


STYLES = [
  "apa",
  "modern-language-association-with-url",
  "chicago-fullnote-bibliography",
  "harvard1",
  "vancouver"
]

solr = RSolr.connect :url => ENV['SOLR_URL']



def process_citation(style, item)
  cp = CiteProc::Processor.new style: style, format:'html'
  cp.engine.format = 'html'
  cp << item
  r = cp.render :bibliography, id: item.id, format: 'html'
  # for some reason render returns a list
  r.first
end



get '/citation/:id' do |id|
  r = solr.get 'select', :params => {:q => "id:\"und:#{id}\""}
  response = r["response"]
  if response["numFound"] != 1
    puts "not found #{id}"
    raise Sinatra::NotFound
  end

  solr_record = response["docs"].first
  dois = solr_record["desc_metadata__identifier_tesim"]
  doi = nil
  if dois && dois.length > 0
    doi = dois.first.sub(/\A.*?10/,"10")
  end
  item = CiteProc::Item.new(
    id: id,
    URL: "https://curate.nd.edu/show/#{id}",
    title: solr_record["desc_metadata__title_tesim"].first,
    author: solr_record["desc_metadata__creator_tesim"],
    DOI: doi,
  )

  result = {}
  STYLES.map do |style|
    result[style] = process_citation(style, item)
  end

  erb :citation_list, locals: {result: result}
end

get '/' do
  redirect to('index.html')
end
