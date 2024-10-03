import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

export default class extends Controller {
  async connect() {
    const incrementViewsUrl = this.element.dataset.incrementViewsUrl
    if (!incrementViewsUrl) {
      console.error('No increment views URL provided');
      return;
    }

    const response = await patch(incrementViewsUrl, {
      headers: {
        'Accept': 'text/plain',
        'Content-Type': 'application/json'
      }
    });

    if (response.ok) {
      console.log(await response.text);
    } else {
      console.error('Failed to increment views');
    }
  }
}
