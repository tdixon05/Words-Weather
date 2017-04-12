//
//  LoginVC.swift
//  TTS_Words&Weather
//
//  Created by Trevonte Dixon on 3/27/17.
//  Copyright © 2017 1umbrella. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var userHasAccount = false
    
    var currentTemp: Int?
    var city: String?
    var mainWeather: String?
    var weatherDiscription: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let defaults = UserDefaults.standard
//        if let userName = defaults.object(forKey:"TSUserName") {
//            print("🔻 viewDidLoad, username = \(userName)")
//        }
        
        guard let userName = defaults.object(forKey: Constants.userNameKey) as? String, let password = KeychainService.loadPassword() else {
                print("🔻 viewDidLoad, no username found")
                return
            }
        
        
        userNameTextField.text = userName
        userHasAccount = true
        print("🔹 viewDidLoad, username = \(userName): password = \(password)")
        
        if userHasAccount == true {
            loginButton.setTitle("Login", for: .normal)
        } else {
            loginButton.setTitle("Create an account", for: .normal)
        }
        
        
        getWeather() {
            returnedValue -> Void in
            print("🎯  \(returnedValue)")
        }
    }
    
// Mark: - Actions

    @IBAction func loginAction(_ sender: Any) {
        
        if userHasAccount {
            if  !LoginVM.loginVerification(userId: userNameTextField.text!, password: passwordTextField.text!) {
                let alertController = UIAlertController(title: "Failed Login", message: "Incorrect username or password", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Okay", style: .default , handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            if userNameTextField.text == "" || passwordTextField.text == "" {
                let alertController = UIAlertController(title: "Failed to create Account", message: "Your must include both a username and password", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Okay", style: .default , handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                print(" 🔻Error user needs to have a userName and passowrd")
            } else {
                if LoginVM.createAccount(userId: userNameTextField.text!, password: passwordTextField.text!) {
                    userHasAccount = true
                    passwordTextField.text = ""
                    loginButton.setTitle("Login", for: .normal)
                } else {
                    print("🔴 loginAction, failed to create an account")
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather(whenDone: @escaping (String) -> Void) {
        
        print("🎯 get weather")
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=charlotte&APPID=b4babdf7c4fc57ccb46e80d1bbf8d6cb")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {
            (data,response, error) -> Void in
            if let data = data {
                let json = JSON(data:data)
                self.parseWeatherJSON(json) {
                    returnedValue -> Void in
                    print("🎯 \(returnedValue)")
                    DispatchQueue.main.async (execute: {
                        whenDone("🎯 Weather Retrived")
                    })
                }
            }
        })
        task.resume()
    }
    
    func parseWeatherJSON ( _ json: JSON, doneParsing: (String) -> Void) {
        print(" 🎯 Parsing in process")
        let tempInKelvin = json["main"]["temp"].doubleValue
        currentTemp = Int(round(convertKelvin(kelvinTemp: tempInKelvin)))
        city = json["name"].stringValue
        for result in json["weather"].arrayValue {
            mainWeather = result["main"].stringValue
            weatherDiscription = result["description"].stringValue
        }
        doneParsing(" 🎯 Parsing Completed: currentTemp = \(currentTemp!), city = \(city!), mainWeather = \(mainWeather!), weatherDescription = \(weatherDiscription!)")
    }
    
    func convertKelvin(kelvinTemp: Double) -> Double {
        return kelvinTemp * 9/5 - 459.67
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
