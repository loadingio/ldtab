# ldtab

simple tab widget.

    div(ldtab-group="main",type="tab")
      div(ldtab="tab1",default) tab1
      div(ldtab="tab2") tab2
    div(ldtab-group="main", type="panel")
      div(ldtab="tab1",default) panel1
      div(ldtab="tab2") panel2


## Usage

include required js and css file, then:

    fd = new ldtab({ ... });

Available options:

 - `root`: root element. ldtab will only handles events / elements under this element.
 - `autoInit`: automatically adding all `ldtab` elements. default true.
   - you will have to add manually when you set `autoInit` to false.
 - `tab`, `panel`: animation options for `tab` and `panel`, both includes following configs:
   - className: default class name. default `ldtab` for tab, `ldtab-panel` for panel.
   - classIn: class name for transition in. default `ldtab-in` for tab, `ldtab-panel-in` for panel.
   - classOut: class name for transition out. default `ldtab-out` for tab, `ldtab-panel-out` for panel.
   - delay: delay ( in ms ) before deactivating tab / panel. default 350
   - deactivate({node}): function called when tab / panel is deactivated. default null.


## License

MIT
