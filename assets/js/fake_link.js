document.addEventListener('click', event => {
  const linkLikeElement = event.target.closest('[data-link-like]')
  const hasLinkParent   = event.target.closest('a')

  if (linkLikeElement && !hasLinkParent) {
    const selector = linkLikeElement.dataset['target']
    const target   = linkLikeElement.querySelector(selector)

    target.click()
  }
})
