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
  
  private let LOG_TAG = "AppViewController"
  
  // MARK: - Properties
  private var containerView: UIView!
  private var actingViewController: UIViewController!
  private var backgroundImageView: UIImageView!
  private var initialViewAppeared: Bool = true
  
  private lazy var movieManager: MovieManager = {
    let movieDataModelManager = MovieDataModelManager(dataModelName: Constants.DataModel.Name)
    return MovieManager(movieDataModelManager: movieDataModelManager)
  }()
  
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
    loadMovies()
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
    case .loading:
      return LoaderViewController()
    case .list:
      let collectionViewController = MoviesCollectionViewController(movieManager: movieManager)
      let navigationController = UINavigationController(rootViewController: collectionViewController)
      return navigationController
    case .detail:
      return UIViewController()
    }
  }
  
  // MARK: - Helpers
  private func loadMovies(attempts: Int = 0) {
    guard let loaderViewController = (self.actingViewController as? LoaderViewController) else {
      Log.e(tag: self.LOG_TAG, message: "\(#function) should only be called when LoadingViewController is acting view controller")
      return
    }
    
    if attempts == 3 {
      loaderViewController.pause()
//      self.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.RetryFailedMessage, actionTitle: Constants.Alert.RetryFailedActionTitle, actionCallback: {
//        Log.f(tag: self.LOG_TAG, message: "Retry reached maximum attempts and failed")
//      })
      
      AlertPresenter.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.RetryFailedMessage, actionTitle: Constants.Alert.RetryFailedActionTitle, dismissalCallback: {
        Log.f(tag: self.LOG_TAG, message: "Retry reached maximum attempts and failed")
      })
      
      return
    }
    
    movieManager.loadMovies { success in
      if success {
        self.navFlow = .list
      } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(attempts) * 1.5, execute: {
          loaderViewController.pause()
//          self.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.DefaultMessage, actionTitle: Constants.Alert.DefaultActionTitle, actionCallback: {
//            loaderViewController.resume()
//            self.loadMovies(attempts: attempts + 1)
//          })
          
          AlertPresenter.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.DefaultMessage, actionTitle: Constants.Alert.DefaultActionTitle, dismissalCallback: {
            loaderViewController.resume()
            self.loadMovies(attempts: attempts + 1)
          })
        })
      }
    }
  }
  
  // MARK: - Alerts
  private func presentDefaultAlert(title: String, message: String, actionTitle: String, actionCallback: (()->())?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: actionTitle, style: .default) { _ in
      actionCallback?()
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
