class TranslationForm
  constructor: (form) ->
    @form = form
    @key = @form.dataset.key.toString()
    @form_id = @form.id
    @method = @form._method?.value ? @form.method
    @value_input = @form['translation[value]']
    @initValue = @value_input.value
    @inputInterval = 200 # ms

    @submit_button = document.getElementById("#{@form_id}-submit")
    @reset_button = document.getElementById("#{@form_id}-reset")
    @delete_button = document.getElementById("#{@form_id}-delete")

    @value_input.addEventListener 'input', =>
      clearTimeout(@timeout)

      @timeout = setTimeout =>
        if @value_input.value == @initValue
          @disableSubmit()
          @disableReset() if @method == "post"
        else
          @enableSubmit()
          @enableReset()
      , @inputInterval

    @form.addEventListener 'reset', (e) =>
      unless window.confirm(@reset_button.dataset.confirm)
        e.preventDefault()
        return

      if @method == "patch"
        e.preventDefault()
        @delete_button.click()

      @disableSubmit()
      @disableReset()

  enableSubmit: ->
    @submit_button.disabled = false

  disableSubmit: ->
    setTimeout =>
      @submit_button.disabled = true
    , 0

  enableReset: ->
    @reset_button.disabled = false

  disableReset: ->
    setTimeout =>
      @reset_button.disabled = true
    , 0

document.addEventListener 'turbo:load', ->
  for form in document.getElementsByClassName('form-translation')
    new TranslationForm(form)

document.addEventListener 'turbo:frame-load', (e) ->
  for form in e.target.getElementsByClassName('form-translation')
    new TranslationForm(form)
