import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile-menu"
export default class extends Controller {
  static targets = ["menu", "overlay", "trigger"]

  connect() {
    this.isOpen = false
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.isOpen = !this.isOpen

    if (this.isOpen) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.remove('translate-x-full')
      this.menuTarget.classList.add('translate-x-0')
    }
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove('hidden')
      this.overlayTarget.classList.add('block')
    }
    document.body.style.overflow = 'hidden'
  }

  close() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.remove('translate-x-0')
      this.menuTarget.classList.add('translate-x-full')
    }
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add('hidden')
      this.overlayTarget.classList.remove('block')
    }
    document.body.style.overflow = ''
    this.isOpen = false
  }

  closeOnOverlayClick(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }
}

