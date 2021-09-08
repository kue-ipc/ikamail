import ujs from '@rails/ujs'
ujs.start()

import turbolinks from 'turbolinks'
turbolinks.start()

import * as activestorage from '@rails/activestorage'
activestorage.start()

import 'channels'

# require("@rails/ujs").start()
# require("turbolinks").start()
# require("@rails/activestorage").start()
# require("channels")

# images = require.context('../images', true)
# imagePath = (name) => images(name, true)

# import 'src/bootstrap-native'
import BulkMailTextArea from 'src/bulk-mail-textarea'
import TemplateInfo from 'src/template-info'
import 'src/translation-index'

document.addEventListener 'turbolinks:load', ->
  BulkMailTextArea()
  TemplateInfo()
