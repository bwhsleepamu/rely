# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#add_original_result").click () ->
    if $("#rule_id").val() != ""
      $.ajax(
        url: $(this).attr("href"),
        data: { study_id: $(this).data("study-id"), rule_id: $("#rule_id").val() }
        dataType: "script"
      )

    return false
