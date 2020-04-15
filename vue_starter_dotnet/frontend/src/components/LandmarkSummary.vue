<template>

  <div class="landmark-results-wrapper">
    <h1>Your Search Results</h1>
    <div
      v-for="landmark in landmarkResults"
      :key="landmark.id"
      class="landmark-search-result-tile card"
      v-on:click="redirectMethod(landmark.id)"
    >
      <div>      
        <div>
          {{landmark.name}}
        </div>
        <b-img
          class="landmark-search-result-image"
          v-if="landmark.images.length > 0"
          v-bind:src="landmark.images[0].url"
        />      
      </div>
    </div>
  </div>
</template>

<script>
// export default {
//   data() {
//     return {
//       landmarkResults: []
//     };
//   },
//   props: {
//     searchQuery: String
//   },
//   methods: {
//     redirectMethod(id) {
//       //alert(JSON.stringify(landmark));
//       //this.$emit("redirectMethod", landmark);
//       //alert(landmark.id);
//       this.$router.push({path: "/LandmarkDetails/" + id});
//     },
//     loadLandmarkResults() {
//       //This methoed calls the api and returns an array to be displayed in the <template>
//       console.log("Load Landmarks...");
//       fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/getlandmarks/${this.searchQuery}`)
//         .then(response => {
//           if (response.ok) {
//             return response.json();
//           } else {
//             // // no reason to be here send them back to the list view
//             // this.$router.push({ path: "/" });
//           }
//         })
//         .then(data => {
//           this.landmarkResults = data;
//         })
//         .catch(err => console.error(err));
//     }
//   },
//   created() {
//     this.loadLandmarkResults();
//   }
// };
 </script>

<style>

</style>