//
//  ImageNavBarTests.swift
//  ImageNavBarTests
//
//  Created by Marat Saytakov on 08/01/2017.
//  Copyright © 2017 m4rr. All rights reserved.
//

import XCTest

class ImageNavBarTests: XCTestCase {

  var averager: ColorAverager! = nil

  override func setUp() {
    super.setUp()

    averager = ColorAverager(on: #imageLiteral(resourceName: "Yandex-Images-2016-12-28"))
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testAverageColorTiming() {
    measure {
      _ = self.averager.averageColor()
    }
  }

  func testDownsizingTiming() {

    self.measure {
      _ = self.averager.imageDownsizingColorPicker()
    }
  }

}
