//
//  Photo.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct Photo {
  var uuid: UUID
  var image: UIImage
  
  init(uuid: UUID, image: UIImage) {
    self.uuid = uuid
    self.image = image
  }
}
