(function($){
  var Panel = function(data){
    this.data = data;
    this.nextPanel = null;
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

    var self = this;
    $list.on('click', 'a.key', function(){
      var nestedData = $(this).data('obj'),
        nextPanel = new Panel(nestedData);

      nextPanel.render();
      nextPanel.$el.insertAfter(self.$el);
      self.nextPanel = nextPanel;
    });

    this.$el = $list;
    return this;
  };



  $.fn.jsonPanes = function(data){
    var panel = new Panel(data);
    panel.render();
    $(this).html(panel.$el);
  };
})(jQuery);
