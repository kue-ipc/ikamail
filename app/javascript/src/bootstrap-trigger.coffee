# bootstrap components
# Alert, Button, Carousel, Collapse, Dropdown, Modal, Offcanvas, Popover, ScrollSpy, Tab, Toast, Tooltip
import * as bootstrap from 'bootstrap'

bootstrapComponentSelectors = [
  {component: bootstrap.Popover,   selector: '[data-bs-toggle="popover"]'}
  {component: bootstrap.Tooltip,   selector: '[data-bs-toggle="tooltip"]'}
  {component: bootstrap.Collapse,  selector: '[data-bs-toggle="collapse"]'}
]

export default bootstrapTriger = (root = document) ->
  for {component, selector} in bootstrapComponentSelectors
    for el in root.querySelectorAll selector
      console.debug("bootstrap component: #{component.name}")
      new component(el)
