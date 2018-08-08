//
//  CoreDataStack.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 8/3/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  private let modelName: String
  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext // viewContext is 'The managed object context associated with the main queue'
  }()
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext() {
    guard managedContext.hasChanges else { return }
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
}
