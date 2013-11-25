class window.DeleteConfirmation
  constructor: (options = {}) ->
    @selector    = options.selector || '.delete-confirmation'
    @confirmText = options.confirmText || 'Yes, delete'
    @convertButtons()
    @initializeEvents()
 
  deleteClass: 'delete-button'
  confirmClass: 'confirm-button'
 
  convertButtons: ->
    buttons = $(@selector)
    buttons.each (index, button) =>
      @convert $(button)
 
  convert: (button) ->
    return if button.is ".#{@deleteClass},.#{@confirmClass}"
    console.log('converted', button)
    clone = @createConfirmationButton button
    button.val @confirmText
    button.addClass @deleteClass
    button.hide()
    button.after clone
 
  createConfirmationButton: (button) ->
    clone = button.clone()
    clone.val 'X'
    clone.addClass @confirmClass
    clone.click (event) =>
      event.stopPropagation()
      event.preventDefault()
      clone.hide()
      button.show()
 
  initializeEvents: ->
    $('body').on 'click', =>
      @resetButtons()
 
  resetButtons: ->
    $(".#{@deleteClass}").hide()
    $(".#{@confirmClass}").show()