//
//  LoaderViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

final class LoaderViewController: UIViewController {
  
  // MARK: - Properties
  private var effectView: UIVisualEffectView!
  private var reelStackView: UIStackView!
  private var cameraStackView: UIStackView!
  private var captionLabel: UILabel!
  
  private let reelLeftView = LoaderReelView()
  private let reelRightView = LoaderReelView()
  private let cameraBodyImageView = UIImageView(image: Theme.Icons.LoaderCameraBody)
  private let cameraLensImageView = UIImageView(image: Theme.Icons.LoaderCameraLens)
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureEffectView()
    configureStackViews()
    configureCaptionLabel()
    configureViewHierarchy()
    configureLayout()
  }
  
  // MARK: View configuration
  private func configureViewHierarchy() {
    view.addSubview(effectView)
    view.addSubview(cameraStackView)
    view.addSubview(cameraLensImageView)
    view.addSubview(captionLabel)
    reelStackView.addArrangedSubview(reelLeftView)
    reelStackView.addArrangedSubview(reelRightView)
    cameraStackView.addArrangedSubview(reelStackView)
    cameraStackView.addArrangedSubview(cameraBodyImageView)
  }
  
  private func configureLayout() {
    cameraStackView.translatesAutoresizingMaskIntoConstraints = false
    cameraStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
    cameraStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    
    reelStackView.translatesAutoresizingMaskIntoConstraints = false
    reelStackView.widthAnchor.constraint(equalToConstant: reelLeftView.frame.size.width * 2).isActive = true
    reelStackView.heightAnchor.constraint(equalToConstant: reelLeftView.frame.size.height).isActive = true
    
    cameraLensImageView.translatesAutoresizingMaskIntoConstraints = false
    cameraLensImageView.centerYAnchor.constraint(equalTo: cameraBodyImageView.centerYAnchor).isActive = true
    cameraLensImageView.leadingAnchor.constraint(equalTo: cameraBodyImageView.trailingAnchor, constant: 5).isActive = true
    
    captionLabel.translatesAutoresizingMaskIntoConstraints = false
    captionLabel.centerXAnchor.constraint(equalTo: cameraStackView.centerXAnchor).isActive = true
    captionLabel.topAnchor.constraint(equalTo: cameraStackView.bottomAnchor, constant: 10).isActive = true
  }
  
  private func configureEffectView() {
    let blurEffect = UIBlurEffect(style: .regular)
    effectView = UIVisualEffectView(effect: blurEffect)
    effectView.alpha = 0
    effectView.frame = view.frame
    effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private func configureStackViews() {
    reelStackView = UIStackView()
    reelStackView.axis = .horizontal
    reelStackView.distribution = .fillEqually
    reelStackView.spacing = 0

    cameraStackView = UIStackView()
    cameraStackView.axis = .vertical
    cameraStackView.distribution = .fill
    cameraStackView.spacing = 5
    cameraStackView.alignment = .center
  }
  
  private func configureCaptionLabel() {
    captionLabel = UILabel()
    captionLabel.text = "Loading movies"
    captionLabel.numberOfLines = 1
    captionLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
    captionLabel.textColor = .white
    captionLabel.textAlignment = .center
    captionLabel.adjustsFontSizeToFitWidth = true
    captionLabel.minimumScaleFactor = 0.8
    captionLabel.lineBreakMode = .byClipping
  }
  
  // MARK: - Helpers
  func pause() {
    reelLeftView.activityIndicator.stopAnimating()
    reelRightView.activityIndicator.stopAnimating()
    fadeCamera(alpha: 0)
  }
  
  func resume() {
    reelLeftView.activityIndicator.startAnimating()
    reelRightView.activityIndicator.startAnimating()
    fadeCamera(alpha: 1)
  }
  
  private func fadeCamera(alpha: CGFloat) {
    UIView.animate(withDuration: 0.3) {
      self.captionLabel.alpha = alpha
      self.reelLeftView.alpha = alpha
      self.reelRightView.alpha = alpha
      self.cameraBodyImageView.alpha = alpha
      self.cameraLensImageView.alpha = alpha
    }
  }
}
