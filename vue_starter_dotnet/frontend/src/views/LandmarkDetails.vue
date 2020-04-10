<template>
    <div class="landmark-details card">
      <h1>Great Choice!</h1>
         <h1>{{selectedLandmark.name}}</h1>
         <img v-bind:src="selectedLandmark.images[0].url" />
         <div style="font-size: 10px;"><span>{{selectedLandmark.images[0].description}} (Photo Credits: {{selectedLandmark.images[0].credits}})</span></div>
         <div><span>DESCRIPTION: </span>{{selectedLandmark.description}}</div>
        <div><span>DAYS OPEN: </span>{{selectedLandmark.daysOpen}}</div>
        <div><span>HOURS OF OPERATION: </span>{{selectedLandmark.hoursOfOperation}}</div>
        <div><span>LANDMARK TYPE: </span>{{selectedLandmark.category}}</div>
        <div><span>Address: {{selectedLandmark.streetAddress}} {{selectedLandmark.city}}, {{selectedLandmark.state}} {{selectedLandmark.zipCode}}</span></div>

        <div>
          <button class="btn btn-lg btn-primary btn-block btn-secondary" v-on:click="goBack">GO BACK</button>
        </div>
        <div>
          <button class="btn btn-lg btn-primary btn-block btn-secondary" v-on:click="addToItinerary">ADD TO ITINERARY</button>
        </div>
    </div>
    
</template>

<script>
//import data from ''

export default {
    name: 'landmark-details',
    data() {
        return {
            // allLandmarks: data,
             selectedLandmark: null
        }
    },
    // props:{
    //      id: Number
    // },
    methods: {
    goBack() {
      this.$router.go(-1);
    },
    addToItinerary(){
      //alert("to be implemented" + id.toString());
      // router push path /manageitinerary?landmarkId=? + id
      this.$router.push({path: "/ManageItinerary/" + this.selectedLandmark.id.toString()});
    } 
  },
     created() {

          fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/getlandmark/${this.$route.params.id}`)
        .then(response => {
          if (response.ok) {
            return response.json();
          }
        })
        .then(data => {
          this.selectedLandmark = data;
        })
        .catch(err => console.error(err));
    }
    
        //this.landmark = this.allLandmarks.find(l => l.id == this.$route.params.id)
    }
    


</script>

<style>

</style>