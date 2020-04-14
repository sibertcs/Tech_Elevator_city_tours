using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SampleApi.Models;

namespace SampleApi.DAL
{
    public interface ILandmarksDAO
    {
        IEnumerable<Landmark> LandmarksSearch(string query);
        Landmark LandmarkSearch(int id);
        Itinerary CreateItinerary(int userID);
        Itinerary GetUserItinerary(int userID);
        IEnumerable<Itinerary> GetUsersItineraries(int userID);
        void SetSelectedItinerary(Itinerary itinerary);
        void EditItinerary(Itinerary itinerary);
        Itinerary AddLandmarksToItinerary(Itinerary itinerary);
        Itinerary GetItineraryByID(int itineraryID);
        Itinerary EditItineraryLandmarkSortOrder(Itinerary itinerary);
        void RemoveLandmarkFromItinerary(int itineraryID, int landmarkID);
        void DeleteItinerary(int itineraryID);
        void RateLandmark(int landmarkID, int userID, int ratingType);
        GetUserRatingResponseBody GetUserLandmarkRatings(int userID, int landmarkID);
    }
}
