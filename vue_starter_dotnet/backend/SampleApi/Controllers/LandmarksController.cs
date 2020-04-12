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

        [HttpGet("CreateItinerary/{user_id}")]        
        public Itinerary CreateItinerary(int user_id)
        {
            return landmarksDAO.CreateItinerary(user_id);
        }

        [HttpGet("getitinerarybyid/{itinerary_id}")]
        public Itinerary GetItineraryByID(int itinerary_id)
        {
            return landmarksDAO.GetItineraryByID(itinerary_id);
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

        [HttpPut("SetSelectedItinerary/")]
        [Consumes("application/json")]
        public IActionResult SetSelectedItinerary([FromBody]Itinerary itinerary)
        {
            IActionResult result = Ok();
            try
            {
                landmarksDAO.SetSelectedItinerary(itinerary);
                result = Ok();
            }
            catch(Exception ex)
            {
                //result = 
            }

            return result;
        }

        [HttpPut("EditItinerary/")]
        [Consumes("application/json")]
        public IActionResult EditItinerary([FromBody]Itinerary itinerary)
        {
            IActionResult result = Ok();
            try
            {
                landmarksDAO.EditItinerary(itinerary);
                result = Ok();
            }
            catch (Exception ex)
            {
                //result = 
            }

            return result;
        }

        [HttpPost("AddLandmarksToItinerary")]
        [Consumes("application/json")]
        public Itinerary AddLandmarksToItinerary([FromBody]Itinerary itinerary)
        {
            return landmarksDAO.AddLandmarksToItinerary(itinerary);
        }

        [HttpPut("EditItineraryLandmarkSortOrder")]
        [Consumes("application/json")]
        public Itinerary EditItineraryLandmarkSortOrder([FromBody]Itinerary itinerary)
        {
            return landmarksDAO.EditItineraryLandmarkSortOrder(itinerary);
        }

        [HttpDelete("RemoveLandmarkFromItinerary")]
        [Consumes("application/json")]
        public IActionResult RemoveLandmarkFromItinerary(int itineraryID, int landmarkID)
        {
            landmarksDAO.RemoveLandmarkFromItinerary(itineraryID, landmarkID);
            return Ok();
        }

        [HttpDelete("DeleteItinerary/{itineraryID}")]
        public IActionResult DeleteItinerary(int itineraryID)
        {
            landmarksDAO.DeleteItinerary(itineraryID);
            return Ok();
        }
    }
}