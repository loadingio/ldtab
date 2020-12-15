// Generated by LiveScript 1.6.0
(function(){
  var main;
  main = function(opt){
    var root;
    this.opt = opt;
    root = opt.root;
    this.root = root = typeof root === 'string'
      ? document.querySelector(root)
      : root ? root : null;
    this.active = {};
    this.pends = {};
    this.group = {};
    this.init();
    return this;
  };
  main.prototype = import$(Object.create(Object.prototype), {
    init: function(){
      return this.add(ld$.find('[data-name]'));
    },
    parse: function(node){
      var p, group, name, tab, active;
      p = ld$.parent(node, '[data-tab]', this.root);
      group = (p ? p : node).getAttribute('data-tab');
      name = node.getAttribute('data-name');
      tab = p ? p.getAttribute('data-type') : null;
      if (!tab) {
        tab = node.getAttribute('data-type') === 'tab';
      }
      active = node.hasAttribute('default') && node.getAttribute('default') !== 'false';
      console.log(active);
      return {
        group: group,
        name: name,
        tab: tab,
        active: active
      };
    },
    add: function(nodes){
      var this$ = this;
      nodes = Array.isArray(nodes)
        ? nodes
        : [nodes];
      return nodes.map(function(node){
        var ref$, group, name, tab, active, n, ref1$, k, v;
        ref$ = this$.parse(node), group = ref$[0], name = ref$[1], tab = ref$[2], active = ref$[3];
        n = (ref$ = (ref1$ = this$.group)[group] || (ref1$[group] = {}))[name] || (ref$[name] = {});
        if (tab) {
          n.tab = (n.tab || (n.tab = [])).concat([node]);
          node.addEventListener('click', function(){
            return this$.toggle({
              group: group,
              name: name
            });
          });
        } else {
          n.panel = (n.panel || (n.panel = [])).concat([node]);
        }
        if (active) {
          (function(){
            var ref$, results$ = [];
            for (k in ref$ = this.group[group]) {
              v = ref$[k];
              results$.push(v);
            }
            return results$;
          }.call(this$)).map(function(name){
            return this$.update({
              group: group,
              name: name,
              active: false
            });
          });
        }
        return this$.update({
          group: group,
          name: name,
          active: active
        });
      });
    },
    update: function(arg$){
      var group, name, active, n, ref$, ref1$;
      group = arg$.group, name = arg$.name, active = arg$.active;
      n = (ref$ = (ref1$ = this.group)[group] || (ref1$[group] = {}))[name] || (ref$[name] = {});
      (n.tab || (n.tab = [])).map(function(it){
        return it.classList.toggle('active', active);
      });
      (n.panel || (n.panel = [])).map(function(it){
        return it.classList.toggle('active', active);
      });
      return n.active = active;
    },
    toggle: function(arg$){
      var group, name, g, ref$, k, v, this$ = this;
      group = arg$.group, name = arg$.name;
      g = (ref$ = this.group)[group] || (ref$[group] = {});
      (function(){
        var ref$, results$ = [];
        for (k in ref$ = this.group[group]) {
          v = ref$[k];
          results$.push(v);
        }
        return results$;
      }.call(this)).map(function(name){
        return this$.update({
          group: group,
          name: name,
          active: false
        });
      });
      return this.update({
        group: group,
        name: name,
        active: true
      });
    }
  });
  window.ldtab = main;
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
