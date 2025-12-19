import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video-player"
export default class extends Controller {
  static targets = [ "video", "loader", "thumbnail" ]

  connect() {
    this.showVideo = this.showVideo.bind(this);
    this.showError = this.showError.bind(this);

    this.videoTarget.addEventListener('canplay', this.showVideo);
    this.videoTarget.addEventListener('error', this.showError);
  }

  disconnect() {
    this.videoTarget.removeEventListener('canplay', this.showVideo);
    this.videoTarget.removeEventListener('error', this.showError);
  }

  play() {
    this.thumbnailTarget.style.display = 'none';
    this.loaderTarget.style.display = 'block';
    this.videoTarget.load();
    this.videoTarget.play();
  }

  showVideo() {
    this.loaderTarget.style.display = 'none';
    this.videoTarget.style.display = 'block';
  }

  showError() {
    this.loaderTarget.innerHTML = '<p class="text-danger">Error loading video.</p>';
  }
}