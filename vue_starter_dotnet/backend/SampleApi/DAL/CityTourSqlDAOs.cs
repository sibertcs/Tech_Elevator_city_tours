using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SampleApi.DAL
{
    /// <summary>
    /// Container for all DAO objects 
    /// </summary>
    public class CityTourSqlDAOs : ICityTourDAOs
    {
        /// <summary>
        /// 
        /// </summary>
        public ILandmarksDAO landmarksDAO { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public IUserDAO userDAO { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="connectionString"></param>
        public CityTourSqlDAOs(string connectionString)
        {
            landmarksDAO = new LandmarksSqlDAO(connectionString);
            userDAO = new UserSqlDAO(connectionString);
        }
    }
}
