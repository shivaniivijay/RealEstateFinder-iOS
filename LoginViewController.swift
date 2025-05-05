//
//  LoginViewController.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-12.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Username and password are required.")
            return
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let users = try context.fetch(fetchRequest)
            if users.first != nil {
                print("Login success!")
                performSegue(withIdentifier: "goToSearch", sender: nil)
            } else {
                print("Invalid credentials.")
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
}
