<template>
  <form>
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
      <div>
        <select id="itineraryDropDown" v-model="getUserItinerary" v-on:change="onSelectChange">
            
          <option
            v-for="itineraryOption in userItineraries"
            v-bind:key="itineraryOption.itineraryID"
          >{{itineraryOption.itineraryName}}</option>
        </select>
      </div>
      
      <div class="float-right">
        <button type="submit" class="btn btn-lg btn-primary btn-block btn-secondary">Save Itinerary</button>
      </div>
    </div>
  </form>
</template>

<script>
import auth from "../auth";
//import AppVue from '../App.vue';
export default {
  name: "manage-itinerary",
  data() {
    return {
      itinerary: Object,
      userItineraries: []
    };
  },
  methods: {
    getItinerary() {
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
    onSelectChange(){
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
          this.userItineraries = data;
        });
    },
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
          this.itinerary = data;
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
    }
  },

  created() {
    this.getItinerary();
  },

};
</script>

<style>
</style>