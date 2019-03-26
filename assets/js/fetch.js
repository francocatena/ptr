export const getScript = url => {
  const headers = {
    'Accept':           'application/javascript',
    'X-Requested-With': 'XMLHttpRequest' // Just to "trick" plug CSRF protection
  }
  const options = {
    headers,
    method:      'GET',
    credentials: 'same-origin'
  }

  fetch(url, options).then(response => {
    if (response.ok) {
      return response.text()
    }

    throw new Error('Network response was not OK.')
  }).then(text => {
    const script = document.createElement('script')

    script.text = text

    document.head.appendChild(script).parentNode.removeChild(script)
  }).catch(error => {
    console.log('Error in fetch operation: ', error.message)
  })
}
