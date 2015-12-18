$(document).ready( 
	function(){


        $(window).resize(function(){

                 $('.contain').css({
                           position:'absolute',
                           left: ($(window).width() - $('.contain').outerWidth())/2,
                           top: ($(window).height() - $('.contain').outerHeight())/4
                   });

           });



	$(document).on('click', '#submit_button',
		function(){
			cburl = 'http://citation.library.nd.edu/citation/';
			cbid = $("#IDentryBox").val();
			$.get(cburl + cbid, 
				function(data, status){
					opt = $("#styleID option:selected").val();
					CiteOpt = $("#styleID option:selected").text();
					$("#citation_area").html(data);
					if(opt == "all"){
						$(".citation").css("display", "table-row");
						$("#styleID option").each(
							function(){
								label = $(this).text();
								val = $(this).val();
								ht = $("#" + val);
								if(label != 'All'){
									ht.prepend('<div class="format">' + label + '</div>');
								}	
							}
						);

					}else{
						$("#" + opt).css("display", "block");
                                                $("#" + opt).prepend('<div class="format">' + CiteOpt + '</div>');

					}

			});
		});	


	});

	function onrsz(){
                 $('.contain').css({
                           position:'absolute',
                           left: ($(window).width() - $('.contain').outerWidth())/2,
                           top: ($(window).height() - $('.contain').outerHeight())/4
                   });
	}

