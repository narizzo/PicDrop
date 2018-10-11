//
//  TakePictureOperation.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/21/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class TakePictureOperation: AsynchronousOperation, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  //weak var viewController: UIViewController?
  var viewController: UIViewController
  var image: UIImage?
  
  init(viewController: UIViewController) {
    print("3. TakePicture init")
    self.viewController = viewController
  }
  
  private lazy var imagePicker: UIImagePickerController = {
    let ip = UIImagePickerController()
    ip.delegate = self
    ip.sourceType = .camera
    ip.cameraFlashMode = .off
    ip.allowsEditing = false
    return ip
  }()
  
  override func main() {
    if isCancelled { finish() }
    DispatchQueue.main.async {
      self.viewController.present(self.imagePicker, animated: true, completion: nil)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    viewController.dismiss(animated: true, completion: nil)
    print("TakePicture finish")
    finish()
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    image = info[UIImagePickerControllerOriginalImage] as? UIImage
    viewController.dismiss(animated: true, completion: nil)
    print("TakePicture finish")
    finish()
  }
  
}
