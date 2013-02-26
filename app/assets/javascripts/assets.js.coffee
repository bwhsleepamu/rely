##
# Refreshes uploader by compiling a list of asset ids for a given result, and sending a json request
# to the asset controller.
jQuery.fn.refresh_uploader = () ->
  request_path = $("#asset_upload").prop("action")

  # Params for json request
  # When no result id is set and validation fails on new results (or original results), we still need to show
  # files in list when page reloads. This works for now for the normal result page...ON TO THE ORIGINAL RESULTS!
  if($("#upload_result_id").data("assetIds") == undefined)
    asset_ids =  $.fn.get_asset_ids($("body"))
  else
    asset_ids = $("#upload_result_id").data("assetIds")

  params =
    result_id: $("#upload_result_id").data("resultId"),
    asset_ids: asset_ids

  # Refreshes uploaded file list using JSON data from assets index
  on_success = (files) ->
    # This had to be changed from .data("fileupload") for some reason due to incompatibility?
    # https://github.com/blueimp/jQuery-File-Upload/issues/2084
    fu = $("#asset_upload").data('blueimpFileupload')
    if fu
      if !files
        files = []
      template = undefined
      fu._adjustMaxNumberOfFiles(-files.length)
      console.log files
      $("#asset_upload .files").html("")
      template = fu._renderDownload(files).appendTo($("#asset_upload .files"))

      # Force reflow:
      fu._reflow = fu._transition and template.length and template[0].offsetWidth
      template.addClass "in"
      $("#loading").remove()

  # Sends JSON request to asset index, with result_id and asset_id as data, and refresh function for uploaded file list
  $.getJSON request_path, params, on_success

jQuery.fn.get_asset_ids = (parent) ->
  console.log parent
  $.map $(parent).find(".asset_ids"), (val,i) ->
    v = $(val).val()
    return v if v

jQuery ->
  # Initialize file upload
  $('#asset_upload').fileupload()

  # Refreshes uploader when #asset_upload is found on the page
  jQuery.fn.refresh_uploader() if $("#asset_upload").length > 0

  ## File Uploader Callbacks

  # Submit for upload
  $(document).on 'fileuploadsubmit', "#asset_upload", (e, data) ->
    # The example input, doesn't have to be part of the upload form:
    data.formData = result_id: $("#upload_result_id").data("resultId")

  # When upload done, appends hidden field with the id of the recently uploaded file to the corresponding result form
  #   The #asset_id_template object used by this bit of code is found in the result _fields.html.rb and _form.html.erb partials
  #   !!!! Unclear if this happens for both Result and Original Result - can't find [data-current-upload] tag in Result
  $(document).on 'fileuploaddone', "#asset_upload", (e, data) ->
    asset_id = data.result.files[0]["asset_id"]
    $('[data-current-upload="true"]').append($("#asset_id_template").html().replace('value=""', 'value="' + asset_id + '"'))

  # When download deleted, get rid of any hidden asset id fields
  $(document).on 'fileuploaddestroy', "#asset_upload", (e, data, xhr) ->
    asset_id = data.url.substring(data.url.lastIndexOf('/') + 1)
    $(".asset_ids[value='"+ asset_id + "']").remove()

  # Ajax Loader for selecting files from system dialog (UNTESTED)
  $("#asset_upload").on 'click', ".fileinput-button", (e, data) ->
    $("#asset_upload #ajax_loader").show()
  $(document).on 'fileuploadadd', "#asset_upload", (e, data) ->
    $("#asset_upload #ajax_loader").hide()

  # Error listings
  fileUploadErrors =
    maxFileSize: 'File is too big'
    minFileSize: 'File is too small'
    acceptFileTypes: 'Filetype not allowed'
    maxNumberOfFiles: 'Max number of files exceeded'
    uploadedBytes: 'Uploaded bytes exceed file size'
    emptyResult: 'Empty file upload result'


