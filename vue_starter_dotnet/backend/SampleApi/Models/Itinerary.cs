using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace SampleApi.Models
{
    public class Itinerary
    {
        public int UserID { get; set; }
        public User User { get; set; }
        public bool HasUserObject
        {
            get
            {
                return User != null;
            }
        }
        public int ItineraryID { get; set; }
        public DateTime ItineraryDate { get; set; }

        public bool IsSelectedItinerary { get; set; }
        public string Name { get; set; }
        public string StartingLocation { get; set; }
        private List<ItineraryLandmark> _landmarks = new List<ItineraryLandmark>();
        public IEnumerable<ItineraryLandmark> Landmarks
        {
            get
            {
                _landmarks.Sort();
                return _landmarks;
            }
            set
            {
                _landmarks = new List<ItineraryLandmark>(value);
            }
        }

        public Itinerary()
        {

        }

        public Itinerary(IDataReader data)
        {
            UserID = Convert.ToInt32(data["user_id"]);
            ItineraryID = Convert.ToInt32(data["itinerary_id"]);
            IsSelectedItinerary = Convert.ToBoolean(data["currently_selected"]);
            ItineraryDate = Convert.ToDateTime(data["itinerary_date"]).Date;
            Name = Convert.ToString(data["name"]);
            StartingLocation = Convert.ToString(data["starting_location"]);
        }

        public void AddLandmarks(IDataReader reader)
        {
            while (reader.Read())
            {
                if(!(reader["landmark_id"] is DBNull))
                {
                    ItineraryLandmark landmark = new ItineraryLandmark(reader);
                    _landmarks.Add(landmark);
                }
                

            }
            reader.Close();
        }
    }

    public class ItineraryLandmark : IComparable
    {
        public int LandmarkID { get; set; }
        public int SortOrder { get; set; }
        public Landmark Landmark { get; set; }     
        public bool HasLandmarkObject
        {
            get
            {
                return Landmark != null;
            }
        }
        public ItineraryLandmark()
        {                        

        }
        public ItineraryLandmark(IDataReader data)
        {
            LandmarkID = Convert.ToInt32(data["landmark_id"]);
            SortOrder = Convert.ToInt32(data["sort_order"]);           
        }

       

        public int CompareTo(object obj)
        {
            int compareResult = 0;
            if (obj.GetType() == typeof(ItineraryLandmark))
            {
                ItineraryLandmark other = (ItineraryLandmark)obj;
                compareResult = this.SortOrder.CompareTo(other.SortOrder);
            }

            return compareResult;
        }
    }

    public class RemoveLandmarkRequestBody
    {
        public int LandmarkID { get; set; }
        public int ItineraryID { get; set; }
    }

    public class RateLandmarkRequestBody
    {
        public int LandmarkID { get; set; }
        public int UserID { get; set; }
        public int RatingType { get; set; }
    }

    public class GetUserRatingRequestBody
    {
        public int UserID { get; set; }
        public int LandmarkID { get; set; }
    }

    public class GetUserRatingResponseBody
    {
        public int RatingType { get; set; }
        public string RatingName { get; set; }
    }
}
