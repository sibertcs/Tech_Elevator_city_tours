<template>
  <form >      
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
  itinerary: []
    //userID : auth.getUser().
    }
     },
      methods: {
    
    getItinerary(){
        const userID = auth.getUser().id;
        const apiEndpoint = `getuseritinerary/${userID}`;
        fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            Authorization: 'Bearer ' + auth.getUser(),
          }
        })
          .then((response) => {
            if (response.ok) {
              return response.json();
            }
          }).then(data =>{
              this.itinerary = data;
          });
    }
  },
  created() {
      this.getItinerary();
    // if (this.isEditForm) {
    //   const snippetId = this.$route.params.id;
    //   fetch(`${process.env.VUE_APP_REMOTE_API}/api/snippets/${snippetId}`, {
    //     method: 'GET',
    //     headers: new Headers({
    //       Authorization: 'Bearer ' + auth.getToken(),
    //     }),
    //     credentials: 'same-origin',
    //   })
    //     .then((response) => {
    //       if (response.ok) {
    //         return response.json();
    //       } else {
    //         // no reason to be here send them back to the list view
    //         this.$router.push({ path: '/' });
    //       }
    //     })
    //     .then((data) => {
    //       this.snippet = data;
    //     })
    //     .catch((err) => console.error(err));
    //}
  },
  computed: {
    isEditForm() {
      return this.$route.params.id === undefined ? false : true;
    },
    getPageTitle() {
      return this.isEditForm ? 'Edit Snippet' : 'Add New Snippet';
    },
    getPageDescription() {
      return this.editForm
        ? 'Use this form to edit a snippet in your collection.'
        : 'Use this form to add a snippet to your collection.';
    },
  },
};

</script>

<style>
</style>