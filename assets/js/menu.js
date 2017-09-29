document.addEventListener('DOMContentLoaded', () => {
  const burgers = document.querySelectorAll('.navbar-burger')

  for (const burger of burgers) {
    burger.addEventListener('click', () => {
      const target = document.querySelector(burger.dataset.target)

      burger.classList.toggle('is-active')
      target.classList.toggle('is-active')
    })
  }
})
