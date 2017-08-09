document.addEventListener('DOMContentLoaded', () => {
  let burgerList     = document.querySelectorAll('.navbar-burger')
  let $navbarBurgers = Array.prototype.slice.call(burgerList, 0)

  if ($navbarBurgers.length) {
    $navbarBurgers.forEach($el => {
      $el.addEventListener('click', () => {
        let $target = document.getElementById($el.dataset.target)

        $el.classList.toggle('is-active')
        $target.classList.toggle('is-active')
      })
    })
  }
})
