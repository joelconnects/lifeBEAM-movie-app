//
//  AppViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

private enum NavFlow  {
  case loading
  case list
  case detail
}

final class AppViewController: UIViewController {
  
  // MARK: - Properties
  private var containerView: UIView!
  private var actingViewController: UIViewController!
  private var backgroundImageView: UIImageView!
  private var initialViewAppeared: Bool = true
  private var navFlow: NavFlow = .loading {
    didSet {
      transitionViewControllers()
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackgroundImageView()
    configureContainerView()
    loadInitialViewController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if initialViewAppeared {
     initialViewAppeared = false
      UIView.transition(with: backgroundImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
        self.backgroundImageView.image = Theme.Images.MainBackground
      }, completion: nil)
    }
    
    // TODO: Remove after testing
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.navFlow = .list
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
  
  private func transitionViewControllers() {
    let exitingViewController = actingViewController
    exitingViewController?.willMove(toParentViewController: nil)
    
    actingViewController = loadViewController()
    self.addChildViewController(actingViewController)
    
    containerView.addSubview(actingViewController.view)
    actingViewController.view.frame = containerView.bounds
    
    actingViewController.view.translatesAutoresizingMaskIntoConstraints = false
    let bottomConstraint = actingViewController.view.bottomAnchor.constraint(equalTo: containerView.topAnchor)
    let topConstraint = actingViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor)
    actingViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    actingViewController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    actingViewController.view.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    
    bottomConstraint.isActive = true
    containerView.layoutIfNeeded()
    
//    actingViewController.view.alpha = 0
    
    bottomConstraint.isActive = false
    topConstraint.isActive = true
    
    UIView.animate(withDuration: 0.4, animations: {
      self.containerView.layoutIfNeeded()
//      self.actingViewController.view.alpha = 1
//      exitingViewController?.view.alpha = 0
      
    }) { completed in
      exitingViewController?.view.removeFromSuperview()
      exitingViewController?.removeFromParentViewController()
      self.actingViewController.didMove(toParentViewController: self)
    }
  }
  
  // MARK: - Helpers
  private func loadViewController() -> UIViewController {
    switch navFlow {
    case .loading:
      return LoaderViewController()
    case .list:
      return MoviesCollectionViewController(movies: [])
    case .detail:
      return UIViewController()
    }
  }
}
