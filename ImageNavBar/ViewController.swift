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

    let color = ColorAverager(on: imageView.image!, precision: 20)?.averageColor()
    let gradientLayer = color?.verticalGradientLayer(to: color?.withAlphaComponent(0))
    gradientLayer?.frame = gradientView.bounds
    gradientView.layer.insertSublayer(gradientLayer!, at: 0)

    view.backgroundColor = color
  }

}
