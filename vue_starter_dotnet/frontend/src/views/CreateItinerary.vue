<template>
  <div id="manageItineraryWrapper">
    <!-- <div id="serverResponse" v-if="serverMessage.length > 0">
      <span>{{serverMessage}}</span> This is why Itinerary name field says New itinerary instead of Name.
    </div>-->
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
        <div class="float-right">
          <button
            id="save-itinerary-button"
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
export default {
  name: "create-itinerary",
  data() {
    return {
      itinerary: Object,
      userItineraries: [Object],
      userID: auth.getUser().id
    };
  },
  methods: {
    dateChanged() {
      this.itinerary.itineraryDate = document.getElementById("startDate").value;
    },
    saveChanges() {
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
            this.$router.push("/");
          }
        });
        
    }
  },
  created() {
    const apiEndpoint = `createitinerary/${this.userID}`;
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
  }
};
</script>

<style>
</style>