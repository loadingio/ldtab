main = (opt) ->
  @opt = opt
  root = opt.root
  @root = root = if typeof(root) == \string => document.querySelector(root) else if root => root else null
  @ <<< active: {}, pends: {}
  @group = {}
  @init!
  @


main.prototype = Object.create(Object.prototype) <<< do
  init: ->
    @add ld$.find '[data-name]'

  parse: (node) ->
    p = ld$.parent node, '[data-tab]', @root
    group = (if p => p else node).getAttribute(\data-tab)
    name = node.getAttribute(\data-name)
    tab = if p => p.getAttribute(\data-type) else null
    if !tab => tab = node.getAttribute(\data-type) == \tab
    active = node.hasAttribute(\default) and node.getAttribute(\default) != \false
    return {group,name,tab,active}

  add: (nodes) ->
    nodes = if Array.isArray(nodes) => nodes else [nodes]
    nodes.map (node) ~>
      [group,name,tab,active] = @parse(node)
      n = @group{}[group]{}[name]
      if tab =>
        n.[]tab ++= [node]
        node.addEventListener \click, ~> @toggle {group, name}
      else n.[]panel ++= [node]
      if active => [v for k,v of @group[group]].map (name) ~> @update {group, name, active: false}
      @update {group, name, active}

  update: ({group, name, active}) ->
    n = @group{}[group]{}[name]
    n.[]tab.map -> it.classList.toggle \active, active
    n.[]panel.map -> it.classList.toggle \active, active
    n.active = active

  toggle: ({group, name}) ->
    g = @group{}[group]
    [v for k,v of @group[group]].map (name) ~> @update {group, name, active: false}
    @update {group, name, active: true}

window.ldtab = main
