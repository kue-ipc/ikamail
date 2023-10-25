export default multiselect = (root = document) ->
  for el in root.getElementsByTagName('select')
    if el.multiple
      console.debug "mulit select: #{el.id}"
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
