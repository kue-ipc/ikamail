class TranslationForm
  constructor: (form) ->
    @form = form
    @key = @form.dataset.key.toString()
    @form_id = @form.id
    @method = @form._method?.value ? @form.method
    @value_input = @form['translation[value]']

    @submit_button = document.getElementById("#{@form_id}-submit")
    @reset_button = document.getElementById("#{@form_id}-reset")
    @delete_button = document.getElementById("#{@form_id}-delete")

    @value_input.addEventListener 'input', =>
      @enableSubmit()

    @form.addEventListener 'reset', (e) =>
      unless window.confirm(@reset_button.dataset.confirm)
        e.preventDefault()
        return

      if @method == "patch"
        e.preventDefault()
        @delete_button.click()

  enableSubmit: ->
    @submit_button.disabled = false

  disableSubmit: ->
    setTimeout =>
      @submit_button.disabled = true
    , 0

  destroiedRecord: (path, value) ->
    @form.action = path

    @form._method.remove()

    @value_input.value = value

    @disableSubmit()

    @delete_link.classList.add('d-none')
    @delete_link.classList.add('disabled')
    @delete_link.setAttribute('area-disabled', 'true')
    @delete_link.href = '#'

  createdRecord: (path, _value) ->
    @disableSubmit()

    @form.action = path

    method_input = document.createElement('input')
    method_input.name = '_method'
    method_input.type = 'hidden'
    method_input.value = 'patch'
    @form.appendChild(method_input)

    # do not modified @value_input

    @disableSubmit()

    @delete_link.href = path
    @delete_link.setAttribute('area-disabled', 'false')
    @delete_link.classList.remove('disabled')
    @delete_link.classList.remove('d-none')

  updatedRecord: (_path, _value) ->
    @disableSubmit()

document.addEventListener 'turbo:load', ->
  for form in document.getElementsByClassName('form-translation')
    new TranslationForm(form)
