<template>
    <div class="landmark-details">
        <h1>{{landmark.landmark_name}}</h1>
        <div><span>Description:</span>{{landmark.description}}</div>
        <div><span>Days Open:</span>{{landmark.days_open}}</div>
        <div><span>Hours of Operation:</span>{{landmark.hours_of_operation}}</div>
        <div><span>Description:</span>{{landmark.hours_of_operation}}</div>
        <div><span>Description:</span>{{landmark.hours_of_operation}}</div>

    </div>
</template>

<script>
import data from ''

export default {
    name: 'landmark',
    data() {
        return {
            allLandmarks: data,
            landmark: null
        }
    },
    created() {
        this.landmark = this.allLandmarks.find(l => l.id == this.$route.params.id)
    }

}
</script>

<style>

</style>