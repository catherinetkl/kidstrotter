import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing-animation"
export default class extends Controller {
  connect() {
    console.log("hi")
  }
}
