## Index Functionality
jQuery.fn.reset_index = () ->
  $(".index-content").html("")
  $("#ajax_loader").show()


$(document).on("click", ".form-search .submit-button", () ->
  jQuery.fn.reset_index()
  $(".form-search").submit()
  false
)

$(document).off("click", ".per_page a")
$(document).on("click", ".per_page a", () ->
  jQuery.fn.reset_index()
  $($(this).data('form')).find("#per_page").val($(this).data('per-page'))
  $($(this).data('form')).submit()
  false
)

$(document).off("click", '[data-object~="order"]')
$(document).on('click', '[data-object~="order"]', () ->
  $($(this).data('form')).find("#order").val($(this).data('order'))
  jQuery.fn.reset_index()
  $($(this).data('form')).submit()
  false
)

$(document).off('click', ".pagination a, .page a, .first a, .last a, .next a, .prev a")
$(document).on('click', ".page a, .first a, .last a, .next a, .prev a", () ->
  return false if $(this).parent().is('.active, .disabled, .per_page')
  jQuery.fn.reset_index()
  $.get(this.href, null, null, "script")
  false
)
