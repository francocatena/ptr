document.addEventListener('click', event => {
  let element  = event.target
  let selector = element.dataset['delete']
  let parent   = selector && element.closest && element.closest(selector)

  parent && parent.remove()
})
