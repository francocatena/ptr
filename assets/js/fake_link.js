document.addEventListener('click', event => {
  const linkLikeElement = event.target.closest('[data-link-like]')

  if (linkLikeElement) {
    const selector = linkLikeElement.dataset['target']
    const target   = linkLikeElement.querySelector(selector)

    target.click()
  }
})
