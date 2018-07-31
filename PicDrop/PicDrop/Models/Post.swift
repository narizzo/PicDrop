//
//  Post.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/31/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct Post {
  var id: String
  var image: UIImage
  
  init(id: String, image: UIImage) {
    self.id = id
    self.image = image
  }
}
