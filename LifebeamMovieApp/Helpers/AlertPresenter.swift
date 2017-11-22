//
//  AlertPresenter.swift
//  sixpoint
//
//  Created by Joel Bell on 9/12/17.
//  Copyright © 2017 Sixpoint. All rights reserved.
//

import UIKit

// MARK: - AlertPresenter
final class AlertPresenter: UIViewController {
  
  typealias AlertControllerDismissed = () -> Void
  
  // MARK: - Properties
  private var alertControllerDismissed: AlertControllerDismissed?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - View lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.post(name: .alertPresented, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    alertControllerDismissed?()
    NotificationCenter.default.post(name: .alertDismissed, object: nil)
  }
  
  // MARK: - Presentation
  public static func presentDefaultAlert(title: String, message: String, actionTitle: String, dismissalCallback: (()->())?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
    alertController.addAction(OKAction)
    
    let presenter = AlertPresenter()
    presenter.alertControllerDismissed = dismissalCallback
    presentAlert(controller: alertController, presenter: presenter)
  }
  
  private static func presentAlert(controller: UIAlertController, presenter: AlertPresenter) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    
    alertWindow.rootViewController = presenter
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.makeKeyAndVisible()
  
    presenter.present(controller, animated: true, completion: nil)
  }
}
