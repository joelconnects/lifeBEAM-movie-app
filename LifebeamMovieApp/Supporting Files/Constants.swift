//
//  Constants.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/30/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

struct Constants {
  struct DataModel {
    static let MovieCache = "MovieCache"
    static let Limit = 100
  }
  
  struct Alert {
    static let DefaultTitle = "Oh, the Horror!"
    static let DefaultMessage = "An error occurred. Click to try again."
    static let RetryFailedMessage = "This is embarrassingUnable to load movies. Check your internet connection and restart the app."
  }
}

struct Theme {
  struct Images {
    static let LaunchBackground = UIImage(named: "launch_background")!
    static let MainBackground = UIImage(named: "main_background")!
  }
  
  struct Icons {
    static let LoaderCameraReel = UIImage(named: "loader_camera_reel")!
    static let LoaderCameraBody = UIImage(named: "loader_camera_body")!
    static let LoaderCameraLens = UIImage(named: "loader_camera_lens")!
  }
}
