//
//  BaseViewController.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 11/11/22.
//

import UIKit

/**
 BaseViewController contains basic utility function and configurations
 that may be useful for most of the other viewController
 */
class BaseViewController: UIViewController {

    lazy var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavigationController()
    }
    
    func customiseNavigationController() {
        
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.foregroundColor: AppColors.navText]
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = titleTextAttributes
            appearance.backgroundColor = AppColors.primary
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = AppColors.primary
            self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    /**
     Show activity indicator on screen
     */
    func showActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    /**
     Hide activity indicator from view
     */
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showMessage(title: String? = nil, message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showMessage(title: title, message: message, actions: [okAction])
    }
    
    /**
    Show alert view with title, message and actions.
     
     - parameter title: Title to display in alert view.
     - parameter message: Message to display in alert view.
     - parameter actions: Alert actions items to be added in alert view.
     */
    func showMessage(title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        navigationController?.present(alert, animated: true, completion: nil)
    }

}
