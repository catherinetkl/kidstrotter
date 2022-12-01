import { Controller } from "@hotwired/stimulus"
import { Button } from "bootstrap"

export default class extends Controller {
  static targets = ["namebtn"]

  connect() {
    console.log("Button loaded")
  }

  //  namebtn is the @activity.name of the card in activity#index

  // 1.) The action queryinput causes the data-target namebtn to do the autofill action (Listed below) when clicked:

  queryinput() {
    console.log("Clicked")

  }

  // 2.) Fills the pgsearch bar with the @activity.name of current card, and then submits the query by clicking the search button:
  // This is to simulate the user typing out the name of the location in the searchbar, and then clicking the search button.
  // Instead of doing that, he can also click the name of the activity on the card to do the same thing.

  autofill() {
    console.log("Searching")

  }

  // 3.) When queryinput and autofill runs. The desired outcome will be to show the location of the card, and the map will zoom in onto that location
}
