export default multiselect = ->
  for el in document.getElementsByTagName('select')
    if el.multiple
      for optEl in el.getElementsByTagName('option')
        optEl.addEventListener 'mousedown', (e) ->
          e.preventDefault()
          pEl = @parentElement
          scrollTop = pEl.scrollTop
          @selected = !@selected
          pEl.focus()
          setTimeout ->
            pEl.scrollTop = scrollTop
          , 0
