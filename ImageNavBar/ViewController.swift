//
//  ViewController.swift
//  ImageNavBar
//
//  Created by Marat Saytakov on 01/01/2017.
//  Copyright © 2017 m4rr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var gradientView: UIView!

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    gradientView.isHidden = !gradientView.isHidden
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let fromColor = ColorAverager(on: imageView.image!, precision: 20)?.averageColor()
    let gradientLayer = verticalGradientLayer(from: fromColor!, to: UIColor(white: 0.6, alpha: 0))
    gradientView.layer.insertSublayer(gradientLayer, at: 0)
    gradientLayer.frame = gradientView.bounds

    view.backgroundColor = fromColor
  }

  func verticalGradientLayer(from: UIColor?, to: UIColor?) -> CAGradientLayer {
    let gradient = CAGradientLayer()

    gradient.colors = [from, to].flatMap({ $0?.cgColor })

    return gradient
  }

}
