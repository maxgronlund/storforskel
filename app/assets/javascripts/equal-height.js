/**
 * Set all passed elements to the same height as the highest element.
 * TO DO
 * check if  sindod resize
**/ 


function set_equal_height(){
  /* CACHE ORIGINAL HEIGHTS */
  $.fn.equalHeightColumns = function (options)
  {
    var height, elements;

    options = $.extend({}, $.equalHeightColumns.defaults, options);
    height = options.height;
    elements = $(this);
    
    $(this).each
    (
      function ()
      {
        // Apply equal height to the children of this element??
        if (options.children)
        {
        	elements = $(this).children(options.children);
        }
        
        // If options.height is 0, then find which element is the highest.
        if (!options.height)
        {
          // If applying to this elements children, then loop each child element and find which is the highest.
          if (options.children)
          {
            elements.each
            (
              function ()
              {
                // If this element's height is more than is store in 'height' then update 'height'.
                if ($(this).height() > height)
                {
                  height = $(this).height();
                }
              }
            );
          }
          
          else
          {
          	// If this element's height is more than is store in 'height' then update 'height'.
          	if ($(this).height() > height)
          	{
          		height = $(this).height();
          	}
          }
        }
      }
    );
  
    // Enforce min height.
    if (options.minHeight && height < options.minHeight)
    {
    	height = options.minHeight;
    }
    
    // Enforce max height.
    if (options.maxHeight && height > options.maxHeight)
    {
    	height = options.maxHeight;
    }
    
    
    // Animate the column's height change.
    elements.animate
    (
    	{
    		height : height
    	},
    	options.speed
    );
    
    return $(this);
  };
  
  
  $.equalHeightColumns = {
  	version : 1.0,
  	defaults : {
  		children : false,
  		height : 0,
  		minHeight : 0,
  		maxHeight : 0,
  		speed : 0
  	}
	}
	/*
	$(window).resize(function() {
	  if($(window).width() > 764){
	    console.log('Update');
    }
    else{
      window.location.reload(true);
      console.log('disable');

    }
  	
  });
  */
}

(function ($)
{
  /* check if top is alligned other wise scip */

/*
  if($(window).width() > 760){
    set_equal_height();
  };
*/
  /*
  if($(window).resize()){
    set_equal_height();
  };
  */
  
})(jQuery);