//
//  CreateCustomComboTableViewController.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

class CreateCustomComboTableViewController: UITableViewController {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    lazy var viewModel = CreateCustomComboViewModel()
}

// MARK: - UITableViewDataSource
extension CreateCustomComboTableViewController {
    
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
        
        if viewModel.selectedToppings.contains(topping.name!) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CreateCustomComboTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let toppingName = viewModel.fetchedResultsController.object(at: indexPath).name,
            let cell = tableView.cellForRow(at: indexPath)
            else { return }
        
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            viewModel.selectedToppings.append(toppingName)
        } else if let index = viewModel.selectedToppings.index(of: toppingName) {
            cell.accessoryType = .none
            viewModel.selectedToppings.remove(at: index)
        }
        
        doneBarButton.isEnabled = viewModel.selectedToppings.count > 0
    }
}
