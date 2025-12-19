import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="video-player"
export default class extends Controller {
  static targets = ["video", "loader"];

  connect() {
    // Hide video and show loader
    this.videoTarget.style.display = "none";
    this.loaderTarget.style.display = "block";

    this.showVideo = this.showVideo.bind(this);
    this.showError = this.showError.bind(this);

    // If video is already cached and can play, show it immediately
    if (this.videoTarget.readyState >= 3) {
      // HAVE_FUTURE_DATA
      this.showVideo();
    } else {
      // Otherwise, wait for the 'canplay' event
      this.videoTarget.addEventListener("canplay", this.showVideo);
      this.videoTarget.addEventListener("error", this.showError);
    }
  }

  disconnect() {
    this.videoTarget.removeEventListener("canplay", this.showVideo);
    this.videoTarget.removeEventListener("error", this.showError);
  }

  showVideo() {
    this.loaderTarget.style.display = "none";
    this.videoTarget.style.display = "block";
  }

  showError() {
    this.loaderTarget.innerHTML =
      '<p class="text-danger">Error loading video.</p>';
  }
}
