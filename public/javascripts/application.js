(function($){
  var PanelContainer = function($el, data){
    this.$el = $el;
    this.data = data;
    this.panels = [];
  };

  PanelContainer.prototype.render = function(){
    this.createPanel(this.data);

    var self = this;
    this.$el.on('click', '.key', function(){
      var nestedData = $(this).data('obj');
      self.createPanel(nestedData);
    });
  };

  PanelContainer.prototype.createPanel = function(data){
    var panel;

    if ($.isPlainObject(data)){
      panel = new Panel(data);
    } else if ($.isArray(data)){
      // renderArray(data, $el);
    }

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
    var $ul = $('<ul>');

    $.each(this.data, function(key, val){
      var $li = $('<li></li>');
      if ($.isPlainObject(val)){
        var $objName = $('<a class="key" href="#' + key + '">' + key + '</a>');
        $objName.data('obj', val);
        $li.html($objName);
      } else {
        $li.html('<span class="key">' + key + '</span>: <span class="val">' + val + '</span>');
      }

      $li.appendTo($ul);
    });

    this.$el = $ul;
    return this;
  };



  $.fn.jsonPanes = function(data){
    var panels = new PanelContainer($(this), data);
    panels.render();
  };
})(jQuery);
