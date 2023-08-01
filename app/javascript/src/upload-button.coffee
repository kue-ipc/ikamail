export default uploadButton = ->
  for form in document.forms
    uploadButton = null
    fileInput = null
    for el in form.elements
      if el.name == 'upload' && el.tagName.toUpperCase() == 'BUTTON'
        uploadButton = el
      else if el.name == 'file' && el.tagName.toUpperCase() == 'INPUT'
        fileInput = el

    if uploadButton? && fileInput?
      addUploadEvent(form, uploadButton, fileInput)

addUploadEvent = (form, uploadButton, fileInput) ->
  return if form.classList.contains('ready-upload')

  form.classList.add('ready-upload')
  uploadButton.addEventListener 'click', (e) ->
    e.preventDefault()
    fileInput.click()
  fileInput.addEventListener 'change', (e) ->
    form.submit()
