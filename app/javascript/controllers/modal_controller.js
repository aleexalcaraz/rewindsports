import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    if (typeof this.element.showModal === "function") {
      this.element.showModal();
    } else {
      console.error(
        "The element connected to the modal controller does not have a showModal method. Is it a <dialog> element?"
      );
    }
  }
}
