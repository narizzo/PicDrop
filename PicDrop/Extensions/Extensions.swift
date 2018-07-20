//
//  Extensions.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(r: Int, g: Int, b: Int, a: Int) {
    self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
  }
}
