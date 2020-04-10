<template>
  <form>
      <div class="manage-itinerary card">
    <div class="form-group">
      <label for="itineraryName">Itinerary Name</label>
      <input
        type="text"
        class="form-control"
        id="itineraryName"
        placeholder="Name"
        v-model.trim="itinerary.name"
      />
      <div>Please provide a valid itinerary name.</div>
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
      <div>Please provide a valid date.</div>
    </div>
    <div class="form-group">
      <label for="startingAddress">Starting Address</label>
      <input
        type="text"
        class="form-control"
        id="startingAddress"
        placeholder="1234 Main St"
        v-model.trim="itinerary.startingLocation"
      />
      <div>Please provide a valid starting address.</div>
    </div>
    <div class="float-right">
        <button type="submit" class="btn btn-lg btn-primary btn-block btn-secondary">Save Itinerary</button>
      </div>
      </div>
  </form>
</template>

<script>
export default {
    name: "manage-itinerary",

     data() {
    return {
  itinerary: []
    }
     }
};
</script>

<style>
</style>