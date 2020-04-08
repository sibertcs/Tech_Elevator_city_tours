﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SampleApi.DAL
{
    public interface ICityTourDAOs
    {
        ILandmarksDAO landmarksDAO { get; }
        IUserDAO userDAO { get; }
    }
}
