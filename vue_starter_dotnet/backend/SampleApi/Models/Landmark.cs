using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace SampleApi.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class Landmark
    {
        /// <summary>
        /// 
        /// </summary>
        public int ID { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string Name { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string Description { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string StreetAddress { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string City { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string State { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string ZipCode { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string DaysOpen { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string HoursOfOperation { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string Category { get; private set; }
        /// <summary>
        /// List of image objects
        /// </summary>
        private List<LandmarkImage> _images = new List<LandmarkImage>();
        /// <summary>
        /// Returns the contents of the private list of images
        /// </summary>
        public IEnumerable<LandmarkImage> Images
        {
            get
            {
                if(_images == null)
                {
                    _images = new List<LandmarkImage>();
                }
                return _images;
            }
        }
        /// <summary>
        /// Constructor to be used when creating an object with an existing dataset
        /// </summary>
        /// <param name="data"></param>
        public Landmark(IDataReader data)
        {
            ID = Convert.ToInt32(data["landmark_id"]);
            Name = Convert.ToString(data["landmark_name"]);
            Description = Convert.ToString(data["landmark_description"]);
            StreetAddress = Convert.ToString(data["street_address"]);
            City = Convert.ToString(data["city"]);
            State = Convert.ToString(data["state"]);
            ZipCode = Convert.ToString(data["zip_code"]);
            DaysOpen = Convert.ToString(data["days_open"]);
            HoursOfOperation = Convert.ToString(data["hours_of_operation"]);
            Category = Convert.ToString(data["category_name"]);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        public void AddImages(IDataReader reader)
        {
            while (reader.Read())
            {
                LandmarkImage image = new LandmarkImage(reader);
                _images.Add(image);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class LandmarkImage
    {
        /// <summary>
        /// The SQL ID of the Image
        /// </summary>
        public int ID { get; private set; }
        /// <summary>
        /// The url where the image is located
        /// </summary>
        public string Url { get; private set; }
        /// <summary>
        /// Description of the image
        /// </summary>
        public string Description { get; private set; }
        /// <summary>
        /// Who owns the image
        /// </summary>
        public string Credits { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        public LandmarkImage(IDataReader reader)
        {
            ID = Convert.ToInt32(reader["image_id"]);
            Url = Convert.ToString(reader["image_url"]);
            Description = Convert.ToString(reader["description"]);
            Credits = Convert.ToString(reader["credits"]);
        }
    }
}
