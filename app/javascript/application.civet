# Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

# Custom modules
import bootstrapTriger from './src/bootstrap-trigger.coffee'
import bulkMailTextArea from './src/bulk-mail-textarea.coffee'
import multiselect from './src/multiselect.coffee'
import templateInfo from './src/template-info.coffee'
import translaitonIndex from './src/translation-index.coffee'
import uploadButton from './src/upload-button.coffee'

loadAll = (root = document) ->
  bootstrapTriger(root)
  bulkMailTextArea(root)
  multiselect(root)
  templateInfo(root)
  translaitonIndex(root)
  uploadButton(root)

document.addEventListener 'turbo:load', (e) ->
  console.debug 'turbo load'
  loadAll()

document.addEventListener 'turbo:frame-load', (e) ->
  console.debug "turbo-frame load: #{e.target.id}"
  loadAll(e.target)
