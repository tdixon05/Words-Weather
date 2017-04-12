//
//  AddAccountVC.swift
//  TTS_Words&Weather
//
//  Created by Trevonte Dixon on 3/29/17.
//  Copyright © 2017 1umbrella. All rights reserved.
//

import UIKit
import CoreData

class AddAccountVC: UIViewController {
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!

    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAccountPressed(_ sender: Any) {
        saveAccount()
    }
    
    func saveAccount() {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        // Create Quote
        let account = Account(context: managedObjectContext)
        
        // Configure Quote
        account.accountName = accountNameTextField.text
        account.accountUsername = usernameTextField.text
        account.accountPassword = passwordTextField.text
        account.accountDescription = descriptionTextField.text
        
        do {
            try persistentContainer?.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
