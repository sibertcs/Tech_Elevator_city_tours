<template>
  <div>
      <div v-for="itinerary in itineraries" v-bind:key="'itinerary'+itinerary.itineraryID">
        <p>{{itinerary.name}}</p>
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
    deleteItinerary(itineraryIDToDelete) {
      if (confirm("Are you sure?")) {
        //actually delete it now
        const apiEndpoint = `deleteitinerary/${itineraryIDToDelete}`;
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
    }
  },
  created(){
      this.getUserItineraries();
  }
};
</script>

<style>
</style>