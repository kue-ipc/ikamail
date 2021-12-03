# Ralis component
import ujs from '@rails/ujs'
ujs.start()

import turbolinks from 'turbolinks'
turbolinks.start()

# import * as activestorage from '@rails/activestorage'
# activestorage.start()

# import 'channels'

# Custom modules
import 'src/bootstrap-trigger'
import 'src/translation-index'
import BulkMailTextArea from 'src/bulk-mail-textarea'
import TemplateInfo from 'src/template-info'

document.addEventListener 'turbolinks:load', ->
  BulkMailTextArea()
  TemplateInfo()
