//
//  CustomCombosViewModel.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

class CustomCombosViewModel: NSObject {
    
    var messageLabelText: String {
        if let objects = fetchedResultsController.fetchedObjects,
            objects.count > 0 {
            return Constants.tapToFavoriteCombosMessage
        } else {
            return Constants.noCustomCombosMessage
        }
    }
    
    lazy var context: NSManagedObjectContext = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Combo>! = {
        let fetchRequest: NSFetchRequest<Combo> = Combo.fetchRequest()
        
        fetchRequest.fetchBatchSize = Constants.defaultNumberCombosToDisplay
        
        fetchRequest.predicate = NSPredicate(format: "orderCount == 0")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: Constants.toppings, ascending: true)
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
    
    func addNewCustomComboWith(toppings: String) {
        let combo = Combo(context: context)
        combo.toppings = toppings
        combo.orderCount = 0
        save()
    }
    
    func deleteCustomCombo(at indexPath: IndexPath) {
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
