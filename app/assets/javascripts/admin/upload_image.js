function hide_submit_button(value){
  if(value=='') {
    $("#upload-image").hide();
  } else  {
    $("#upload-image").show();
  } 
}


$(document).ready(function(){
  if($("#artwork_image_cachexx")){
    
    hide_submit_button($("#artwork_image_cache").val())
    
    $("#artwork_image_cache").val(function(){
      format_display($(this).val())
    });
  }
});