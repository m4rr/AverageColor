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

  typealias CGFloatColorComps = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
  typealias UInt8ColorComps = (UInt8, UInt8, UInt8, UInt8)

  private let imageData: CFData, precision: Int, size: CGSize, dataPointer: UnsafePointer<UInt8>

  /// Init with precision
  ///
  /// - Parameter image: An image.
  /// - Parameter precision: A color is picked on each `n`-th pixel.
  init?(on image: UIImage?, precision: Int) {
    guard let imageData = image?.cgImage?.dataProvider?.data else {
      return nil
    }

    guard let dataPointer = CFDataGetBytePtr(imageData) else {
      return nil
    }

    self.imageData = imageData
    self.dataPointer = dataPointer

    self.precision = precision
    self.size = image!.size
  }

  func averageColor(line: Int = 0) -> UIColor {
    let wideStride = stride(from: 0, to: Int(size.width), by: precision)
    var numberOfItems = 0
    let colorComponents: [Int] =
      wideStride
        .map {
          numberOfItems += 1
          return pixelInfo(data: dataPointer, x: $0, y: line, width: size.width)
        }
        .reduce(Array(repeating: 0, count: 4), { (res: [Int], nxt: UInt8ColorComps) -> [Int] in
          return [res[0] + nxt.0,
                  res[1] + nxt.1,
                  res[2] + nxt.2,
                  res[3] + nxt.3]
        })

    return exportColor(from: (colorComponents[0] / numberOfItems,
                              colorComponents[1] / numberOfItems,
                              colorComponents[2] / numberOfItems,
                              colorComponents[3] / numberOfItems)
    )
  }

  private func pixelInfo(data: UnsafePointer<UInt8>, x: Int, y: Int, width: CGFloat) -> UInt8ColorComps {
    let pos = ((Int(round(width)) * y) + x) * 4

    return (data.advanced(by: pos + 0).pointee,
            data.advanced(by: pos + 1).pointee,
            data.advanced(by: pos + 2).pointee,
            data.advanced(by: pos + 3).pointee)
  }

  private func exportColor(from: CGFloatColorComps) -> UIColor {
    return UIColor(
      red:   CGFloat(from.r / 255.0),
      green: CGFloat(from.g / 255.0),
      blue:  CGFloat(from.b / 255.0),
      alpha: CGFloat(from.a / 255.0))
  }

}

private func / (lhs: Int, rhs: Int) -> CGFloat {
  return CGFloat(lhs) / CGFloat(rhs)
}

private func + (lhs: Int, rhs: UInt8) -> Int {
  return lhs + Int(rhs)
}

