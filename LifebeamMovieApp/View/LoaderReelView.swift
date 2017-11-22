//
//  LoaderReelView.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

final class LoaderReelView: UIView {
  
  // MARK: - Properties
  private let fixedFrame = CGRect(x: 0, y: 0, width: 60, height: 60)
  let activityIndicator = UIActivityIndicatorView()
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: fixedFrame)
    configureView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  // MARK: - View configuration
  private func configureView() {
    let reelImageView = UIImageView(image: Theme.Images.LoaderCameraReel)
    addSubview(reelImageView)
    reelImageView.translatesAutoresizingMaskIntoConstraints = false
    reelImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    reelImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    reelImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    reelImageView.heightAnchor.constraint(equalTo: reelImageView.widthAnchor).isActive = true

    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: reelImageView.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: reelImageView.centerYAnchor).isActive = true
    
    activityIndicator.startAnimating()
  }
}
