jQuery.fn.refresh_uploader = () ->
  $.getJSON $("#asset_upload").prop("action"),
    result_id: $("#upload_result_id").data("resultId")
  , (files) ->
    fu = $("#asset_upload").data("fileupload")
    if fu and files
      template = undefined
      fu._adjustMaxNumberOfFiles(-files.length)
      console.log files
      $("#asset_upload .files").html("")
      template = fu._renderDownload(files).appendTo($("#asset_upload .files"))

      # Force reflow:
      fu._reflow = fu._transition and template.length and template[0].offsetWidth
      template.addClass "in"
      $("#loading").remove()
jQuery ->
  #$("#upload_result_id").data("resultId", 123)
  #alert $("#upload_result_id").data("resultId")
  $('#asset_upload').fileupload()

  $("#asset_upload").bind "fileuploadsubmit", (e, data) ->
    # The example input, doesn't have to be part of the upload form:
    data.formData = result_id: $("#upload_result_id").data("resultId")
    unless data.formData.result_id
      false

  fileUploadErrors =
    maxFileSize: 'File is too big'
    minFileSize: 'File is too small'
    acceptFileTypes: 'Filetype not allowed'
    maxNumberOfFiles: 'Max number of files exceeded'
    uploadedBytes: 'Uploaded bytes exceed file size'
    emptyResult: 'Empty file upload result'

  jQuery.fn.refresh_uploader()

#  $.getJSON $("#asset_upload").prop("action"),
#    result_id: $("#upload_result_id").data("resultId")
#  , (files) ->
#    fu = $("#asset_upload").data("fileupload")
#    if fu and files
#      template = undefined
#      fu._adjustMaxNumberOfFiles(-files.length)
#      console.log files
#      template = fu._renderDownload(files).appendTo($("#asset_upload .files"))
#
#      # Force reflow:
#      fu._reflow = fu._transition and template.length and template[0].offsetWidth
#      template.addClass "in"
#      $("#loading").remove()
#
