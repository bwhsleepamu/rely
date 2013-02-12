# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery.fn.get_value = () ->
  return parseInt $(this).val()

jQuery ->
  # Add functionality
  $(document).on "click", "#study_form #testing", () ->
    alert("HI THERE SIR!")
  $(document).on "click", "#study_form #add_original_result", () ->
    # Check to make sure Rule selected and Original Result form for this rule does not exist already.
    selected_rule_id = parseInt $("#rule_id").val()
    active_rule_ids = $("#original_results .well:visible .original_results_rule_id").map(jQuery.fn.get_value)
    hidden_rule_ids = $("#original_results .well:hidden .original_results_rule_id").map(jQuery.fn.get_value)


    if $("#rule_id").val() == ""
      bootbox.alert "Please select Rule for the new Original Result!"
    else if $.inArray(selected_rule_id, active_rule_ids) != -1
      bootbox.alert "Original Result for this Rule already exists!"
    else if $.inArray(selected_rule_id, hidden_rule_ids) != -1
      hidden_well = $('input.original_results_rule_id[value="'+selected_rule_id+'"]').closest(".well")
      hidden_well.find("input.original_results_delete").val(0)
      hidden_well.show()
    else
      $.ajax(
        url: $(this).attr("href"),
        data: { study_id: $(this).data("study-id"), rule_id: $("#rule_id").val() }
        dataType: "script"
        success: () -> $("#no-results").remove()
      )

    false

  # Delete functionality
  $(document).on "click", "#study_form #original_results .well .delete", () ->
    $(this).closest(".well").find("input.original_results_delete").val(1)
    $(this).closest(".well").hide()

  # Uploader Modal Functionality
  $(document).on "click", "#study_form button.upload_files", () ->
    $("#upload_result_id").data("resultId", $(this).data("resultId"))

    asset_ids = $.map $(this).closest(".well").find(".asset_ids"), (val,i) ->
      v = $(val).val()
      if v
        return $(val).val()

    $("#upload_result_id").data("assetIds", asset_ids)
    $(".field-space")
      .attr("data-current-upload", "false")
    $(this).closest(".field-space")
      .attr("data-current-upload", "true")
    jQuery.fn.refresh_uploader()
    $('#uploader').modal('show')
