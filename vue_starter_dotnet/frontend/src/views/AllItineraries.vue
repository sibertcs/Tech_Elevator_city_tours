<template>
  <div>
    <b-button id="createItinerary" class="all-itineraries card"  v-on:click="redirectMethod">Create New Itinerary</b-button>
      <div class="all-itineraries card" v-for="itinerary in itineraries" v-bind:key="'itinerary'+itinerary.itineraryID">
        <p v-if="itinerary.itineraryDate != null">{{itinerary.name}},  Starting Date: {{itinerary.itineraryDate.split('T')[0]}}</p>
        <div class="landmarks-wrapper" v-if=" itinerary != null && itinerary.landmarks.length != []">
            <div v-for="landmark in itinerary.landmarks" v-bind:key="landmark.landmarkID.toString() + '-' + itinerary.itineraryID.toString()">
              <b-img
                  class="landmark-image"
                  v-if="landmark.landmark.images.length > 0"
                  v-bind:src="landmark.landmark.images[0].url"
                  v-on:click="redirectToDetails(landmark.landmarkID)"
                />     
              <span> {{landmark.sortOrder}}) </span>
              <a class="linkToDetails" v-on:click="redirectToDetails(landmark.landmarkID)">{{landmark.landmark.name}}</a>                    
            </div>
        </div>
        <b-button id="manage-itinerary-button" v-on:click="goToManagePage(itinerary)">Manage Itinerary</b-button> 
        <b-button id="deleteItinerary" v-on:click="deleteItinerary(itinerary.itineraryID)">Delete Itinerary</b-button>
      </div>
  </div>
</template>
<style scoped>
  .linkToDetails:hover{
    cursor: pointer;
    text-decoration: underline;
  }

  .landmark-image{
    height: 100px;
    cursor: pointer;
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
      this.$router.push({path: "/CreateItinerary"});
    },
    redirectToDetails(id) {
      this.$router.push({path: "/LandmarkDetails/" + id});
    },
    goToManagePage(itinerary){
      this.setSelectedItinerary(itinerary);
      this.$router.push({path:"/ManageItinerary/0"});
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
  created(){
      this.getUserItineraries();
  }
};
</script>

<style>
</style>