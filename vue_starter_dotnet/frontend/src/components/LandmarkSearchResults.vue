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
      
        <div class="search-results-tile-name">
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
export default {
  name: "landmark-search-results",
  data() {
    return {
      landmarkResults: []
    };
  },
  props: {
    searchQuery: String
  },
  methods: {
    redirectMethod(id) {
      //alert(JSON.stringify(landmark));
      //this.$emit("redirectMethod", landmark);
      //alert(landmark.id);
      this.$router.push({path: "/LandmarkDetails/" + id});
    },
    loadLandmarkResults() {
      //This methoed calls the api and returns an array to be displayed in the <template>
      console.log("Load Landmarks...");
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/getlandmarks/${this.searchQuery}`)
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

@media only screen and (max-width: 4000px) {
.landmark-results-wrapper {
  max-width: 70%;
  margin-left: 15%;
  margin-right: 15%;
  align-content: center;
}
}
@media only screen and (max-width: 1000px) {
.landmark-results-wrapper {
  margin-left: 5%;
  margin-right: 5%;
  align-content: center;
  max-width: 100%;
}
.search-results-tile-name{
  font-size: medium;
}
}
.landmark-search-result-tile {
  background-color: var(--main-bg-color);
  margin-left: 10%;
  margin-right: 10%;
  max-height: 450px;
  margin-bottom: 1em;
  cursor: pointer;
  overflow: hidden;
}
.search-results-tile-name{
  text-align: center;
}
.landmark-search-result-image {
  max-height: 80%;
  
}
</style>