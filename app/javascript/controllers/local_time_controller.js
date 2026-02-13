import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const date = new Date(this.element.getAttribute("datetime"))
    this.element.textContent = date.toLocaleString()
  }
}
