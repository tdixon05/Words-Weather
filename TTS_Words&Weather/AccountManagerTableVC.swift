//
//  AccountManagerTableVC.swift
//  TTS_Words&Weather
//
//  Created by Trevonte Dixon on 3/28/17.
//  Copyright © 2017 1umbrella. All rights reserved.
//

import UIKit
import CoreData

class AccountManagerTableVC: UITableViewController {
    
    
    private let addAccountSegue = "AddAccountSegue"
    
    private let persistentContainer = NSPersistentContainer(name: "Accounts")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Account> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "accountName", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.hidesBackButton = true

        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
                    }
        }
        
    
    }
    


    
        //accountsArray = accountTableVM.accounts
    
    // MARK: - Setup UI
    
    fileprivate func updateView() {
        var hasAccounts = false
        
        if let accounts = fetchedResultsController.fetchedObjects {
            hasAccounts = accounts.count > 0
        }
//        
//        tableView.isHidden = !hasAccounts
//        messageLabel.isHidden = hasAccounts
//        
//        activityIndicatorView.stopAnimating()
    }
    
    private func setupView() {
//        setupMessageLabel()
        updateView()
    }
    
//    private func setupMessageLabel() {
//        messageLabel.text = "You don't have any quotes yet."
//    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accounts = fetchedResultsController.fetchedObjects else { return 0 }
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountManagerTableViewCell.reuseIdentifier, for: indexPath) as? AccountManagerTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let account = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.accountNameLabel.text = account.accountName
        cell.usernameLabel.text = account.accountUsername
        cell.passwordLabel.text = account.accountPassword
        cell.desctiptionLabel.text = account.accountDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Account
            let account = fetchedResultsController.object(at: indexPath)
            
            // Delete Quote
            account.managedObjectContext?.delete(account)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addAccountSegue {
            if let destinationViewController = segue.destination as? AddAccountVC {
                destinationViewController.managedObjectContext = persistentContainer.viewContext
                destinationViewController.persistentContainer = persistentContainer
            }
        }
    }
}




extension AccountManagerTableVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
}

