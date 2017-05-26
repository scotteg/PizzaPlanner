//
//  ToppingsViewModel.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

class ToppingsViewModel: NSObject {
    
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
            cacheName: Constants.toppings
        )
        
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        
        return frc
    }()
    
    func addToppingWith(name: String) {
        let topping = Topping(context: context)
        topping.name = name.lowercased()
        save()
    }
    
    func deleteTopping(at indexPath: IndexPath) {
        context.delete(fetchedResultsController.object(at: indexPath))
        save()
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
