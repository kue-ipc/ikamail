class TranslationForm
  constructor: (form) ->
    @form = form
    @key = @form.dataset.key.toString()
    @form_id = @form.id
    @value_input = document.getElementById("#{@form_id}-value")
    @submit_button = document.getElementById("#{@form_id}-submit")
    @delete_link = document.getElementById("#{@form_id}-delete")

    @value_input.addEventListener 'input', =>
      @enableSubmit()

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

formMap = new Map

for form in document.getElementsByClassName('form-translation')
  tForm = new TranslationForm(form)
  formMap.set(tForm.key, tForm)

window.TRANSLATION_FORM_MAP = formMap
