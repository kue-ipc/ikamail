import ujs from '@rails/ujs'
ujs.start()

import turbolinks from 'turbolinks'
turbolinks.start()

# import * as activestorage from '@rails/activestorage'
# activestorage.start()

# import 'channels'

# images = require.context('../images', true)
# imagePath = (name) => images(name, true)

require 'bootstrap-icons/bootstrap-icons.svg'
# imagePath = (name) => images(name, true)
# console.log()


import 'bootstrap'

import BulkMailTextArea from 'src/bulk-mail-textarea'
import TemplateInfo from 'src/template-info'
import 'src/translation-index'

document.addEventListener 'turbolinks:load', ->
  BulkMailTextArea()
  TemplateInfo()
