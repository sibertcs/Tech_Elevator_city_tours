using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SampleApi.DAL;
using SampleApi.Models;

namespace SampleApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LandmarksController : ControllerBase
    {
        private ICityTourDAOs cityTourDAOs;
        private ILandmarksDAO landmarksDAO { get { return cityTourDAOs.landmarksDAO; } }
        public LandmarksController(ICityTourDAOs cityTourDAOs)
        {
            this.cityTourDAOs = cityTourDAOs;
        }

        [HttpGet("getlandmarks/{query}", Name = "GetLandmarks"), Route("GetLandmarks")]
        public IEnumerable<Landmark> GetLandmarks(string query)
        {                        
            return landmarksDAO.LandmarksSearch((query == null ? "" : query));
        }

        [HttpGet("getlandmark/{id}", Name = "GetLandmark"), Route("GetLandmark")]
        public Landmark GetLandmark(int id)
        {
            return landmarksDAO.LandmarkSearch(id);
        }

        [HttpGet("getuseritinerary/{user_id}")]
        public Itinerary GetUserItinerary(int user_id)
        {
            return landmarksDAO.GetUserItinerary(user_id);
        }

        [HttpGet("getusersitineraries/{user_id}")]
        public IEnumerable<Itinerary> GetUsersItineraries(int user_id)
        {
            return landmarksDAO.GetUsersItineraries(user_id);
        }

        [HttpGet("SetSelectedItinerary/{user_id}/{itinerary_id}")]
        public IActionResult SetSelectedItinerary(int userID, int itineraryID)
        {
            IActionResult result = Ok();
            try
            {
                landmarksDAO.SetSelectedItinerary(userID, itineraryID);
                result = Ok();
            }
            catch(Exception ex)
            {
                //result = 
            }

            return result;
        }
    }
}