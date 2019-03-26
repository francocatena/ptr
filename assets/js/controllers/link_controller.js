import {Controller} from 'stimulus'

export default class extends Controller {
  static targets = ['action', 'link']

  connect () {
    if (Element.prototype.closest && document.documentElement.classList) {
      this.linkTargets.forEach(link => link.classList.add('is-hidden'))
      this.actionTargets.forEach(action => {
        action.classList.add('has-cursor-pointer')
      })
    }
  }

  open (event) {
    const hasNoLink = Element.prototype.closest && !event.target.closest('a')

    if (hasNoLink) {
      this.linkTarget.click()
    }
  }
}
