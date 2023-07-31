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
import bulkMailTextArea from 'src/bulk-mail-textarea'
import templateInfo from 'src/template-info'
import multiselect from 'src/multiselect'

document.addEventListener 'turbolinks:load', ->
  bulkMailTextArea()
  templateInfo()
  multiselect()
