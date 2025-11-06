
checkParentChild = (parent, child) ->
  if !child?
    false
  else if parent == child
    true
  else
    checkParentChild(parent, child.parentElement)

export default bulkMailTextArea = (root = document) ->
  idPrefix = 'bulk_mail_'
  bodyEl = document.getElementById("#{idPrefix}body")
  colEl = document.getElementById("#{idPrefix}wrap_col")
  ruleEl = document.getElementById("#{idPrefix}wrap_rule")

  return unless bodyEl? && colEl? && ruleEl?
  return if root != document && !checkParentChild(root, bodyEl)

  console.debug 'bulk mail text area'

  setStyleBody = ->
    col = parseInt(colEl.value)
    rule = ruleEl.value
    if col > 0
      bodyEl.style.width = "#{(col / 2 + 3)}rem"
      bodyEl.style.whiteSpace = 'break-spaces'
      ruleEl.disabled = false
    else
      bodyEl.style.width = '100%'
      bodyEl.style.whiteSpace = 'pre'
      ruleEl.disabled = true

    switch rule
      when 'none'
        bodyEl.style.wordBreak = 'break-all'
        bodyEl.style.lineBreak = 'anywhere'
      when 'word_wrap'
        bodyEl.style.wordBreak = 'normal'
        bodyEl.style.lineBreak = 'loose'
      when 'jisx4051'
        bodyEl.style.wordBreak = 'normal'
        bodyEl.style.lineBreak = 'strict'
      else
        console.warn "unknown rule: #{rule}"

  colEl.addEventListener('change', setStyleBody)
  ruleEl.addEventListener('change', setStyleBody)

  setStyleBody()
