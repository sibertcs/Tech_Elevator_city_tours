<template>
<div id="manage-whole-page">
  <div id="manageItineraryWrapper">
    <div id="serverResponse" v-if="serverMessage.length > 0">
      <span>{{serverMessage}}</span>
    </div>
    <form @submit.prevent="saveChanges" v-if="itinerary != null && displayMode == 'manage'">
      <div class="manage-itinerary card">
        <div class="form-group">
          <label for="itineraryName">Itinerary Name</label>
          <input
            type="text"
            class="form-control"
            id="itineraryName"
            placeholder="Name"
            v-model.trim="itinerary.name"
          />
          <div>Please provide a valid itinerary name.</div>
        </div>
        <div class="form-group">
          <label for="startDate">Date 📅</label>
          <input
            v-if="itinerary.itineraryDate != null"
            type="date"
            class="form-control"
            id="startDate"
            placeholder="YYYY/MM/DD"
            v-model="itinerary.itineraryDate.split('T')[0]"
            v-on:change="dateChanged"
          />
          <div>Please provide a valid date.</div>
        </div>
        <div class="form-group">
          <label for="startingAddress">Starting Address</label>
          <input
            type="text"
            class="form-control"
            id="startingAddress"
            placeholder="1234 Main St, City, State, Zip Code."
            v-model.trim="itinerary.startingLocation"
          />
          <div>Please provide a valid starting address.</div>
        </div>
        <div id="landmarksWrapper">
          <div
            class="landmark-itinerary-object"
            v-for="landmark in itinerary.landmarks"
            v-bind:key="'landmark'+landmark.landmarkID"
          >
            <div class="landmark-sort-order-wrapper">
              <span>{{landmark.sortOrder}}) </span>
              <a class="linkToDetails" v-on:click="redirectToDetails(landmark.landmarkID)">{{landmark.landmark.name}}</a>
            </div>
            <div class="landmark-name-wrapper">
              <b-button
                class="btn-success"
                id="itinerary-buttons"
                v-on:click="moveLandmarkUp(landmark)"
              >▲</b-button>
              <b-button
                class="btn-info"
                id="itinerary-buttons"
                v-on:click="moveLandmarkDown(landmark)"
              >▼</b-button>
              <b-button
                class="btn-danger"
                id="itinerary-buttons"
                v-on:click="removeLandmarkFromItinerary(landmark.landmarkID)"
              >REMOVE 🗑</b-button>
            </div>
          </div>
        </div>
        <div id="four-buttons">
          <div id="dropdown-create-delete">
            <b-button id="addALandmark" v-on:click="redirectMethod">Add Landmark</b-button>
            <b-button id="deleteItinerary" v-on:click="deleteItinerary">Delete Itinerary</b-button>
            <b-button id="createTravelRoute" v-on:click="swapView">Generate Travel Route</b-button>
          </div>
        </div>

        <div class="float-right">
          <button
            id="save-itinerary-button"
            type="submit"
            class="btn btn-lg btn-primary btn-block btn-secondary"
          >Save Itinerary</button>
        </div>
      </div>
    </form>
    <div id="travel-route" v-if="travelRoute != null && travelRoute.length > 0 && displayMode == 'route'" class="card">
      <div class="site-search">
        <b-button v-on:click="swapView" style="margin-bottom: 1em;"><i class="fa fa-arrow-left" aria-hidden="true"></i> Back To Manage</b-button><h1>Courtesy Of {{mapquestData.info.copyright.text}}</h1>
        <b-button v-on:click="print">Print</b-button>
        <div class="travel-route-direction" v-for="direction in travelRoute" v-bind:key="'tr-' + travelRoute.indexOf(direction)">
          <p>{{direction}}</p>
        </div>
      </div>
    </div>
  </div>
  </div>
</template>
<style scoped>
  .linkToDetails:hover{
    cursor: pointer;
    text-decoration: underline;
  }
</style>

<script>
import auth from "../auth";
//import AppVue from '../App.vue';
export default {
  name: "manage-itinerary",
  data() {
    return {
      itinerary: Object,
      userItineraries: [Object],
      sortOrderChanged: false,
      itineraryChanged: false,
      isAddALandmark: false,
      landmarkAddedOnDB: false,
      serverMessage: "",
      searchQuery: "",
      incomingLandmarkID: Number,
      userID: auth.getUser().id,
      mapquestData: null,
      travelRoute: [],
      travelRoutes: { "setOfDirections": []},
      displayMode: "manage"
    };
  },
  methods: {
    //New method:
    getItinerary() {
      const apiEndpoint = `getuseritinerary/${this.userID}`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        }
      })
        .then(response => {
          if (response.ok) {
            return response.json();
          }
        })
        .then(data => {
          this.itinerary = data;
          this.getIncomingLandmark();          
        });
    },
    dateChanged(){
      this.itinerary.itineraryDate = document.getElementById("startDate").value;
    },
    //New method:
    saveChanges() {
      this.EditItinerary();
      if (!this.landmarkAddedOnDB) {
        this.AddLandmarksToItinerary();
      }
      if (this.sortOrderChanged) {
        this.updateSortOrders();
      }
      this.mapquestData = null
      alert("changes saved successfully");
      this.$router.push({path: "/"});
    },
    //New method:
    EditItinerary() {
      const apiEndpoint = `edititinerary`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        },
        body: JSON.stringify(this.itinerary)
      })
        .then(response => {
          if (response.ok) {
            return response;
          }
        })
        .then(message => {
          this.serverMessage = message;
        });
    },
    //New method:
    AddLandmarksToItinerary() {
      const apiEndpoint = `addlandmarkstoitinerary`;

      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        },

        body: JSON.stringify(this.itinerary)
      })
        .then(response => {
          if (response.ok) {
            this.landmarkAddedOnDB = true;
            return response;
          }
        })
        .then(message => {
          this.serverMessage = message;
        });
    },
    //New method:
    onSelectChange() {
      let nextItinerary = this.userItineraries.find(itinerary => {
        return (
          itinerary.itineraryID ==
          document.getElementById("itineraryDropDown").value
        );
      });
      this.setSelectedItinerary(nextItinerary);
    },
    //New method:
    getUserItinerary() {
      const userID = auth.getUser().id;
      const apiEndpoint = `getuseritinerary/${userID}`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        }
      })
        .then(response => {
          if (response.ok) {
            return response.json();
          }
        })
        .then(data => {
          this.itinerary = data;
        });
    },
    //New method:
    getUserItineraries() {
      const userID = auth.getUser().id;
      const apiEndpoint = `getusersitineraries/${userID}`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        }
      })
        .then(response => {
          if (response.ok) {
            return response.json();
          }
        })
        .then(data => {
          this.userItineraries = data;
        });
    },
    //New method:
    getItineraryById(itineraryID) {
      const apiEndpoint = `getitinerarybyid/${itineraryID}`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        }
      })
        .then(response => {
          if (response.ok) {
            return response.json();
          }
        })
        .then(data => {
          this.itinerary = data;
        });
    },
    //New method:
    setSelectedItinerary(nextItinerary) {
      const apiEndpoint = `setselecteditinerary`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getToken()
        },
        body: JSON.stringify(nextItinerary)
      })
        .then(response => {
          if (response.ok) {
            this.$router.go(0);
          }
        })
        .catch(err => console.error(err));
    },
    loadData() {
      this.getItinerary();
      this.getUserItineraries();
    },
    //New method:
    getIncomingLandmark() {
      if (
        this.$route.params.landmark_id != null &&
        this.$route.params.landmark_id != 0
      ) {
        this.incomingLandmarkID = this.$route.params.landmark_id;
        if (
          this.itinerary.landmarks.find(landmark => {
            return landmark.landmarkID == this.incomingLandmarkID;
          }) == null
        ) {
          fetch(
            `${process.env.VUE_APP_REMOTE_API_LANDMARKS}/getlandmark/${this.incomingLandmarkID}`
          )
            .then(response => {
              if (response.ok) {
                return response.json();
              }
            })
            .then(data => {
              let newLandmark = {
                landmarkID: data.id,
                name: data.name,
                sortOrder:
                  this.itinerary.landmarks.length == 0
                    ? 1
                    : this.getMaxSortOrder() + 1,
                landmark: data,
                addedByClient: true,
                hasLandmarkObject: true
              };
              this.itinerary.landmarks.push(newLandmark);
            })
            .catch(err => console.error(err));
        } else {
          this.landmarkAddedOnDB = true;
        }
      }
    },
    //New method:
    deleteItinerary() {
      if (confirm("Are you sure?")) {
        const apiEndpoint = `deleteitinerary/${this.itinerary.itineraryID}`;
        fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + auth.getUser()
          }
        }).then(response => {
          if (response.ok) {
            this.$router.push({path: "/AllItineraries"});
          }
        });
      }
    },
    //New method:
    createItinerary() {
      const userID = auth.getUser().id;
      const apiEndpoint = `createitinerary/${userID}`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getUser()
        }
      }).then(response => {
        if (response.ok) {
          this.$router.go(0);
        }
      });
    },
    //New method:
    removeLandmarkFromItinerary(landmarkIdToRemove) {
      if (confirm("Are you sure?")) {
        let body = {
          itineraryID: this.itinerary.itineraryID,
          landmarkID: landmarkIdToRemove
        };
        const apiEndpoint = `RemoveLandmarkFromItinerary/`;
        fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + auth.getUser()
          },
          body: JSON.stringify(body)
        }).then(response => {
          if (response.ok) {
            this.itinerary.landmarks = this.itinerary.landmarks.filter(
              landmark => {
                return landmark.landmarkID != landmarkIdToRemove;
              }
            );
            if(this.itinerary.landmarks.length == 0){
              this.$router.push("/");
            }
            if(landmarkIdToRemove ==  this.incomingLandmarkID && this.incomingLandmarkID != 0){
              this.incomingLandmarkID = 0;
              this.$router.push("/ManageItinerary/0");
            }
            this.getItinerary();                                    
          }
        });
      }
    },
    //New method:
    redirectMethod() {
      if (!this.landmarkAddedOnDB) {
        this.AddLandmarksToItinerary();
      }
      this.$router.push({path: "/"});
    },
    //New method:
    redirectToDetails(id) {
      if (!this.landmarkAddedOnDB) {
        this.AddLandmarksToItinerary();
      }
      this.$router.push({path: "/LandmarkDetails/" + id});
    },
    //New method:
    moveLandmarkUp(landmark) {
      if (landmark.sortOrder > 1) {
        landmark.sortOrder--;
        this.itinerary.landmarks.find(otherLandmark => {
          return (
            otherLandmark.sortOrder == landmark.sortOrder &&
            otherLandmark.landmarkID != landmark.landmarkID
          );
        }).sortOrder++;
        this.sortLandmarks();
      }
    },
    //New method:
    moveLandmarkDown(landmark) {
      let maxSortOrder = this.getMaxSortOrder();
      if (landmark.sortOrder < maxSortOrder) {
        landmark.sortOrder++;
        this.itinerary.landmarks.find(otherLandmark => {
          return (
            otherLandmark.sortOrder == landmark.sortOrder &&
            otherLandmark.landmarkID != landmark.landmarkID
          );
        }).sortOrder--;
        this.sortLandmarks();
      }
    },
    //New method:
    getMaxSortOrder() {
      let maxSortOrder = 1;
      if (this.itinerary.landmarks.length > 0) {
        maxSortOrder = this.itinerary.landmarks[0].sortOrder;
        for (let i = 0; i < this.itinerary.landmarks.length; i++) {
          if (this.itinerary.landmarks[i].sortOrder > maxSortOrder) {
            maxSortOrder = this.itinerary.landmarks[i].sortOrder;
          }
        }
      }
      return maxSortOrder;
    },
    //New method:
    sortLandmarks() {
      this.itinerary.landmarks = this.itinerary.landmarks.sort(function(a, b) {
        return a.sortOrder - b.sortOrder;
      });
      this.sortOrderChanged = true;
    },
    //New method:
    updateSortOrders() {
      const apiEndpoint = `EditItineraryLandmarkSortOrder`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getToken()
        },
        body: JSON.stringify(this.itinerary)
      })
        .then(response => {
          if (response.ok) {
            this.sortOrderChanged = false;
            this.$router.push(("/ManageItinerary/" + this.incomingLandmarkID.toString()))
          }
        })
        .catch(err => console.error(err));
    },
    //New method:
    searchforResult(searchQuery) {
      this.searchQuery = searchQuery;
      if (this.isAddALandmark) {
        this.searchResultsKey += 1; //force re-render
      } else {
        this.isAddALandmark = true; // first render
      }
    },
    getTravelRoute(){
      let addresses = [];
      addresses.push(this.itinerary.startingLocation);
      for(let i = 0; i < this.itinerary.landmarks.length; i++){
        let fullAddress = this.itinerary.landmarks[i].landmark.streetAddress + ", " + this.itinerary.landmarks[i].landmark.city + ", " + this.itinerary.landmarks[i].landmark.state;
        addresses.push(fullAddress);
      }
      if(addresses.length < 2 && addresses[0] != ''){
        return;
      }
      let options = {
        "avoids": [],
        "avoidTimedConditions": false,
        "doReverseGeocode": true,
        "shapeFormat": "raw",
        "generalize": 0,
        "routeType": "fastest",
        "timeType": 1,
        "locale": "en_US",
        "unit": "m",
        "enhancedNarrative": false,
        "drivingStyle": 2,
        "highwayEfficiency": 21.0
      }
      let requestBody = {
        "locations": addresses,
        "options": options
      };
      fetch(`http://www.mapquestapi.com/directions/v2/route?key=${process.env.VUE_APP_MAP_QUEST_API_KEY}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        mode: 'cors',
        body: JSON.stringify(requestBody)
      })
        .then(response => {
          if (response.ok) {
            return response.json();
            
          }
        }).then(data => {

          this.mapquestData = data;
          for(let i = 0; i < data.route.legs.length; i++){
            let setOfDirections = {              
              "directions": [],
              "time": String,
              "distance": Number
              };
            this.travelRoute.push("Distance: " + data.route.legs[i].distance.toString() + " miles. Est duration: " + data.route.legs[i].formattedTime);
            for(let j = 0; j < data.route.legs[i].maneuvers.length; j++){
              this.travelRoute.push(data.route.legs[i].maneuvers[j].narrative + "    (" + data.route.legs[i].maneuvers[j].distance + "mi)");
              setOfDirections.directions.push(data.route.legs[i].maneuvers[j].narrative);
              setOfDirections.time = data.route.legs[i].formattedTime;
              setOfDirections.distance = data.route.legs[i].distance;
            }
            this.travelRoute.push(`--ARRIVE AT ${this.itinerary.landmarks[i].landmark.name }--`);
            this.travelRoutes.setOfDirections.push(setOfDirections);
            this.displayMode = "route";
          }
          console.log(this.travelRoute);
          console.log(this.travelRoutes);
        });
      
    },
    backToManage(){
      this.displayMode = "manage";
    },
    swapView(){
      if(this.displayMode == "manage"){
        this.displayMode = "route";
        if(this.mapquestData == null){
            this.getTravelRoute();
        }
      }
      else{
        this.displayMode = "manage";
      }
    },
    print(){
      window.print();
    }
  },
  created() {
    this.loadData();
  }
};
</script>

<style>
</style>