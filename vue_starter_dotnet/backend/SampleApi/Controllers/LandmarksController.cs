﻿using System;
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

        [HttpGet("{query}", Name = "GetLandmarks")]
        public IEnumerable<Landmark> GetLandmarks(string query)
        {                        
            return landmarksDAO.LandmarksSearch((query == null ? "" : query));
        }

        [HttpGet("{id}", Name = "GetLandmark")]
        public Landmark GetLandmark(int id)
        {
            return landmarksDAO.LandmarkSearch(id);
        }
    }
}