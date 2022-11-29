import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bookmark"
export default class extends Controller {
  connect() {
    // console.log("Connected:", this.element)
  }

  toggleFavorite(e) {
    e.preventDefault()

    const target = e.currentTarget

    fetch(target.href, {
      headers: {
        "Accept": "text/plain"
      }
    })
    .then(res => res.text())
    .then(data => {
      target.outerHTML = data
    })
  }
}
