//
//  CreateCustomComboViewModel.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

class CreateCustomComboViewModel: NSObject {
    
    var selectedToppings = [String]()
    
    lazy var context: NSManagedObjectContext = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Topping>! = {
        let fetchRequest: NSFetchRequest<Topping> = Topping.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: Constants.name, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: Constants.combos
        )
        
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        
        return frc
    }()
}
