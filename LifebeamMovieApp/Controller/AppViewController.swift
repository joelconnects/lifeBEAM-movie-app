//
//  AppViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

private enum NavFlow  {
  case showLoader
  case showMovies
}

final class AppViewController: UIViewController {
  
  private let LOG_TAG = "AppViewController"
  
  // MARK: - Properties
  private var containerView: UIView!
  private var actingViewController: UIViewController!
  private var backgroundImageView: UIImageView!
  private var initialViewAppeared: Bool = true
  private let movieManager: MovieManager
  
  private var navFlow: NavFlow = .showLoader {
    didSet {
      transitionViewControllers()
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Initialization
  init(movieManager: MovieManager) {
    self.movieManager = movieManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .moviesReadyToDisplay, object: nil)
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackgroundImageView()
    configureContainerView()
    loadInitialViewController()
    
    NotificationCenter.default.addObserver(self, selector: #selector(movieManagerNotification(_:)), name: .moviesReadyToDisplay, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if initialViewAppeared {
     initialViewAppeared = false
      UIView.transition(with: backgroundImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
        self.backgroundImageView.image = Theme.Images.MainBackground
      }, completion: nil)
    }
  }
  
  // MARK: View configuration
  private func configureBackgroundImageView() {
    backgroundImageView = UIImageView(image: Theme.Images.LaunchBackground)
    backgroundImageView.contentMode = .scaleAspectFill
    view.addSubview(backgroundImageView)
    
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  private func configureContainerView() {
    containerView = UIView()
    containerView.frame = view.frame
    containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(containerView)
  }
  
  private func loadInitialViewController() {
    actingViewController = loadViewController()
    self.addChildViewController(actingViewController)
    containerView.addSubview(actingViewController.view)
    actingViewController.view.frame = containerView.bounds
    actingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    actingViewController.didMove(toParentViewController: self)
  }
  
  // MARK: - Transition
  private func transitionViewControllers() {
    let exitingViewController = actingViewController
    exitingViewController?.willMove(toParentViewController: nil)
    
    actingViewController = loadViewController()
    self.addChildViewController(actingViewController)
    
    containerView.addSubview(actingViewController.view)
    actingViewController.view.frame = containerView.bounds
    
    actingViewController.view.translatesAutoresizingMaskIntoConstraints = false
    let bottomConstraint = actingViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -UIScreen.main.bounds.height)
    actingViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    actingViewController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    actingViewController.view.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    
    bottomConstraint.isActive = true
    containerView.layoutIfNeeded()
    bottomConstraint.constant = 0
    
    UIView.animate(withDuration: 0.4, animations: {
      self.containerView.layoutIfNeeded()
      
    }) { completed in
      exitingViewController?.view.removeFromSuperview()
      exitingViewController?.removeFromParentViewController()
      self.actingViewController.didMove(toParentViewController: self)
    }
  }
  
  // MARK: - Navigation flow
  private func loadViewController() -> UIViewController {
    switch navFlow {
    case .showLoader:
      return LoaderViewController()
    case .showMovies:
      let collectionViewController = MoviesCollectionViewController(movieManager: movieManager)
      let navigationController = UINavigationController(rootViewController: collectionViewController)
      return navigationController
    }
  }

  @objc private func movieManagerNotification(_ notification: Notification) {
    if notification.name == .moviesReadyToDisplay && navFlow != .showMovies {
      navFlow = .showMovies
    }
  }
}
