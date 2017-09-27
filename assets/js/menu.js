document.addEventListener('DOMContentLoaded', () => {
  const burgers = document.querySelectorAll('.navbar-burger')

  burgers.forEach($el => {
    $el.addEventListener('click', () => {
      const $target = document.querySelector($el.dataset.target)

      $el.classList.toggle('is-active')
      $target.classList.toggle('is-active')
    })
  })
})
