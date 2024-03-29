ldtab = (opt) ->
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
  if !(opt.auto-init?) or opt.auto-init => @init!
  @

ldtab.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v
  init: ->
    @add Array.from(@root.querySelectorAll('[ldtab]'))

  parse: (node) ->
    n = node
    while n and n != @root and (!n.matches or (n.matches and !n.matches '[ldtab-group]' )) => n = n.parentNode
    p = if !(n and n.matches and n.matches('[ldtab-group]')) => null else n

    group = (if p => p else node).getAttribute(\ldtab-group)
    name = node.getAttribute(\ldtab)
    tab = if p => p.getAttribute(\type) else null
    if !tab => tab = node.getAttribute(\type)
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
      if active => @toggle {group, name}

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
    @fire \on, {group, name}

lc = {}
ldtab.init = (opt) ->
  lc.ldtab = new ldtab opt
  lc.ldtab.add Array.from(document.querySelectorAll('[ldtab]'))

if module? => module.exports = ldtab
else if window? => window.ldtab = ldtab
