<template>
  <div id="manageItineraryWrapper">
    <div id="serverResponse" v-if="serverMessage.length > 0">
      <span>{{serverMessage}}</span>
    </div>    
    <form @submit.prevent="saveChanges">
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
          <label for="startDate">Date</label>
          <input
            v-if="itinerary.itineraryDate != null"
            type="date"
            class="form-control"
            id="startDate"
            placeholder="YYYY/MM/DD"
            v-model.trim="itinerary.itineraryDate.split('T')[0]"
          />
          <div>Please provide a valid date.</div>
        </div>
        <div class="form-group">
          <label for="startingAddress">Starting Address</label>
          <input
            type="text"
            class="form-control"
            id="startingAddress"
            placeholder="1234 Main St"
            v-model.trim="itinerary.startingLocation"
          />
          <div>Please provide a valid starting address.</div>
        </div>
        <div id="landmarksWrapper">
          <div class="landmark-itinerary-object" v-for="landmark in itinerary.landmarks" v-bind:key="landmark.landmarkID">
              <div class="landmark-sort-order-wrapper">
                <span>{{landmark.sortOrder}}</span>
              </div>
              <div class="landmark-name-wrapper">
                <span>{{landmark.name}}</span>
              </div>
              <div class="landmark-move-up-wrapper">
                <b-button >UP</b-button>
              </div>
              <div class="landmark-move-down-wrapper">
                <b-button >DOWN</b-button>
              </div>
              <div class="landmark-remove-wrapper">
                <b-button >REMOVE</b-button>
              </div>
          </div>
        </div>
        <div>
          <select id="itineraryDropDown" v-on:change="onSelectChange">
            <option
              v-for="itineraryOption in userItineraries"
              v-bind:key="itineraryOption.itineraryID"
              v-bind:value="itineraryOption.itineraryID"
              v-text="itineraryOption.name"
            ></option>
          </select>
        </div>

        <div class="float-right">
          <button
            type="submit"
            class="btn btn-lg btn-primary btn-block btn-secondary"
          >Save Itinerary</button>
        </div>
      </div>
    </form>
  </div>
</template>

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
      serverMessage: "",
      incomingLandmarkID: Number
    };
  },
  methods: {
    getItinerary() {
      const userID = auth.getUser().id;
      const apiEndpoint = `getuseritinerary/${userID}`;
      console.log("fetching: getuseritinerary");
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
          this.getIncomingLandmark(); //oversight: this needs to add
        });
    },
    saveChanges() {
      this.EditItinerary();
    },
    EditItinerary() {
      //const userID = auth.getUser().id;
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
    onSelectChange() {
      // get the new selected itineraryID from drop down
      // set this.itinerary = userItineraries.find(itinerary => itinerary.id == new selected id)
      // call setSelectedItinerary()
      // call getItinerary()
    },
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
    getUserItineraries() {
      const userID = auth.getUser().id;
      const apiEndpoint = `getusersitineraries/${userID}`;
      console.log("fetching: getusersitineraries" );
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
          //alert(data);
          this.userItineraries = data;
          //alert(this.userItineraries);
        });
    },
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

    setSelectedItinerary() {
      const apiEndpoint = `setselecteditinerary`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: this.isEditForm ? "PUT" : "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getToken()
        },
        body: JSON.stringify(this.itinerary)
      })
        .then(response => {
          if (response.ok) {
            this.$router.push({ path: "/" });
          }
        })
        .catch(err => console.error(err));
    },
    loadData() {
      console.log("getItinerary");
      this.getItinerary();
      console.log("getUserItineraries");
      this.getUserItineraries();
      // console.log("getIncomingLandmark");
      // this.getIncomingLandmark();
    },
    getIncomingLandmark() {
      console.log(JSON.stringify(this.itinerary));
      if (this.$route.params.landmark_id != null) {
        this.incomingLandmarkID = this.$route.params.landmark_id;

        //if (this.itinerary.landmarks != [] && this.itinerary.landmarks != null) {
          if (
            this.itinerary.landmarks.find(landmark => {
              return landmark.landmarkID == this.incomingLandmarkID;
            }) == null
          ) {
            console.log("fetching: getlandmark");
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
                  "landmarkID": data.landmarkID,
                  "name": data.name,
                  "sortOrder": (this.landmarks == null ? 1 : this.landmarks.length + 1),
                  "landmark": data,
                  "addedByClient": true,
                  "hasLandmarkObject": true
                }
                this.itinerary.landmarks.push(newLandmark);
              })
              .catch(err => console.error(err));
          }
        }
      //}
    }
  },
  created() {
    this.loadData();
  }
};
</script>

<style>
</style>