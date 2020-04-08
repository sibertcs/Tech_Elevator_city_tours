<template>
  <div class="nav-button">
    <div class="home">
      <h1>Jackie Chan's Action Tours</h1>
      <div class="site-search">
        <landmark-search v-on:search="searchforResult" ></landmark-search>
         <landmark-search-results 
        v-if="showLandmarkResults" 
        v-bind:searchQuery="searchQuery"        
        > </landmark-search-results>
      </div>
    </div>
  </div>
</template>

<script>
import LandmarkSearch from "@/components/LandmarkSearch";
import LandmarkSearchResults from '@/components/LandmarkSearchResults'

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
    }
    },
   methods: {
       searchforResult(searchQuery){ //This method gets the searchQuery string from LandmarkSearch.vue using v-bind in the template above. IA
       this.showLandmarkResults = true;
this.searchQuery = searchQuery
       }
   }
};
</script>

<style>
</style>