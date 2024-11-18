import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  getPass(e) {
    const passwordValue = e.target.value;
    navigator.clipboard.writeText(passwordValue);
    this.dispatch('copy', { detail: { content: 'Password has been copied!' } });
  }
}
