//
//  CustomCombosTableViewController.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

class CustomCombosTableViewController: UITableViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    var starView: UIImageView {
        return UIImageView(image: PizzaPlannerStyleKit.imageOfFavorite)
    }
    
    lazy var viewModel = CustomCombosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMessageLabel()
        configureTableView()
        viewModel.fetchedResultsController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.save()
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) { }
    
    @IBAction func saveCustomCombo(segue: UIStoryboardSegue) {
        guard let controller = segue.source as? CreateCustomComboTableViewController else { return }
        let toppings = controller.viewModel.selectedToppings.sorted().joined(separator: ", ")
        viewModel.addNewCustomComboWith(toppings: toppings)
    }
    
    func updateMessageLabel() {
        messageLabel.text = viewModel.messageLabelText
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteCustomCombo(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension CustomCombosTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell)!
        let combo = viewModel.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = combo.toppings?.capitalized
        
        if combo.isFavorite {
            cell.accessoryView = starView
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CustomCombosTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let combo = viewModel.fetchedResultsController.object(at: indexPath)
        
        if combo.isFavorite {
            cell.accessoryView = nil
            combo.isFavorite = false
        } else {
            cell.accessoryView = starView
            combo.isFavorite = true
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CustomCombosTableViewController: NSFetchedResultsControllerDelegate {
    
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
        updateMessageLabel()
    }
}
