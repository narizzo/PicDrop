//
//  Photo.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct Photo {
  var id: String
  var image: UIImage
  
  init(id: String, image: UIImage) {
    self.id = id
    self.image = image
  }
}
