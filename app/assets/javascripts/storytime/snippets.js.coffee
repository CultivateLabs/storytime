class Storytime.Dashboard.Snippets
  init: ()->
    (new Storytime.Dashboard.Editor()).initMedia()
    (new Storytime.Dashboard.Wysiwyg()).init()