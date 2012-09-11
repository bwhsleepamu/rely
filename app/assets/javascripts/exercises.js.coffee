# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#exercise_assessment_type').chosen()
  $('#exercise_rule_id').chosen()
  $('#exercise_scorer_ids').chosen()
  $('#exercise_group_ids').chosen()
  $('#results table').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span3'T><'span3'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "oLanguage": {
      "sLengthMenu": "_MENU_ records per page"
    },
    "oTableTools": {
      "sSwfPath": '../assets/copy_csv_xls_pdf.swf'
    }
  })
