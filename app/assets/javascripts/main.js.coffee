@main_ready = () ->
  bootbox.setDefaults({
    animate: false,
    backdrop: false
  })
  $("select[rel=chosen]").chosen({width: "250px"});
  $(".chosen").chosen({width: "250px"});

