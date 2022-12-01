import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="test"
export default class extends Controller {
  connect() {
    console.log("Landing Animation Loaded")

    const tl = gsap.timeline({ defaults: {ease: "power1.out"}})
    tl.to('.text', { y: "0%", duration: 1});
    tl.to('.slider', { y: "-100%", duration: 1.5});
  }
}
