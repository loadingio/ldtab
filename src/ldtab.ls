main = (opt) ->
  @opt = opt

  @cls = do
    tab:
      className: <[ldtab]>
      classIn: <[ldtab-in]>
      classOut: <[ldtab-out]>
      delay: 350
    panel:
      className: <[ldtab-panel]>
      classIn: <[ldtab-panel-in]>
      classOut: <[ldtab-panel-out]>
      delay: 350
  @cls.tab <<< (opt.tab or {})
  @cls.panel <<< (opt.panel or {})
  @evt-handler = {}
  <[tab panel]>.map (t) ~> <[className classIn classOut]>.map (n) ~>
    if typeof(@cls[t][n]) == \string => @cls[t][n] = @cls[t][n].split(' ').filter(->it.trim!)
  root = opt.root
  @root = root = if typeof(root) == \string => document.querySelector(root) else if root => root else null
  @ <<< active: {}, pends: {}
  @group = {}
  @init!
  @


main.prototype = Object.create(Object.prototype) <<< do
  init: ->
    @add ld$.find '[data-name]'

  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v
  parse: (node) ->
    p = ld$.parent node, '[data-tab]', @root
    group = (if p => p else node).getAttribute(\data-tab)
    name = node.getAttribute(\data-name)
    tab = if p => p.getAttribute(\data-type) else null
    if !tab => tab = node.getAttribute(\data-type)
    tab = tab == \tab
    active = node.hasAttribute(\default) and node.getAttribute(\default) != \false
    return {group,name,tab,active}

  add: (nodes) ->
    nodes = if Array.isArray(nodes) => nodes else [nodes]
    nodes.map (node) ~>
      {group,name,tab,active} = @parse(node)
      n = @group{}[group]{}[name]

      if !node._ldtab_debounce =>
        delay = @cls[if tab => \tab else \panel].delay
        if delay => node._ldtab_debounce = debounce(delay, ~> node.classList.remove \active)
      if tab =>
        n.[]tab ++= [node]
        node.classList.add @cls.tab.className
        node.addEventListener \click, ~> @toggle {group, name}
      else
        n.[]panel ++= [node]
        node.classList.add @cls.panel.className
      if active => [v for k,v of @group[group]].map (name) ~> @update {group, name, active: false}
      @update {group, name, active}

  update: ({group, name, active}) ->
    n = @group{}[group]{}[name]
    if active =>
      <[tab panel]>.map (t) ~> n.[][t].map (node) ~>
        if node.classList.contains \active => return
        if @cls[t].activate => @cls[t].activate {node}
        else
          if node._ldtab_debounce => node._ldtab_debounce.clear!
          node.classList.remove @cls[t].classOut
          node.classList.add @cls[t].classIn
          node.classList.add \active
    else
      <[tab panel]>.map (t) ~> n.[][t].map (node) ~>
        if !node.classList.contains(\active) => return
        if @cls[t].deactivate => @cls[t].deactivate {node}
        else
          if node._ldtab_debounce => node._ldtab_debounce!
          else node.classList.remove \active
          node.classList.remove @cls[t].classIn
          node.classList.add @cls[t].classOut
    n.active = active

  toggle: ({group, name}) ->
    g = @group{}[group]
    [k for k,v of @group[group]].filter(->it != name).map (name) ~> @update {group, name, active: false}
    @update {group, name, active: true}
    @on \on, {group, name}

window.ldtab = main
