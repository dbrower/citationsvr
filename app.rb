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
  cp << item
  cp.render :bibliography, id: item.id
end



get '/citation/:id' do |id|
  r = solr.get 'select', :params => {:q => "id:\"und:#{id}\""}
  response = r["response"]
  if response["numFound"] != 1
    puts "not found #{id}"
    raise Sinatra::NotFound
  end

  solr_record = response["docs"].first
  item = CiteProc::Item.new(
    id: id,
    URL: "https://curate.nd.edu/show/#{id}",
    title: solr_record["desc_metadata__title_tesim"].first,
    author: solr_record["desc_metadata__creator_tesim"],
  )
#  dois = solr_record["desc_metadata__identifier_tesim"]
#  if dois && dois.length > 0
#    item.DOI = dois.first
#  end

  result = STYLES.map do |style|
    process_citation(style, item)
  end
  result.to_json
end

get '/' do
  redirect to('index.html')
end

get '/z' do
  erb :z
end



