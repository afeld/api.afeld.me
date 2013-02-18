(function($){
  var Panel = function(data){
    this.data = data;
    this.$selected = null;
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
        $key = $('<a class="key" href="#' + key + '">' + key + ':</a>');
        $key.data('obj', val);
      } else {
        // normal key-value
        var valType = typeof val;
        $key = $('<span class="key">' + key + ':</span> <span class="val ' + valType + '">' + JSON.stringify(val) + '</span>');
      }

      $li.html($key);
      $list.append($li);
    });

    $list.on('click', 'a.key', $.proxy(this.onKeyClicked, this));

    this.$el = $list;
    return this;
  };

  // private
  Panel.prototype.onKeyClicked = function(e){
    var $key = $(e.currentTarget),
      nestedData = $key.data('obj'),
      childPanel = this.childPanel;

    // remove any existing child panel
    if (childPanel){
      this.childPanel.remove();
      this.childPanel = null;
      this.$selected.removeClass('selected');
      this.$selected = null;
    }

    // only open if an existing panel wasn't being toggled off
    if (!childPanel || childPanel.data !== nestedData){
      // open new panel
      childPanel = new Panel(nestedData);
      childPanel.render();
      childPanel.$el.insertAfter(this.$el);
      this.childPanel = childPanel;

      $key.addClass('selected');
      this.$selected = $key;
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
