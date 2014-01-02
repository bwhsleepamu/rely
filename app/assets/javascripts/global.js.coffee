## Initializers - Need to run when page is loaded
@loaders = () ->
  contourReady()
  main_ready()
  exercises_ready()
  assets_ready()
  studies_ready()

$(document).ready(loaders)
$(document).on('page:load', loaders)
