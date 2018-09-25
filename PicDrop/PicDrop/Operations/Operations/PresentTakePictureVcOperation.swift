//
//  PresentTakePictureVcOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/22/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class PresentTakePictureVcOperation: Operation {
  
  weak var viewController: UIViewController?
  weak var networkManager: NetworkManager?
  
  init(viewController: UIViewController, networkManager: NetworkManager) {
    self.viewController = viewController
    self.networkManager = networkManager
  }
  
  override func main() {
    guard let viewController = self.viewController,
      let networkManager = self.networkManager else {
      self.cancel()
      return
    }
    DispatchQueue.main.async {
      let takePictureVC = TakePictureViewController(networkManager: networkManager)
      takePictureVC.networkManager = networkManager
      viewController.present(takePictureVC, animated: true, completion: nil)
    }
  }
  
}
