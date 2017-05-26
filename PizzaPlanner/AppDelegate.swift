//
//  AppDelegate.swift
//  PizzaPlanner
//
//  Created by Scott Gardner on 12/23/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.pizzaPlanner)
        
        container.loadPersistentStores {
            if let error = $1 {
                print(error)
                return
            }
            
            print("Loaded", $0)
        }
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureTheme()
        configureSplitViewController()
        seed()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    func configureTheme() {
        UILabel.appearance().font = UIFont(name: Constants.avenirLight, size: 17.0)
        UILabel.appearance(whenContainedInInstancesOf: [MessageView.self]).font = UIFont(name: Constants.avenirLight, size: 12.0)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.7996205688, green: 0.1996477842, blue: 0.2297141254, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSFontAttributeName: UIFont(name: Constants.avenirLight, size: 20.0)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .normal)
        UITableView.appearance().separatorColor = #colorLiteral(red: 0.9187310934, green: 0.7327973247, blue: 0.3719691634, alpha: 1)
        UIControl.appearance().tintColor = #colorLiteral(red: 0.7996205688, green: 0.1996477842, blue: 0.2297141254, alpha: 1)
        UIControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func configureSplitViewController() {
        let splitViewController = window!.rootViewController as! UISplitViewController
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self
    }
    
    func seed() {
        guard UserDefaults.standard.bool(forKey: Constants.seeded) == false else { return }
        UserDefaults.standard.set(Constants.defaultNumberCombosToDisplay, forKey: Constants.numberCombosToDisplay)
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async {
            guard let filePath = Bundle.main.path(forResource: Constants.pizzaOrders, ofType: Constants.json),
                let data = FileManager.default.contents(atPath: filePath),
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: [String]]]
                else { return }
            
            var combos = [String: Int]()
            var allToppings = Set<String>()
            
            json.forEach {
                if let toppings = $0[Constants.toppings],
                    let comboString = $0[Constants.toppings]?.sorted().joined(separator: ", ") {
                    toppings.forEach { allToppings.insert($0) }
                    
                    if combos[comboString] != nil {
                        combos[comboString]! += 1
                    } else {
                        combos[comboString] = 1
                    }
                }
            }
            
            self.persistentContainer.performBackgroundTask { context in
                combos.forEach {
                    let combo = Combo(context: context)
                    combo.toppings = $0.key
                    combo.orderCount = Int64($0.value)
                }
                
                allToppings.forEach {
                    let topping = Topping(context: context)
                    topping.name = $0
                }
                
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
            
            UserDefaults.standard.set(true, forKey: Constants.seeded)
        }
    }
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
