//
//  AlertPresenter.swift
//  sixpoint
//
//  Created by Joel Bell on 9/12/17.
//  Copyright © 2017 Sixpoint. All rights reserved.
//

import UIKit

// MARK: - UIAlertController+ViewLifeCycle
extension UIAlertController {
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.post(name: .alertControllerWillDisappearName, object: nil)
  }
}

// MARK: - AlertPresenter
final class AlertPresenter: UIViewController {
  
  typealias AlertControllerDismissed = () -> Void
  
  // MARK: - Properties
  private var alertControllerDismissed: AlertControllerDismissed?
  
  // MARK: - View lifecycle
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    alertControllerDismissed?()
  }
  
  // MARK: - Presentation
  public static func presentDefaultAlert(title: String, message: String, actionTitle: String, dismissalCallback: (()->())?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
    alertController.addAction(OKAction)
    
    let presenter = AlertPresenter()
    presenter.alertControllerDismissed = dismissalCallback
    presentAlert(controller: alertController, presenter: presenter, completion: nil)
  }
  
  private static func presentAlert(controller: UIAlertController, presenter: AlertPresenter, completion: (() -> ())?) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    
    alertWindow.rootViewController = presenter
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.makeKeyAndVisible()
    
    //    presenter.crossFade()
    presenter.present(controller, animated: true) {
      completion?()
    }
  }
}
