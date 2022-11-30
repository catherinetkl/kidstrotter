import { Controller } from "@hotwired/stimulus"
import Dropdown from 'stimulus-dropdown'

// Connects to data-controller="dropdown"
export default class extends Dropdown {
  connect() {

    this.HIDDEN_CLASS = this.data.get('hiddenClass') || 'is-hidden';
  }
  updateFilterType(event) {
    event.preventDefault()
    this.filterTargets.forEach(filterTarget) =>
      filterTarget.classList.add(this.HIDDEN_CLASS),
    );

    document
    .querySelector(`[name="${event.target.value}"]`)
    .classList.remove(this.HIDDEN_CLASS);

    this.itemTargets.forEach(element) =>
      element.classList.remove(this.HIDDEN_CLASS),
    );
  }
  updateFilter(event){
    const USER_INPUT = event.target.value

    if (!USER_INPUT) {
      this.ITEMS.forEach((element) =>
      element.classList.remove(this.HIDDEN_CLASS));
      return;
    }
  }
}
