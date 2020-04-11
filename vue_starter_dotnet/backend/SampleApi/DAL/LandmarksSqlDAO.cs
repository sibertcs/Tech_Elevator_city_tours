using SampleApi.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace SampleApi.DAL
{
    /// <summary>
    /// 
    /// </summary>
    public class LandmarksSqlDAO : ILandmarksDAO
    {
        private string connectionString;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="connectionString"></param>
        public LandmarksSqlDAO(string connectionString)
        {
            this.connectionString = connectionString;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public IEnumerable<Landmark> LandmarksSearch(string query)
        {
            List<Landmark> landmarks = new List<Landmark>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "SearchForLandmark";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@query", query);

                IDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Landmark landmark = new Landmark(reader);
                    landmarks.Add(landmark);
                }

                reader.Close();

                if (landmarks.Count > 0)
                {
                    foreach (Landmark landmark in landmarks)
                    {
                        GetLandmarkImages(landmark, conn);
                    }
                }
            }

            return landmarks;
        }


        public Landmark LandmarkSearch(int id)
        {
            Landmark landmark = null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand("GetLandmarkByID", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@landmarkID", id);

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    landmark = new Landmark(reader);
                }

                reader.Close();

                if (landmark != null)
                {
                    GetLandmarkImages(landmark, conn);
                }
            }

            return landmark;
        }

        private void GetLandmarkImages(Landmark landmark, SqlConnection conn)
        {
            const string procedureName = "GetLandmarkImages";
            SqlCommand cmd = new SqlCommand(procedureName, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@landmarkID", landmark.ID);
            IDataReader imageReader = cmd.ExecuteReader();

            landmark.AddImages(imageReader);

            imageReader.Close();
        }

        public Itinerary CreateItinerary(int userID)
        {
            Itinerary itinerary = null;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "CreateItinerary";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@user_id", userID);
                cmd.ExecuteNonQuery();
            }

            return GetUserItinerary(userID);
        }

        public Itinerary GetUserItinerary(int userID)
        {
            Itinerary itinerary = null;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "GetSelectedItinerary";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@user_id", userID);
                IDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    itinerary = new Itinerary(reader);
                }
                reader.Close();
                if (itinerary != null)
                {
                    GetItineraryLandmarks(itinerary, conn);
                    foreach (ItineraryLandmark itineraryLandmark in itinerary.Landmarks)
                    {
                        itineraryLandmark.Landmark = LandmarkSearch(itineraryLandmark.LandmarkID);
                    }
                }

            }

            return itinerary;
        }

        private void GetItineraryLandmarks(Itinerary itinerary, SqlConnection conn)
        {
            const string procedureName = "GetItinerary";
            SqlCommand cmd = new SqlCommand(procedureName, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@itinerary_id", itinerary.ItineraryID);
            IDataReader dataReader = cmd.ExecuteReader();
            itinerary.AddLandmarks(dataReader);
        }

        public IEnumerable<Itinerary> GetUsersItineraries(int userID)
        {
            List<Itinerary> itineraries = new List<Itinerary>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "GetUsersItineraries";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@user_id", userID);
                IDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Itinerary itinerary = new Itinerary(reader);
                    itineraries.Add(itinerary);
                }
                reader.Close();
            }

            return itineraries;
        }
        private void SetSelectedItinerary(int userID, int itineraryID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "SetSelectedItinerary";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@user_id", userID);
                cmd.Parameters.AddWithValue("@itinerary_id", itineraryID);
                cmd.ExecuteNonQuery();
            }
        }

        public void SetSelectedItinerary(Itinerary itinerary)
        {
            SetSelectedItinerary(itinerary.UserID, itinerary.ItineraryID);
        }

        public void EditItinerary(Itinerary itinerary)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "EditItinerary";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@itinerary_id", itinerary.ItineraryID);
                cmd.Parameters.AddWithValue("@name", itinerary.Name);
                cmd.Parameters.AddWithValue("@date", itinerary.ItineraryDate.ToShortDateString());
                cmd.Parameters.AddWithValue("@starting_location", itinerary.StartingLocation);
                cmd.ExecuteNonQuery();
            }
        }
        public Itinerary GetItineraryByID(int itineraryID)
        {
            Itinerary itinerary = null;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                const string procedureName = "GetItinerary";
                SqlCommand cmd = new SqlCommand(procedureName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@itinerary_id", itineraryID);
                IDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    itinerary = new Itinerary(reader);
                }
                reader.Close();
                if (itinerary != null)
                {
                    GetItineraryLandmarks(itinerary, conn);
                    foreach (ItineraryLandmark itineraryLandmark in itinerary.Landmarks)
                    {
                        itineraryLandmark.Landmark = LandmarkSearch(itineraryLandmark.LandmarkID);
                    }
                }

            }

            return itinerary;
        }
        public Itinerary AddLandmarksToItinerary(Itinerary itinerary)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                foreach(ItineraryLandmark itineraryLandmark in itinerary.Landmarks)
                {
                    AddLandmarkToItinerary(itinerary.ItineraryID, itineraryLandmark.LandmarkID, conn);
                }
            }

            return GetItineraryByID(itinerary.ItineraryID);
        }

        private void AddLandmarkToItinerary(int itineraryID, int landmarkID, SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("AddLandmarkToItinerary", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@itinerary_id", itineraryID);
            cmd.Parameters.AddWithValue("@landmark_id", landmarkID);
            cmd.ExecuteNonQuery();
        }

        public Itinerary EditItineraryLandmarkSortOrder(Itinerary itinerary)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                foreach (ItineraryLandmark itineraryLandmark in itinerary.Landmarks)
                {
                    EditSortOrder(itinerary.ItineraryID, itineraryLandmark, conn);
                }
            }

            return GetItineraryByID(itinerary.ItineraryID);
        }

        private void EditSortOrder(int itineraryID, ItineraryLandmark landmark, SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("EditItineraryLandmarkSortOrder", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@itinerary_id", itineraryID);
            cmd.Parameters.AddWithValue("@landmark_id", landmark.LandmarkID);
            cmd.Parameters.AddWithValue("@sort_order", landmark.SortOrder);
            cmd.ExecuteNonQuery();
        }

        public void RemoveLandmarkFromItinerary(int itineraryID, int landmarkID)
        {
            using(SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("RemoveLandmarkFromItinerary", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@itinerary_id", itineraryID);
                cmd.Parameters.AddWithValue("@landmark_id", landmarkID);
                cmd.ExecuteNonQuery();
            }
        }

        public void DeleteItinerary(int itineraryID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("DeleteItinerary", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@itinerary_id", itineraryID);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
