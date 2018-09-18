//
//  Post.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct Post {
  // Optional
  var date: Date?
  var downloadURL: URL?
  var downvotes: Int32?
  var image: UIImage?
  var upvotes: Int32?
  
  // Non-Optional
  var uuid: UUID
  
}

extension Post: Equatable {
  static func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
