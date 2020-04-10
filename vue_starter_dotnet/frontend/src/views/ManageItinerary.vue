<template>
<form>
<div class="form-group">
    <label for="itineraryName">Itinerary Name</label>
    <input
    type="text"
    class="form-control"
    id="itineraryName"
    placeholder="Name"
    v-model.trim="itinerary.name"
    />
    <div >Please provide a valid itinerary name.</div>
</div>
<div class="form-group">
    <label for="startDate">Date</label>
            <input
              type="date"
              class="form-control"
              id="startDate"
              placeholder="YYYY/MM/DD"
              v-model.trim="itinerary.itineraryDate"
              />
              <div >Please provide a valid date.</div>
</div>
<div class="form-group">
    <label for="startingAddress">Starting Address</label>
            <input
              type="date"
              class="form-control"
              id="startingAddress"
              placeholder="YYYY/MM/DD"
              v-model.trim="itinerary.itineraryDate"
              />
              <div >Please provide a valid date.</div>
</div>
    </form> 
</template>

<script>
export default {

}
</script>

<style>

</style>