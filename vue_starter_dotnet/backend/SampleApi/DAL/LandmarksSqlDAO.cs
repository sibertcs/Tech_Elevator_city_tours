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
               
                SqlCommand cmd = new SqlCommand("SELECT * FROM Landmarks WHERE landmark_id = @id" , conn);
                
                cmd.Parameters.AddWithValue("@id", id);

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
    }
}
