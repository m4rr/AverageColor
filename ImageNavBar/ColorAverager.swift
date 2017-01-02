//
//  ColorAverager.swift
//  ImageNavBar
//
//  Created by Marat Saytakov on 01/01/2017.
//  Copyright © 2017 m4rr. All rights reserved.
//

import Foundation
import UIKit

class ColorAverager {

  private typealias CGFloatComps = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
  private typealias UInt8Comps = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)

  private let imageData: CFData, precision: Int, size: CGSize, dataPointer: UnsafePointer<UInt8>

  /// Init with precision
  ///
  /// - Parameter image: A UIImage to analize.
  /// - Parameter precision: A color is picked on each `n`-th pixel.
  init?(on image: UIImage?, precision: Int = 10) {
    guard let imageData = image?.cgImage?.dataProvider?.data else {
      return nil
    }

    guard let dataPointer = CFDataGetBytePtr(imageData) else {
      return nil
    }

    self.imageData = imageData
    self.dataPointer = dataPointer

    self.precision = precision
    self.size = image!.size // checked for a value earlier
  }

  /// Scans a line of given image and picks color components (r, g, b, a)
  /// of each `precision` pixel (each 10-th i.e.)
  /// Then calculates average of each component and makes UIColor.
  ///
  /// - Parameter line: row of image to scan; i.e., the first one (number 0)
  /// - Returns: An average UIColor of image's `line`.
  func averageColor(line: Int = 0) -> UIColor {
    return averageColor(pointer: dataPointer, line: line, precision: precision, width: size.width)
  }

  private func averageColor(pointer: UnsafePointer<UInt8>, line: Int, precision: Int, width: CGFloat) -> UIColor {
    let wideStride = stride(from: 0, to: Int(width), by: precision)
    var numberOfItems = 0
    let colorComponents: [Int] =
      wideStride
        .map { x in
          defer {
            numberOfItems += 1
          }
          return pixelInfo(data: pointer, x: x, y: line, width: size.width)
        }
        .reduce(Array(repeating: 0, count: 4), { (res: [Int], nxt: UInt8Comps) -> [Int] in
          return [
            res[0] + nxt.0,
            res[1] + nxt.1,
            res[2] + nxt.2,
            res[3] + nxt.3,
          ]
        })

    return exportColor(from: (colorComponents[0] / numberOfItems,
                              colorComponents[1] / numberOfItems,
                              colorComponents[2] / numberOfItems,
                              colorComponents[3] / numberOfItems)
    )
  }

  private func pixelInfo(data: UnsafePointer<UInt8>, x: Int, y: Int, width: CGFloat) -> UInt8Comps {
    let pos = ((Int(round(width)) * y) + x) * 4

    return (data.advanced(by: pos + 0).pointee,
            data.advanced(by: pos + 1).pointee,
            data.advanced(by: pos + 2).pointee,
            data.advanced(by: pos + 3).pointee)
  }

  private func exportColor(from: CGFloatComps) -> UIColor {
    return UIColor(red:   from.r / 255.0,
                   green: from.g / 255.0,
                   blue:  from.b / 255.0,
                   alpha: from.a / 255.0)
  }

}

extension UIColor {

  func verticalGradientLayer(to: UIColor?) -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.colors = [self, to].flatMap({ $0?.cgColor })
    return gradient
  }

}

private func / (lhs: Int, rhs: Int) -> CGFloat {
  return CGFloat(lhs) / CGFloat(rhs)
}

private func + (lhs: Int, rhs: UInt8) -> Int {
  return lhs + Int(rhs)
}
