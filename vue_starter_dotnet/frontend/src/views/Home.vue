<template>
  <div class="nav-button">
    <div class="home">
      <h1>You Get a Tour! and You Get a Tour! Everyone Gets a Tour!</h1>
      <div class="site-search">
        <landmark-search v-on:search="searchforResult"></landmark-search>
        <landmark-search-results :key="searchResultsKey" v-if="showLandmarkResults" v-bind:searchQuery="searchQuery"></landmark-search-results>
        
      </div>
    </div>
  </div>
</template>

<script>
import LandmarkSearch from "@/components/LandmarkSearch";
import LandmarkSearchResults from "@/components/LandmarkSearchResults";

export default {
  name: "home",

  components: {
    LandmarkSearch,
    LandmarkSearchResults
  },

  data() {
    return {
      searchQuery: "",
      showLandmarkResults: false,
      searchResultsKey: 0
    };
  },
  methods: {
    searchforResult(searchQuery) {
      //This method gets the searchQuery string from LandmarkSearch.vue using v-bind in the template above. IA      
      this.searchQuery = searchQuery;
      if(this.showLandmarkResults){
          this.searchResultsKey += 1; //force re-render
      }
      else{
          this.showLandmarkResults = true; // first render          
      }
      
    }
  }
};
</script>

<style>
</style>