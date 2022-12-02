import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {

  static values = {
    apiKey: String,
    markers: Array
  }

  static targets = ["map", "activities"]

  connect() {
    console.log("Map succesfully loaded")

    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10"
    });

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    const geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl });
    this.map.addControl(geocoder)

    geocoder.on('result', e => {
      console.log(e.result.center);
      const queryString = window.location.search;
      console.log(queryString);
      const url = `${queryString ? (queryString + "&") : "?"}lat=${e.result.center[1]}&lon=${e.result.center[0]}`
      fetch(url, {headers: {"Accept": "application/json"}})
        .then(response => response.json())
        .then((data) => {
          this.activitiesTarget.innerHTML = data.activities_partial
        })
  });
  }

    #addMarkersToMap() {
      this.markersValue.forEach((marker) => {
        const popup = new mapboxgl.Popup().setHTML(marker.info_window)
        new mapboxgl.Marker()
          .setLngLat([ marker.lng, marker.lat ])
          .setPopup(popup)
          .addTo(this.map);

        // const customMarker = document.createElement("div")
        // customMarker.className = "marker"
        // customMarker.style.backgroundImage = `url('${marker.image_url}')`
        // customMarker.style.backgroundSize = "contain"
        // customMarker.style.width = "25px"
        // customMarker.style.height = "25px"

        // new mapboxgl.Marker(customMarker)
        // .setLngLat([marker.lng, marker.lat])
        // .setPopup(popup)
        // .addTo(this.map)
      })
    }

    #fitMapToMarkers() {
      const bounds = new mapboxgl.LngLatBounds()
      this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 16, duration: 0 });
    }


}
