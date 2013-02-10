(function($){
  // taken from Underscore
  function isObject(obj){
    return obj === Object(obj);
  }

  function renderHash(hash, $el){
    var $ul = $('<ul>'),
      val, li, $li;

    $ul.appendTo($el);

    for (var key in hash){
      val = hash[key];
      li = '<li>';
      if (isObject(val)){
        li += '<a class="key" href="#' + key + '">' + key + '</a>';
      } else {
        li += '<span class="key">' + key + '</span>: <span class="val">' + val + '</span>';
      }
      li += '</li>';

      $li = $(li);
      $li.appendTo($ul);
    }
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
