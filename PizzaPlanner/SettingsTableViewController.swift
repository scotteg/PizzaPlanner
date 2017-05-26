//
//  SettingsTableViewController.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var numberCombosToDisplayTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func configureSettings() {
        let number = UserDefaults.standard.integer(forKey: Constants.numberCombosToDisplay)
        numberCombosToDisplayTextField.text = number > 0 ? "\(number)" : "\(Constants.defaultNumberCombosToDisplay)"
    }
}

// MARK: - UITextFieldDelegate
extension SettingsTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text,
            value.isEmpty == false,
            let number = Int(value)
            else {
                UserDefaults.standard.set(Constants.defaultNumberCombosToDisplay, forKey: Constants.numberCombosToDisplay)
                return
        }
        
        UserDefaults.standard.set(number, forKey: Constants.numberCombosToDisplay)
    }
}
