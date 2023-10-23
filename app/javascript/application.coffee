# Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

# Custom modules
import './src/bootstrap-trigger.coffee'
import './src/translation-index.coffee'
import bulkMailTextArea from './src/bulk-mail-textarea.coffee'
import templateInfo from './src/template-info.coffee'
import multiselect from './src/multiselect.coffee'
import uploadButton from './src/upload-button.coffee'

document.addEventListener 'turbolinks:load', ->
  bulkMailTextArea()
  templateInfo()
  multiselect()
  uploadButton()