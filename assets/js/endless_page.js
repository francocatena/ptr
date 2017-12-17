import {getScript} from './fetch'

const loading = () => {
  const pagination = document.querySelector('.pagination')
  const loading    = document.createElement('a')

  loading.className       = 'button is-medium is-warning is-block is-loading'
  loading.dataset.loading = true

  if (pagination) {
    // TODO: replace when Edge supports replaceWith
    pagination.parentNode.replaceChild(loading, pagination)
  }
}

const loadNextPage = () => {
  const nextPage = document.querySelector('.pagination-link[rel=next]')
  const url      = nextPage && nextPage.href

  if (url) {
    loading()
    getScript(url)
  }
}

if ('IntersectionObserver' in window) {
  document.addEventListener('DOMContentLoaded', () => {
    const sentinel = document.querySelector('[data-intersection-sentinel]')
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          loadNextPage()
        }
      })
    })

    if (sentinel) {
      observer.observe(sentinel)
    }
  }, false)
}

document.addEventListener('ptr:nextContentLoaded', () => {
  const sentinel       = document.querySelector('[data-intersection-sentinel]')
  const rect           = sentinel.getBoundingClientRect()
  const isIntersecting = rect.top >= 0 && rect.top <= window.innerHeight * 1.01

  if (isIntersecting) {
    loadNextPage()
  }
}, false)
