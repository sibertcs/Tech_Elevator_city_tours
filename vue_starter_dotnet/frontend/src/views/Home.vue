<template>
  <div class="nav-button">
    <div class="home">
      <h1>Jack's City Tours</h1>
      <div class="site-search">
        <landmark-search></landmark-search>
        <!-- <landmark-search-Results 
        v-if="showLandmarkResults" 
        v-bind:searchQuery="API_URL"
        
        > -->
      </div>
    </div>
  </div>
</template>

<script>
import LandmarkSearch from "@/components/LandmarkSearch";
//import LandmarkSearchResults from '@/components/LandmarkSearchResults'

export default {
  name: "home",
  
  components: {
    LandmarkSearch
    //LandmarkSearchResults
  },
  // props: {
  //   searchQuery: String
  // }
  //  data() {
  //   return {
  //     API_URL: "https://localhost:44359/api/reviews", // <-- Will need to update API to local API form sql.
  //     showLandmarkResults: true,
  //     landmarkID: 0
  //   },
  // methods: {

  // }
};
</script>

<style>
</style>