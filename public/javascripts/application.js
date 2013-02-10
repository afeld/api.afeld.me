(function($) {
  $.fn.jsonPanes = function(data){
    var $el = $(this);
    $el.html(JSON.stringify(data));
  };
})(jQuery);
