//
//  ToppingsTableViewController.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

class ToppingsTableViewController: UITableViewController {
        
    lazy var viewModel = ToppingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchedResultsController.delegate = self
        
    }
    
    @IBAction func AddNewToppingTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Topping", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            $0.placeholder = "Topping name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let toppingName = alert.textFields?.first?.text,
                toppingName.isEmpty == false
                else { return }
            
            self?.viewModel.addToppingWith(name: toppingName)
        })
        
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteTopping(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ToppingsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell)!
        let topping = viewModel.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = topping.name?.capitalized
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToppingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ToppingsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
