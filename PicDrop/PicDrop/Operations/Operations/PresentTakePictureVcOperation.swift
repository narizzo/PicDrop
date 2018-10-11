//
//  PresentTakePictureVcOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/22/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreLocation

class PresentTakePictureVcOperation: Operation {
  
  private let viewController: UIViewController
  private let networkManager: NetworkManager
  private let locationManager: CLLocationManager
  
  init(viewController: UIViewController, networkManager: NetworkManager, locationManager: CLLocationManager) {
    self.viewController = viewController
    self.networkManager = networkManager
    self.locationManager = locationManager
  }
  
  override func main() {
    DispatchQueue.main.async {
      let takePictureVC = TakePictureViewController(networkManager: self.networkManager, locationManager: self.locationManager)
      self.viewController.present(takePictureVC, animated: true, completion: nil)
    }
  }
  
}
