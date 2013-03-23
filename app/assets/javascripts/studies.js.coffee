# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Returns integer version of input field's value
jQuery.fn.get_value = () ->
  return parseInt $(this).val()

jQuery.fn.update_file_lists = () ->
  $(".attached-files").each () ->
    parent_field = $(this).closest(".field-space")
    parent_list = $(this).closest(".asset_list")
    asset_ids = $.fn.get_asset_ids(parent_field)
    path = $(this).data("update-asset-list")

    $.ajax(
      url: path,
      data: {asset_ids: asset_ids, rule_id: $(this).closest(".asset_list").data("rule-id"), result_id: $(this).data("result-id")},
      dataType: "script"
    )
  

jQuery.fn.refresh_study_page = () ->
  $('#asset_upload').fileupload()
  jQuery.fn.refresh_uploader() if $("#asset_upload").length > 0
  $(".timepicker").timepicker
    showMeridian: false
    showSeconds: true
    defaultTime: false
  $(".datepicker").datepicker('remove')
  $(".datepicker").datepicker( autoclose: true )
  $("select[rel=chosen]").chosen();
  $(".chosen").chosen();  
  $("#uploader").off "hide"
  $("#uploader").on "hide", jQuery.fn.update_file_lists
  $("#uploader .modal-footer").off "click", ".btn"
  $("#uploader .modal-footer").on "click", ".btn", () ->
    $("#uploader").modal("hide")

jQuery ->
  # I'm not sure what the refresh event listener is - why not just call it in the function? moved to new.js.erb
  #  $(document).on "refresh", "#form", () ->
  #  alert("when??")
 
  jQuery.fn.refresh_study_page()


  ##
  # Original Results

  ## Adding
  $(document).on "click", "#study_form #add_original_result", () ->
    # Check to make sure Rule selected and Original Result form for this rule does not exist already.
    selected_rule_id = parseInt $("#rule_id").val()
    active_rule_ids = $("#original_results .well:visible .original_results_rule_id").map(jQuery.fn.get_value)
    hidden_rule_ids = $("#original_results .well:hidden .original_results_rule_id").map(jQuery.fn.get_value)


    if $("#rule_id").val() == ""
      bootbox.alert "Please select Rule for the new Original Result."
    else if $.inArray(selected_rule_id, active_rule_ids) != -1
      bootbox.alert "Original Result for this Rule already exists."
    else if $.inArray(selected_rule_id, hidden_rule_ids) != -1
      hidden_well = $('input.original_results_rule_id[value="'+selected_rule_id+'"]').closest(".well")
      hidden_well.find("input.original_results_delete").val(0)
      hidden_well.show()
    else
      $.ajax(
        url: $(this).attr("href"),
        data: { study_id: $(this).data("study-id"), rule_id: $("#rule_id").val() }
        dataType: "script"
        success: () ->
          $("#no-results").remove()
          $.fn.refresh_study_page()
      )

    false

  ## Deleting
  # Sets delete hidden input value to 1 and hides the well
  $(document).on "click", "#study_form #original_results .well .delete", () ->
    $(this).closest(".well").find("input.original_results_delete").val(1)
    $(this).closest(".well").hide()

  ##
  # Uploader Modal
  $(document).on "click", "#study_form button.upload_files", () ->
    # Stores result id for the clicked-on result to be used for the uploader
    $("#upload_result_id").data("resultId", $(this).data("resultId"))

    # Maps val function to each .asset_ids element
    asset_ids = $.map $(this).closest(".well").find(".asset_ids"), (val,i) ->
      #console.log val
      #console.log $(val).val()
      v = $(val).val()
      # Why this two-step process??
#      if v
#        return $(val).val()
      return v if v
    #console.log asset_ids
    $("#upload_result_id").data("assetIds", asset_ids)
    $(".field-space")
      .attr("data-current-upload", "false")
    $(this).closest(".field-space")
      .attr("data-current-upload", "true")
    jQuery.fn.refresh_uploader()

    # Shows modal to allow for uploading
    $('#uploader').modal('show')
