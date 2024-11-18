import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  show(event) {
    const notification = document.getElementById('copyNotification');

    // receiving message from event
    const message = event.detail.content;
    notification.textContent = message;

    // displaying a message, adding a class for smooth animation
    notification.classList.remove('opacity-0', 'pointer-events-none');
    notification.classList.add('opacity-100');
    
    // removing message in 3 seconds
    setTimeout(() => {
      notification.classList.remove('opacity-100');
      notification.classList.add('opacity-0', 'pointer-events-none');
    }, 3000);
  }
}
