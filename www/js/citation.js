$(document).ready(
	function(){
	$(document).on('click', '#submit_button',
		function(){
			cburl = 'http://citation.library.nd.edu/citation/';
			cbid = $("#IDentryBox").val();
			$.get(cburl + cbid, 
				function(data, status){
					opt = $("#styleID option:selected").val();
					CiteOpt = $("#styleID option:selected").text();
					$("#mla_area").html(data);
					if(opt == "all"){
						$(".citation").css("visibility", "visible");
						$("#styleID option").each(
							function(){
								label = $(this).text();
								val = $(this).val();
								ht = $("#" + val);
								if(label != 'All'){
									ht.prepend('<div="format">' + label + '</div>');
								}	
							}
						);

					}else{
						$("#" + opt).css("visibility", "visible");
                                                $("#" + opt).prepend('<div="format">' + CiteOpt + '</div>');

					}

			});
		});	

	});
