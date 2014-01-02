@main_ready = () ->
  # Bootbox Initialization
  bootbox.setDefaults({
    animate: false,
    backdrop: false
  })

  # Chosen Initalization
  $("select[rel=chosen]").chosen({width: "100%"});
  $(".chosen").chosen({width: "100%"});

  # Date Picker Initialization
  $(".datepicker").datepicker('remove')
  $(".datepicker").datepicker( autoclose: true )
