import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    document.addEventListener("click", this.closeOnClickOutside.bind(this));
  }

  toggle(event) {
    event.stopPropagation(); // Prevents auto-closing
    this.menuTarget.classList.toggle("hidden");
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
