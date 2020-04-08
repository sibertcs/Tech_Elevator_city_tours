<template>
    <div>
<h1>Your Search Results</h1>
<div v-for="landmark in landmarkResults" :key="landmark"></div>
<div>{{landmark.name}}</div>
    </div>
</template>

<script>
export default {
  data() {
    return {
      props:{
        searchQuery: String,
      },
      landmarkResults: []
    };
  },
  methods:{ 
    loadLandmarkResults() {//This methoed calls the api and returns an array to be displayed in the <template>
      console.log("Load Landmarks...");
    //   fetch(`${process.env.VUE_APP_REMOTE_API}/api/landmarks/${this.searchQuery}`)
    //     .then(response => {
    //       if (response.ok) {
    //         return response.json();
    //       } else {
    //         // // no reason to be here send them back to the list view
    //         // this.$router.push({ path: "/" });
    //       }
    //     })
    //     .then(data => {
    //       this.landmarkResults = data;
    //     })
    //     .catch(err => console.error(err));
    this.landmarkResults = //Fake data array to test the display for loadLandmarkResults.
      [
        {
          cityName: "Cincinnati",
          landmarkName: "Bridge"
        }
      ];
     }
  },
  created(){this.loadLandmarkResults}
};
  
</script>

<style>
</style>