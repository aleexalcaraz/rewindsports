import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="buscar"
export default class extends Controller {
  static targets = [ "clubSelect", "courtSelect" ]

  fetchCourts() {
    let clubId = this.clubSelectTarget.value;
    let courtSelect = this.courtSelectTarget;

    if (clubId) {
      fetch(`/buscar/courts?club_id=${clubId}`)
        .then(response => response.json())
        .then(data => {
          courtSelect.innerHTML = '<option value="">Select a court</option>';
          data.forEach(court => {
            let option = document.createElement("option");
            option.value = court.id;
            option.text = court.name;
            courtSelect.appendChild(option);
          });
          courtSelect.disabled = false;
        });
    } else {
      courtSelect.innerHTML = '<option value="">Select a club first</option>';
      courtSelect.disabled = true;
    }
  }
}
