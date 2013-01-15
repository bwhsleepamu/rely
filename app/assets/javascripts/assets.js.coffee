jQuery ->
  $('#asset_upload').fileupload()

  fileUploadErrors =
    maxFileSize: 'File is too big'
    minFileSize: 'File is too small'
    acceptFileTypes: 'Filetype not allowed'
    maxNumberOfFiles: 'Max number of files exceeded'
    uploadedBytes: 'Uploaded bytes exceed file size'
    emptyResult: 'Empty file upload result'

  $.getJSON $("#asset_upload").prop("action"), (files) ->
    fu = $("#asset_upload").data("fileupload")
    template = undefined
    fu._adjustMaxNumberOfFiles(-files.length)
    console.log files
    template = fu._renderDownload(files).appendTo($("#asset_upload .files"))

    # Force reflow:
    fu._reflow = fu._transition and template.length and template[0].offsetWidth
    template.addClass "in"
    $("#loading").remove()

