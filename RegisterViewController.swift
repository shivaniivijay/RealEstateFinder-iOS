//
//  RegisterViewController.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-12.
//
import UIKit
import CoreData
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Username and password are required.")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = User(context: context)
        user.name = nameField.text
        user.username = username
        user.email = emailField.text
        user.password = password
        user.city = cityField.text
        user.address = addressField.text
        user.zipCode = zipCodeField.text
        
        do {
            try context.save()
            
            let alert = UIAlertController(title: "Success", message: "User registered successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            })
            present(alert, animated: true)
            
        } catch {
            showAlert(title: "Error", message: "Failed to save user: \(error.localizedDescription)")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
