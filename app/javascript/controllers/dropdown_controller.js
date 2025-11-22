import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Close dropdown when clicking outside
    this.boundCloseOnOutsideClick = this.closeOnOutsideClick.bind(this)
    document.addEventListener("click", this.boundCloseOnOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.boundCloseOnOutsideClick)
  }

  toggle(event) {
    event.stopPropagation()
    const isOpen = this.menuTarget.classList.contains("opacity-100")
    
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.remove("opacity-0", "invisible")
    this.menuTarget.classList.add("opacity-100", "visible")
  }

  close() {
    this.menuTarget.classList.remove("opacity-100", "visible")
    this.menuTarget.classList.add("opacity-0", "invisible")
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}

