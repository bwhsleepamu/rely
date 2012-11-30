jQuery ->
  # Add functionality
  $(".project_select").live "change", () ->
    data_hash = {}
    data_hash[$(this).data("object-name")] = {project_id: $(this).val()}
    $.ajax(
      url: $(this).data("target-path"),
      data: data_hash
      dataType: "script"
    )