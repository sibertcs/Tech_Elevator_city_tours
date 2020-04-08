<template>
    <div class="landmark-details">
        <h1>{{landmark.landmark_name}}</h1>
        <img v-bind:src="require(landmark.image_url)" />
        <div><span>Description:</span>{{landmark.description}}</div>
        <div><span>Days Open:</span>{{landmark.days_open}}</div>
        <div><span>Hours of Operation:</span>{{landmark.hours_of_operation}}</div>
        <div><span>Landmark Type:</span>{{landmark.category_name}}</div>

        <div>
            <button v-on:click="goBack">GO BACK</button>
        </div>
    </div>
    
</template>

<script>
//import data from ''

export default {
    name: 'landmark',
    data() {
        return {
            allLandmarks: data,
            landmark: null
        }
    },
    methods: {
    goBack() {
      this.$router.go(-1);
    }
  },
    created() {
        this.landmark = this.allLandmarks.find(l => l.id == this.$route.params.id)
    }

}
</script>

<style>

</style>