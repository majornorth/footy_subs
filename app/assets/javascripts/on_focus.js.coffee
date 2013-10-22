jQuery ->
  $body = jQuery("body")
  $inputs = jQuery("input")
  $inputs.on "focus", (e) ->
    $body.addClass "fixfixed"

  $inputs.on "blur", (e) ->
    $body.removeClass "fixfixed"