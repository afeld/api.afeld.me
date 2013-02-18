(function($){
  function renderHash(hash, $el){
    var $ul = $('<ul>');
    $ul.appendTo($el);

    $.each(hash, function(key, val){
      var li = '<li>';
      if ($.isPlainObject(val)){
        li += '<a class="key" href="#' + key + '">' + key + '</a>';
      } else {
        li += '<span class="key">' + key + '</span>: <span class="val">' + val + '</span>';
      }
      li += '</li>';

      var $li = $(li);
      $li.appendTo($ul);
    });
  }

  function renderArray(ary, $el){

  }

  function renderData(data, $el){
    renderHash(data, $el);
  }

  $.fn.jsonPanes = function(data){
    renderData(data, $(this));
  };
})(jQuery);
