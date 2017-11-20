//
//  LoaderViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
  
  // MARK: - Properties
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let blurEffect = UIBlurEffect(style: .regular)
    let effectView = UIVisualEffectView(effect: blurEffect)
    effectView.frame = view.frame
    effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(effectView)
    
    view.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    activityIndicator.startAnimating()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    activityIndicator.stopAnimating()
  }
}
