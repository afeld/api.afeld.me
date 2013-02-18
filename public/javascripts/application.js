(function($){
  var PanelContainer = function($el, data){
    this.$el = $el;
    this.data = data;
    this.panels = [];
  };

  PanelContainer.prototype.render = function(){
    this.createPanel(this.data);

    var self = this;
    this.$el.on('click', 'a.key', function(){
      var nestedData = $(this).data('obj');
      self.createPanel(nestedData);
    });
  };

  PanelContainer.prototype.createPanel = function(data){
    var panel = new Panel(data);
    this.addPanel(panel);
  };

  PanelContainer.prototype.addPanel = function(panel){
    this.panels.push(panel);
    panel.render();
    this.$el.append(panel.$el);
  };


  var Panel = function(data){
    this.data = data;
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

    this.$el = $list;
    return this;
  };



  $.fn.jsonPanes = function(data){
    var panels = new PanelContainer($(this), data);
    panels.render();
  };
})(jQuery);
