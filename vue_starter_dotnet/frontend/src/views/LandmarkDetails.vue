<template>
    <div class="landmark-details">
      <h1>here</h1>
         <h1>{{selectedLandmark.id}}</h1>
         <img v-bind:src="selectedLandmark.images[0].url" />
         <div><span>Description:</span>{{selectedLandmark.description}}</div>
        <div><span>Days Open:</span>{{selectedLandmark.days_open}}</div>
        <div><span>Hours of Operation:</span>{{selectedLandmark.hours_of_operation}}</div>
        <div><span>Landmark Type:</span>{{selectedLandmark.category_name}}</div>

        <div>
            <button v-on:click="goBack">GO BACK</button>
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
    }
  },
     created() {

          fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/getlandmark/${this.$route.params.id}`)
        .then(response => {
          if (response.ok) {
            return response.json();
          } else {
            // // no reason to be here send them back to the list view
            // this.$router.push({ path: "/" });
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