jQuery ->
  # Add functionality
  $(document).on "change", ".project_select", () ->
    data_hash = {}
    $("#form").html("")
    data_hash[$(this).data("object-name")] = {project_id: $(this).val()}
    $.ajax(
      url: $(this).data("target-path"),
      data: data_hash
      dataType: "script"
    )