(function($){
  var Panel = function(data){
    this.data = data;
    this.childPanel = null;
  };

  Panel.prototype.render = function(){
    var data = this.data;

    if ($.isArray(data)){
      $list = $('<ol start="0">');
    } else {
      $list = $('<ul>');
    }

    $.each(data, function(key, val){
      var $item;
      if ($.isPlainObject(val) || $.isArray(val)){
        // nested data
        $item = $('<a class="key" href="#' + key + '"><li><span class="key-inner">' + key + '</span></li></a>');
        $item.data('obj', val);
      } else {
        $item = $('<li><span class="key">' + key + ':</span> <span class="val">' + val + '</span></li>');
      }

      $list.append($item);
    });

    $list.on('click', 'a.key', $.proxy(this.onKeyClicked, this));

    this.$el = $list;
    return this;
  };

  Panel.prototype.onKeyClicked = function(e){
    var nestedData = $(e.currentTarget).data('obj'),
      childPanel = this.childPanel;

    // remove any existing child panel
    if (childPanel){
      this.childPanel.remove();
      this.childPanel = null;
    }

    // only open if an existing panel wasn't being toggled off
    if (!childPanel || childPanel.data !== nestedData){
      childPanel = new Panel(nestedData);
      childPanel.render();
      childPanel.$el.insertAfter(this.$el);
      this.childPanel = childPanel;
    }
  };

  // recursively remove this and all child panels
  Panel.prototype.remove = function(){
    this.$el.remove();
    if (this.childPanel){
      this.childPanel.remove();
    }
  };



  $.fn.jsonPanes = function(data){
    var panel = new Panel(data);
    panel.render();
    $(this).html(panel.$el);
  };
})(jQuery);
