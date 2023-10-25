export default templateInfo = (root = document)->
  # TODO: turbo-frame対応
  #       離れているtemplate-infoは更新されないから、それを含めて作り直すこと
  return if root != document

  templateInfoEl = document.getElementById('template-info')
  return unless templateInfoEl?

  console.debug "template info"

  descriptionEls = document.getElementsByClassName('template-info-description')
  nameEls = document.getElementsByClassName('template-info-name')
  recipientListEls = document.getElementsByClassName('template-info-recipient-list')
  userEls = document.getElementsByClassName('template-info-user')
  reservedTimeEls = document.getElementsByClassName('template-info-reserved-time')

  list = JSON.parse(templateInfoEl.getAttribute('data-list'))
  targetEl = document.getElementById(templateInfoEl.getAttribute('data-target'))

  changeSelect = ->
    selectedId = targetEl.value
    if /^\d+$/.test(selectedId)
      selected = list[selectedId]
      for el in descriptionEls
        el.innerText = selected.description
      for el in nameEls
        el.textContent = selected.name
      for el in recipientListEls
        el.textContent = selected.recipient_list
      for el in userEls
        el.textContent = selected.user
      for el in reservedTimeEls
        el.textContent = selected.reserved_time
    else
      for el in descriptionEls
        el.innerText = ''
      for el in nameEls
        el.textContent = '-'
      for el in recipientListEls
        el.textContent = '-'
      for el in userEls
        el.textContent = '-'
      for el in reservedTimeEls
        el.textContent = '-'

  targetEl.addEventListener 'change', changeSelect
  changeSelect()
