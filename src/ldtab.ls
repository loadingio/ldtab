main = (opt) ->
  @opt = opt
  root = opt.root
  @root = root = if typeof(root) == \string => document.querySelector(root) else if root => root else null
  @ <<< active: {}, pends: {}
  @group = {}


main.prototype = Object.create(Object.prototype) <<< do
  add: ({group, name, tab, panel}) ->
    ng = @group{}[group]{}[name]
    if tab => ng.[]tab ++= if Array.isArray(tab) => tab else [tab]
    if panel => ng.[]panel ++= if Array.isArray(panel) => panel else [panel]
    # TODO render

  add: (nodes) ->
    nodes = if Array.isArray(nodes) => nodes else [nodes]
    nodes.map (n) ~>
      [group,name,tab,active] = handle(n)
      ng = @group{}[group]{}[name]
      if tab => ng.[]tab ++= [n]
      else ng.[]panel ++= [n]
      if active => [v for k,v of @group[group]].map -> it.active = false
      ng.active = true
    # TODO render

  toggle: ({group, name}) ->
    ng = @group{}[group]
    [v for k,v of @group[group]].map -> it.active = false
    ng{}[name].active = true
    # TODO render


    {name, tab, panel},  ...
window.ldtab = main

ldui.Nav = (root) ->
  lc = {active: {}, pends: {}}
  view = new ldView do
    root: root
    action: click: do
      "nav": ({node, evt}) ->
        if !(tgt = ld$.parent(evt.target, '[ld]', node)) => return
        if node == tgt => return
        n = tgt.getAttribute(\data-name)
        g = node.getAttribute(\data-nav)
        lc.active[g] = {name: n, node: tgt}
        view.render!
        setTimeout (->
          if (o = lc.pends{}[g][n]) and !(o.inited) =>
            o.func!
            o.inited = true
        ), 10
    handler: do
      "nav-tab": ({node}) ->
        g = node.getAttribute \data-nav
        if !g =>
          if !(p = ld$.parent(node, '[ld=nav]', document)) => return
          if !(g = p.getAttribute \data-nav) => return
        n = node.getAttribute \data-name
        active = lc.active[g] or {}
        node.classList.toggle \active, (
          active.node == node or
          (!lc.active[g] and /default/.exec(node.getAttribute(\ld))) 
        )
      "nav-panel": ({node}) ->
        g = node.getAttribute(\data-nav)
        node.classList.toggle \d-none, (
          (lc.active[g] and lc.active[g].name != node.getAttribute(\data-name)) or
          (!lc.active[g] and !/default/.exec(node.getAttribute(\ld)))
        )
