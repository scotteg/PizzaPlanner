//
//  TopCombosViewModel.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

class TopCombosViewModel: NSObject {
    
    var messageLabelText: String {
        let numberCombosToDisplay = UserDefaults.standard.integer(forKey: Constants.numberCombosToDisplay)
        return Constants.viewingTop + " \(numberCombosToDisplay) " + (numberCombosToDisplay == 1 ? Constants.combo : Constants.combos) + ". " + Constants.changeNumberToDisplayInSettings
    }
    
    lazy var context: NSManagedObjectContext = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Combo>! = {
        let fetchRequest: NSFetchRequest<Combo> = Combo.fetchRequest()
        
        fetchRequest.fetchBatchSize = Constants.defaultNumberCombosToDisplay
        
        fetchRequest.predicate = NSPredicate(format: "orderCount > 0")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: Constants.orderCount, ascending: false),
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
}
