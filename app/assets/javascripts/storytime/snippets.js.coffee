class Storytime.Dashboard.Snippets
  init: ()->
    @editor = new Storytime.Dashboard.Editor()
    @editor.initMedia()
    @editor.initWysiwyg()