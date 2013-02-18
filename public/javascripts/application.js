(function($){
  var Panel = function(data){
    this.data = data;
    this.childPanel = null;
  };

  Panel.prototype.render = function(){
    var data = this.data,
      listType = $.isArray(data) ? 'ol' : 'ul',
      $list = $('<' + listType + '>');

    $.each(data, function(key, val){
      var $li = $('<li></li>');
      if ($.isPlainObject(val) || $.isArray(val)){
        // nested data
        var $key = $('<a class="key" href="#' + key + '">' + key + '</a>');
        $key.data('obj', val);
        $li.html($key);
      } else {
        $li.html('<span class="key">' + key + ':</span> <span class="val">' + val + '</span>');
      }

      $li.appendTo($list);
    });

    $list.on('click', 'a.key', $.proxy(this.onKeyClicked, this));

    this.$el = $list;
    return this;
  };

  Panel.prototype.onKeyClicked = function(e){
    var nestedData = $(e.target).data('obj'),
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
