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
    static let Name = "MovieDataModel"
    static let Limit = 100
  }
  
  struct Alert {
    static let DefaultTitle = "Oh, the horror!"
    static let DefaultMessage = "Check your internet connection and try again."
    static let DefaultActionTitle = "Try again".uppercased()
    static let RetryFailedMessage = "These movies just don't want to load. Check your internet connection and restart the app."
    static let RetryFailedActionTitle = "Close app".uppercased()
  }
}

struct Theme {
  struct Images {
    static let LaunchBackground = UIImage(named: "launch_background")!
    static let MainBackground = UIImage(named: "main_background")!
    static let PosterPlaceholder = UIImage(named: "poster_placeholder")!
    static let PosterGradient = UIImage(named: "poster_gradient")!
    static let DetailPosterPlaceholder = UIImage(named: "detail_poster_placeholder")!
    static let LoaderCameraReel = UIImage(named: "loader_camera_reel")!
    static let LoaderCameraBody = UIImage(named: "loader_camera_body")!
    static let LoaderCameraLens = UIImage(named: "loader_camera_lens")!
  }
  struct Icons {
    static let CloseButton = UIImage(named: "close_button")!
  }
}

extension Notification.Name {
  static let moviesReadyToDisplay = Notification.Name("moviesReadyToDisplay")
  static let movieDetailRequested = Notification.Name("movieDetailRequested")
  static let alertPresented = Notification.Name("alertPresented")
  static let alertDismissed = Notification.Name("alertDismissed")
}
