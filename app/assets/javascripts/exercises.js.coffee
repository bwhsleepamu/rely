@exercises_ready = () ->
  ## Data Tables
  $('#results table').dataTable({
    "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span3'T><'span3'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
    "iDisplayLength": 25,
    "oLanguage": {
      "sLengthMenu": "_MENU_ records per page"
    },
    "oTableTools": {
      "sSwfPath": '../assets/copy_csv_xls_pdf.swf'
    }
  })
