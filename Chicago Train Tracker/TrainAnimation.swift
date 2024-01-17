//
//  TrainAnimation.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/12/23.
//

import Foundation
import UIKit

class TrainAnimation: UIView {

    private let trainImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    init() {
        super.init(frame: CGRect.zero)
        setupTrainImageView()
        startTrainAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTrainImageView() {
        addSubview(trainImageView)
        trainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trainImageView.topAnchor.constraint(equalTo: topAnchor),
            trainImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func startTrainAnimation() {
        var trainImages: [UIImage] = []
        
        for index in 1...96 {
            if let image = UIImage(named: "train\(index)") {
                trainImages.append(image)
            }
        }

        trainImageView.animationImages = trainImages
        trainImageView.animationDuration = 1.0
        trainImageView.animationRepeatCount = 0 // Infinite loop
        trainImageView.startAnimating()
    }
}
