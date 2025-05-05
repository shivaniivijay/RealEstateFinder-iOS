//
//  FavoritesViewController.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-12.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    var favoriteProperties: [Property] = []
    var filteredProperties: [Property] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        loadFavorites()
    }
    
    func loadFavorites() {
        favoriteProperties = FavoriteManager.shared.getFavorites()
        filteredProperties = favoriteProperties
        tableView.reloadData()
    }

    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath)
        let property = filteredProperties[indexPath.row]
        cell.textLabel?.text = property.address
        cell.detailTextLabel?.text = "$\(property.price) | \(property.bedrooms) beds"
        
        return cell
    }
    
    // MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProperties = favoriteProperties
        } else {
            filteredProperties = favoriteProperties.filter {
                $0.address.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    // MARK: - Sort
    
    @IBAction func sortChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filteredProperties.sort { ($0.price ?? 0.0) < ($1.price ?? 0.0) }
        case 1:
            filteredProperties.sort { ($0.bedrooms ?? 0) < ($1.bedrooms ?? 0) }
        default:
            break
        }
        tableView.reloadData()
    }


    // MARK: - Logout
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "loggedInUser")

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let window = delegate.window {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }

}
