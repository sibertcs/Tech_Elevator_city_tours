<template>
  <div>
    <b-button id="createItinerary" class="all-itineraries card"  v-on:click="redirectMethod">Create New Itinerary</b-button>
      <div class="all-itineraries card" v-for="itinerary in itineraries" v-bind:key="'itinerary'+itinerary.itineraryID">
        <p>{{itinerary.name}},  Starting Date: {{itinerary.itineraryDate.split('T')[0]}}</p>
        <b-button id="manage-itinerary-button" to="/ManageItinerary/0">Manage Itinerary</b-button> 
        <b-button id="deleteItinerary" v-on:click="deleteItinerary">Delete Itinerary</b-button>
      </div>
  </div>
</template>

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
            this.$router.go(0);
          }
        });
      }
    },
    redirectMethod() {
      this.$router.push({path: "/CreateItinerary"});
    },
  },
  created(){
      this.getUserItineraries();
  }
};
</script>

<style>
</style>