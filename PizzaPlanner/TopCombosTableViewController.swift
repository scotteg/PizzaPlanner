//
//  TopCombosTableViewController.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

class TopCombosTableViewController: UITableViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    lazy var viewModel = TopCombosViewModel()
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = viewModel.messageLabelText
        configureTableView()
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
}

// MARK: - UITableViewDataSource
extension TopCombosTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.integer(forKey: Constants.numberCombosToDisplay)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell) as! TopComboCell
        let combo = viewModel.fetchedResultsController.object(at: indexPath)
        cell.comboLabel.text = combo.toppings?.capitalized
        let orderCountString = numberFormatter.string(from: NSNumber(value: combo.orderCount))!
        cell.orderCountLabel.text = orderCountString + " " + (combo.orderCount == 1 ? Constants.order : Constants.orders)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TopCombosTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
