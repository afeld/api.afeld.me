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
      var valMatch = valStr.match(/^([\{\[])(.{0,28})(?:.*)([\}\]])$/);
      valMarkup = valMatch[1] + '<span class="val-inner">' + valMatch[2] +'…</span>' + valMatch[3];

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
      nestedData = $expandable.data('obj'),
      oldChildPanel = this.removeChildPanel();

    // only open if an existing panel wasn't being toggled off
    if (!oldChildPanel || oldChildPanel.data !== nestedData){
      var $selected = $expandable.closest('li');
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
