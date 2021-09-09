# rails component

import ujs from '@rails/ujs'
ujs.start()

import turbolinks from 'turbolinks'
turbolinks.start()

# import * as activestorage from '@rails/activestorage'
# activestorage.start()

# import 'channels'

# other assets
require 'bootstrap-icons/bootstrap-icons.svg'

# custom modules

import 'src/bootstrap-trigger'
import BulkMailTextArea from 'src/bulk-mail-textarea'
import TemplateInfo from 'src/template-info'
import 'src/translation-index'

document.addEventListener 'turbolinks:load', ->
  BulkMailTextArea()
  TemplateInfo()
