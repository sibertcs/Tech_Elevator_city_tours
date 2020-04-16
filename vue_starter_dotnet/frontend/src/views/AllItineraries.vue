<template>
  <div>
    <h1>My Itineraries</h1>
    <b-button
      id="createItinerary"
      class="all-itineraries card"
      v-on:click="redirectMethod"
    >Create New Itinerary</b-button>
    <div
      class="all-itineraries card"
      v-for="itinerary in itineraries"
      v-bind:key="'itinerary'+itinerary.itineraryID"
    >
      <p
        v-if="itinerary.itineraryDate != null"
      >{{itinerary.name}}, {{prettyDateString(itinerary.itineraryDate)}}</p>
      <div class="landmarks-wrapper" v-if=" itinerary != null && itinerary.landmarks.length != []">
        <div
          v-for="landmark in itinerary.landmarks"
          v-bind:key="landmark.landmarkID.toString() + '-' + itinerary.itineraryID.toString()"
        >
          <div class="all-itineraries-image">
            <b-img
              class="landmark-image"
              v-if="landmark.landmark.images.length > 0"
              v-bind:src="landmark.landmark.images[0].url"
              v-on:click="redirectToDetails(landmark.landmarkID)"
            />
          </div>
          <div class="all-itineraries-names">
            <span>{{landmark.sortOrder}}) </span>
            <a
              class="linkToDetails"
              v-on:click="redirectToDetails(landmark.landmarkID)"
            >{{landmark.landmark.name}}</a>
          </div>
        </div>
      </div>
      <b-button id="manage-itinerary-button" v-on:click="goToManagePage(itinerary)">Manage Itinerary</b-button>
      <b-button
        id="deleteItinerary"
        v-on:click="deleteItinerary(itinerary.itineraryID)"
      >Delete Itinerary</b-button>
    </div>
  </div>
</template>
<style scoped>
.linkToDetails:hover {
  cursor: pointer;
  text-decoration: underline;
}
@media only screen and (max-width: 3000px) {
.landmark-image {
  max-height: 275px;
  cursor: pointer;
}
.all-itineraries{
    margin-right: 33%;
    margin-left: 33%; 
}
}
@media only screen and (max-width: 1700px) {
.landmark-image {
  max-height: 275px;
  cursor: pointer;
}
.all-itineraries{
    margin-right: 25%;
    margin-left: 25%; 
}
.landmarks-wrapper{
  margin-left: 10px;
  margin-right: 10px;
  overflow:hidden;
}
}
@media only screen and (max-width: 1000px) {
.landmark-image {
  max-height: 250px;
  cursor: pointer;
}
.all-itineraries{
    margin-right: 20%;
    margin-left: 20%; 
}
.landmarks-wrapper{
  margin-left: 10px;
  margin-right: 10px;
  overflow:hidden;
}
}
@media only screen and (max-width: 750px) {
.landmark-image {
  max-height: 150px;
  cursor: pointer;
}
.all-itineraries{
    margin-right: 10%;
    margin-left: 10%; 
}
.landmarks-wrapper{
  margin: 0px;
}
}
.landmark-wrapper{
    overflow: hidden;
    display: grid;
    /* margin: 2em; */
    margin-left: 10%;
    margin-right: 10%;
}
</style>
<script>
import auth from "../auth";
export default {
  data() {
    return {
      userID: auth.getUser().id,
      itineraries: [Object]
    };
  },
  methods: {
    getUserItineraries() {
      const apiEndpoint = `getusersitineraries/${this.userID}`;
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
          this.itineraries = data;
        });
    },
    deleteItinerary(itineraryIdToDelete) {
      if (confirm("Are you sure?")) {
        //actually delete it now
        const apiEndpoint = `deleteitinerary/${itineraryIdToDelete}`;
        fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + auth.getUser()
          }
        }).then(response => {
          if (response.ok) {
            this.$router.go(0);
          }
        });
      }
    },
    redirectMethod() {
      this.$router.push({ path: "/CreateItinerary" });
    },
    redirectToDetails(id) {
      this.$router.push({ path: "/LandmarkDetails/" + id });
    },
    prettyDateString(dateString){
        let s = dateString.split("T")[0];
        let d = new Date(s);
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        return d.toLocaleDateString(undefined,options);
    },
    goToManagePage(itinerary) {
      this.setSelectedItinerary(itinerary);
      this.$router.push({ path: "/ManageItinerary/0" });
    },
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
    }
  },
  created() {
    this.getUserItineraries();
  }
};
</script>

<style>
</style>