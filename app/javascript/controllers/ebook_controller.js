import { Controller } from "@hotwired/stimulus"
import { patch, get } from "@rails/request.js"

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

  async fetchSummary(event) {
    event.preventDefault();
    const fetchSummaryUrl = this.element.dataset.fetchSummaryUrl;
    if (!fetchSummaryUrl) {
      console.error('No URL provided to fetch ebook summary');
      return;
    }

    const response = await get(fetchSummaryUrl, {
      headers: {
        'Accept': 'application/json'
      }
    });

    const summaryContainer = document.getElementById("summaryContainer");

    if (response.ok) {
      const payload = await response.text;
      const decodedPayload = JSON.parse(payload);

      if (!decodedPayload || !decodedPayload.result) {
        console.error("Could not decode the response result.")
        return;
      }

      const results = decodedPayload.result;
      let containerContent;

      if (results.length === 0 || results[0].summary === "") {
        containerContent = "No results available for this ebook."
      } else {
        containerContent = results[0].summary;
      }
      summaryContainer.textContent = containerContent;
    } else {
      summaryContainer.textContent = "Failed to get results."
      console.error("Failed to fetch summary data", response);
    }
  }
}
