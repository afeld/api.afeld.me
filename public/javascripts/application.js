(function($){
  var Panel = function(data){
    this.data = data;
    this.childPanel = null;
  };

  Panel.prototype.render = function(){
    var data = this.data;

    if ($.isArray(data)){
      $list = $('<ol class="panel" start="0">');
    } else {
      $list = $('<ul class="panel">');
    }

    $.each(data, function(key, val){
      var $li = $('<li>'),
        $key;

      if ($.isPlainObject(val) || $.isArray(val)){
        // nested data
        $key = $('<a class="key" href="#' + key + '">' + key + '</a>');
        $key.data('obj', val);
      } else {
        $key = $('<span class="key">' + key + ':</span> <span class="val">' + val + '</span>');
      }

      $li.html($key);
      $list.append($li);
    });

    $list.on('click', 'a.key', $.proxy(this.onKeyClicked, this));

    this.$el = $list;
    return this;
  };

  Panel.prototype.onKeyClicked = function(e){
    var $key = $(e.currentTarget),
      nestedData = $key.data('obj'),
      childPanel = this.childPanel;

    // remove any existing child panel
    if (childPanel){
      this.childPanel.remove();
      this.childPanel = null;
    }

    if (childPanel && childPanel.data === nestedData){
      // toggle off
      $key.removeClass('selected');
    } else {
      // open new panel
      childPanel = new Panel(nestedData);
      childPanel.render();
      childPanel.$el.insertAfter(this.$el);
      this.childPanel = childPanel;
      $key.addClass('selected');
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
