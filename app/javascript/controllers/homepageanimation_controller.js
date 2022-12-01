import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="homepageanimation"
export default class extends Controller {
  connect() {
    console.log("Homepage loaded")
    // const tl = gsap.timeline({ defaults: {ease: "power1.out"}})
    // tl.to('.text', { y: "0%", duration: 1});
  }
}
