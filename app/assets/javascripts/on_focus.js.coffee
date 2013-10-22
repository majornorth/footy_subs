jQuery ->
  $body = jQuery("body")
  $content = jQuery(".content")
  $inputs = jQuery("input")
  $inputs.on "focus", (e) ->
    $body.addClass "fixfixed"
    $content.addClass "fixedfixed"

  $inputs.on "blur", (e) ->
    $body.removeClass "fixfixed"
    $content.removeClass "fixedfixed"