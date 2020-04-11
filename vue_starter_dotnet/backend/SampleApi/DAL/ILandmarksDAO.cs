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
        Itinerary GetUserItinerary(int userID);
        IEnumerable<Itinerary> GetUsersItineraries(int userID);
        void SetSelectedItinerary(int userID, int itineraryID);
    }
}
