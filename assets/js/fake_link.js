document.body.addEventListener('click', event => {
  const linkLikeElement = event.target.closest('[data-link-like]')
  const hasParentLink   = event.target.closest('a')

  if (linkLikeElement && !hasParentLink) {
    const selector = linkLikeElement.dataset['target']
    const target   = linkLikeElement.querySelector(selector)

    target.click()
  }
})
