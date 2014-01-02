@exercises_ready = () ->
  ## Data Tables
  $('#results table').dataTable({
#    "sDom": "<'row'<'col-sm-6'l><'col-sm-6'f>r>t<'row'<'col-sm-3'T><'col-sm-3'i><'col-sm-6'p>>",
    "sDom": "<'row'<'col-sm-12'<'pull-right'f><'pull-left'l>r<'clearfix'>>>t<'row'<'col-sm-4'T><'col-sm-4'<'center'i>><'col-sm-4' p><'clearfix'>>>",
    "sPaginationType": "bs_full",
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
    "iDisplayLength": 25,
    "oLanguage": {
      "sLengthMenu": "_MENU_ records per page"
    },
    "oTableTools": {
      "sSwfPath": '../assets/copy_csv_xls_pdf.swf',
      "aButtons": [
        "copy",
        "print",
        "csv",
        "xls",
        "pdf"
      ]
    }
  })

  $('.datatable').each( () ->
    datatable = $(this)
    # SEARCH - Add the placeholder for Search and Turn this into in-line form control
    search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input')
    search_input.attr('placeholder', 'Search')
    search_input.addClass('form-control input-sm')
    # LENGTH - Inline-Form control
    length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_length] select')
    length_sel.addClass('form-control input-sm')
  )