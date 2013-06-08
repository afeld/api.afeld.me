(function($){
  var Panel = function(data){
    this.data = data;
  };

  Panel.prototype.render = function(){
    var data = this.data;

    if ($.isArray(data)){
      $list = $('<ol class="list" start="0">');
    } else {
      $list = $('<ul class="list">');
    }

    var self = this;
    $.each(data, function(key, val){
      var $li = self.createListItem(key, val);
      $list.append($li);
    });

    // handle expand/collapse
    $list.on('click', '.expandable', $.proxy(this.onKeyClicked, this));
    var $listWrap = $('<div class="panel">');
    $listWrap.html($list);

    this.$el = $listWrap;
    return this;
  };

  // private
  Panel.prototype.createListItem = function(key, val){
    var $li = $('<li>'),
      isObj = $.isPlainObject(val),
      valStr = JSON.stringify(val),
      $rowContainer, $key, valType, valMarkup;

    if (isObj || $.isArray(val)){
      // nested data
      var $expandable = $('<a class="expandable" href="#">');
      $expandable.data('obj', val);
      $li.append($expandable);
      $rowContainer = $expandable;

      $key = $('<span class="key">' + key + '</span>');
      valType = isObj ? 'object' : 'array';

      // truncate the array/object preview
      var valMatch = valStr.match(/^([\{\[])(.{0,27})(?:.*)([\}\]])$/);
      valMarkup = valMatch[1] + '<span class="val-inner">' + valMatch[2] + '&hellip;</span>' + valMatch[3];

    } else {
      // normal key-value
      $rowContainer = $li;

      $key = $('<span class="key">' + key + '</span>');
      valType = typeof val;
      valMarkup = Autolinker.link( valStr );
    }

    $rowContainer.append($key, ': <span class="val ' + valType + '">' + valMarkup + '</span>');
    return $li;
  };

  // private
  Panel.prototype.onKeyClicked = function(e){
    var $expandable = $(e.currentTarget),
      $selected = $expandable.closest('li');

    if ($selected.hasClass('selected')){
      // collapse
      $selected.children('.panel').remove();
      $selected.removeClass('selected');
    } else {
      var nestedData = $expandable.data('obj');
      this.addChildPanel($selected, nestedData);
    }

    e.stopPropagation();
    e.preventDefault();
  };

  // private
  Panel.prototype.addChildPanel = function($selected, data){
    // open new panel
    var childPanel = new Panel(data);
    childPanel.render();
    $selected.append(childPanel.$el);

    $selected.addClass('selected');
  };



  $.fn.jsonPanes = function(data){
    var panel = new Panel(data);
    panel.render();
    $(this).html(panel.$el);
  };
})(jQuery);
