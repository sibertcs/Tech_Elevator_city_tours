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
            placeholder="1234 Main St"
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
            <!--<select
              class="btn btn-secondary dropdown-toggle"
              id="itineraryDropDown"
              v-on:change="onSelectChange"
            >
              <option
                v-for="itineraryOption in userItineraries"
                v-bind:key="'dropdown' + itineraryOption.itineraryID"
                v-bind:value="itineraryOption.itineraryID"
                v-text="itineraryOption.name"
              ></option>
            </select>-->
            <b-button id="addALandmark" v-on:click="redirectMethod">Add Landmark</b-button>
            <b-button id="deleteItinerary" v-on:click="deleteItinerary">Delete Itinerary</b-button>
            <!--<b-button id="createItinerary" v-on:click="createItinerary">Create New Itinerary</b-button>-->
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
    <div>
      <div class="site-search">
        <!-- <landmark-search v-if="isAddALandmark" v-on:search="searchforResult"></landmark-search>
        <landmark-summary :key="searchResultsKey" v-if="isAddALandmark" v-bind:searchQuery="searchQuery"></landmark-summary>-->
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
//import LandmarkSearch from "@/components/LandmarkSearch";
//import LandmarkSummary from "@/components/LandmarkSummary";
export default {
  name: "manage-itinerary",
  // components: {
  // LandmarkSearch,
  // LandmarkSummary
  // },
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
      userID: auth.getUser().id
    };
  },
  methods: {
    //New method:
    getItinerary() {
      //const userID = auth.getUser().id;
      const apiEndpoint = `getuseritinerary/${this.userID}`;
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
      alert("changes saved successfully");
      this.$router.push({path: "/"});
    },
    //New method:
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
          //alert(data);
          this.userItineraries = data;
          //alert(this.userItineraries);
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
      console.log(JSON.stringify(this.itinerary));
      if (
        this.$route.params.landmark_id != null &&
        this.$route.params.landmark_id != 0
      ) {
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
      //}
    },
    //New method:
    deleteItinerary() {
      if (confirm("Are you sure?")) {
        //actually delete it now
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
        // console.log(body);
        // alert('look at console');
        //actually delete it now
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
    redirectMethod() {
      if (!this.landmarkAddedOnDB) {
        this.AddLandmarksToItinerary();
      }
      this.$router.push({path: "/"});
    },
    redirectToDetails(id) {
      if (!this.landmarkAddedOnDB) {
        this.AddLandmarksToItinerary();
      }
      this.$router.push({path: "/LandmarkDetails/" + id});
    },
    moveLandmarkUp(landmark) {
      // landmark

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
    sortLandmarks() {
      this.itinerary.landmarks = this.itinerary.landmarks.sort(function(a, b) {
        return a.sortOrder - b.sortOrder;
      });
      this.sortOrderChanged = true;
    },
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
            //this.$router.go(0);
            this.$router.push(("/ManageItinerary/" + this.incomingLandmarkID.toString()))
          }
        })
        .catch(err => console.error(err));
    },
    //New method:
    searchforResult(searchQuery) {
      //This method gets the searchQuery string from LandmarkSearch.vue using v-bind in the template above. IA
      this.searchQuery = searchQuery;
      if (this.isAddALandmark) {
        this.searchResultsKey += 1; //force re-render
      } else {
        this.isAddALandmark = true; // first render
      }
    }
  },
  created() {
    this.loadData();
  }
};
</script>

<style>
</style>