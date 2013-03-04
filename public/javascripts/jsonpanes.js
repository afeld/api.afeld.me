(function($){
  var Panel = function(data){
    this.data = data;
    this.$selected = null;
    this.childPanel = null;
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
    $list.on('click', 'a.key', $.proxy(this.onKeyClicked, this));
    var $listWrap = $('<div class="panel">');
    $listWrap.html($list);

    this.$el = $listWrap;
    return this;
  };

  // private
  Panel.prototype.createListItem = function(key, val){
    var $li = $('<li>'),
      isObj = $.isPlainObject(val),
      $key, $val;

    if (isObj || $.isArray(val)){
      // nested data
      $key = $('<a class="key" href="#">' + key + '</a>');
      $key.data('obj', val);

      if (isObj){
        $val = $('<span class="val object">{…}</span>');
      } else {
        // can assume it's an Array
        $val = $('<span class="val array">[…]</span>');
      }
    } else {
      // normal key-value
      $key = $('<span class="key">' + key + '</span>');

      var valType = typeof val,
        valStr = JSON.stringify(val);

      $val = $('<span class="val ' + valType + '">' + Autolinker.link( valStr ) + '</span>');
    }

    $li.append($key, ': ', $val);
    return $li;
  };

  // private
  Panel.prototype.onKeyClicked = function(e){
    var $key = $(e.currentTarget),
      nestedData = $key.data('obj'),
      oldChildPanel = this.removeChildPanel();

    // only open if an existing panel wasn't being toggled off
    if (!oldChildPanel || oldChildPanel.data !== nestedData){
      var $selected = $key.closest('li');
      this.addChildPanel($selected, nestedData);
    }

    e.stopPropagation();
    e.preventDefault();
  };

  // private
  Panel.prototype.removeChildPanel = function(){
    var childPanel = this.childPanel;

    // remove any existing child panel
    if (childPanel){
      childPanel.remove();
      this.childPanel = null;
      this.$selected.removeClass('selected');
      this.$selected = null;
    }

    return childPanel;
  };

  // private
  Panel.prototype.addChildPanel = function($selected, data){
    // open new panel
    var childPanel = new Panel(data);
    childPanel.render();
    $selected.append(childPanel.$el);
    this.childPanel = childPanel;

    $selected.addClass('selected');
    this.$selected = $selected;
  };

  // recursively remove this and all child panels
  Panel.prototype.remove = function(){
    this.removeChildPanel();
    this.$el.remove();
  };



  $.fn.jsonPanes = function(data){
    var panel = new Panel(data);
    panel.render();
    $(this).html(panel.$el);
  };
})(jQuery);
