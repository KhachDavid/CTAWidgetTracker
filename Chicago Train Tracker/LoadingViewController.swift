//
//  LoadingViewController.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/12/23.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {

    let trainActivityIndicator = TrainAnimation()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add train activity indicator
        trainActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trainActivityIndicator)

        NSLayoutConstraint.activate([
            trainActivityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trainActivityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trainActivityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            trainActivityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // You can perform loading tasks here, e.g., fetching data or other background processes.

        // After loading, transition to the main page
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Simulating a 3-second loading time
            self.transitionToMainPage()
        }
    }

    private func transitionToMainPage() {
        let mainViewController = MainViewController()

        // Use a navigation controller for easy navigation
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isHidden = true // Hide the navigation bar if needed

        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
