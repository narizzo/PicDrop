//
//  PostsVC+QueueDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: QueueDelegate {
  func queueDidRequestRefresh<T>(_ queue: Queue<T>) {
    switch T.self {
    case is UUID.Type:
      fetchData()
    case is Post.Type:
      fetchPost()
    default:
      return
    }
  }
  
  func queueDidRecieveElements<T>(_ queue: Queue<T>) {
    switch T.self {
    case is UUID.Type:
      return
    case is Post.Type:
      feedNextPostToTinderImageViewManager()
    default:
      return
    }
  }
  
}
