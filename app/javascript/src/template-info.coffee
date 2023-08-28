export default templateInfo = ->
  templateInfoEl = document.getElementById('template-info')
  return unless templateInfoEl?

  list = JSON.parse(templateInfoEl.getAttribute('data-list'))
  console.log list
  target = templateInfoEl.getAttribute('data-target')

  descriptionEls = document.getElementsByClassName('template-info-description')
  nameEls = document.getElementsByClassName('template-info-name')
  recipientListEls = document.getElementsByClassName('template-info-recipient-list')
  userEls = document.getElementsByClassName('template-info-user')
  reservedTimeEls = document.getElementsByClassName('template-info-reserved-time')

  targetEl = document.getElementById(target)

  changeSelect = ->
    selectedId = targetEl.value
    if /^\d+$/.test(selectedId)
      selected = list[selectedId]
      for el in descriptionEls
        el.innerText = selected.description
      for el in nameEls
        el.textContent = selected.name
      for el in recipientListEls
        el.textContent =
          if selected.recipient_list_description
            "#{selected.recipient_list} (#{selected.recipient_list_description})"
          else
            selected.recipient_list
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
