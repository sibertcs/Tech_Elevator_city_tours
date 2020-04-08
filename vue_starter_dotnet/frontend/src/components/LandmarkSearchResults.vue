<template>
  <div class="landmark-results-wrapper">
    <h1>Your Search Results</h1>
    <div
      v-for="landmark in landmarkResults"
      :key="landmark.id"
      v-on:click="redirectMethod(landmark)"
      class="landmark-search-result-tile card"
    >
      <div>{{landmark.name}}</div>
      <b-img
        class="landmark-search-result-image"
        v-if="landmark.images.length > 0"
        v-bind:src="landmark.images[0].url"
      />
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      landmarkResults: []
    };
  },
  props: {
    searchQuery: String
  },
  methods: {
    redirectMethod(landmark) {
      alert(JSON.stringify(landmark));
      this.$emit("redirectMethod", landmark);
      this.$router.push({path: "/LandmarkDetails"});
    },
    loadLandmarkResults() {
      //This methoed calls the api and returns an array to be displayed in the <template>
      console.log("Load Landmarks...");
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${this.searchQuery}`)
        .then(response => {
          if (response.ok) {
            return response.json();
          } else {
            // // no reason to be here send them back to the list view
            // this.$router.push({ path: "/" });
          }
        })
        .then(data => {
          this.landmarkResults = data;
        })
        .catch(err => console.error(err));
    }
  },
  created() {
    this.loadLandmarkResults();
  }
};
</script>

<style>
.landmark-results-wrapper {
  max-width: 50%;
  margin-left: 25%;
  margin-right: 25%;
  align-content: center;
}

.landmark-search-result-tile {
  background-color: var(--main-bg-color);
  margin-left: 10%;
  margin-right: 10%;
  max-height: 300px;
  margin-bottom: 1em;
  cursor: pointer;
  overflow: hidden;
}

.landmark-search-result-image {
  max-height: 80%;
  
}
</style>