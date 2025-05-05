//
//  SearchZillowViewController.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-12.
//
import UIKit

class SearchZillowViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityField: UITextField! 
    @IBOutlet weak var minPriceField: UITextField!
    @IBOutlet weak var maxPriceField: UITextField!

    var properties: [Property] = []
    var filters: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }

    @IBAction func searchTapped(_ sender: UIButton) {
        fetchProperties()
    }
    
    @IBAction func openFilters(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
            filterVC.delegate = self
            present(filterVC, animated: true)
        }
    }


    func fetchProperties() {
            guard let city = cityField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  !city.isEmpty else {
                showAlert(message: "Please enter a city")
                return
            }
            
            var urlString = "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch?location=\(city)&status=FOR_SALE"
            
            if let minPrice = minPriceField.text, !minPrice.isEmpty {
                urlString += "&priceMin=\(minPrice)"
            }
            
            if let maxPrice = maxPriceField.text, !maxPrice.isEmpty {
                urlString += "&priceMax=\(maxPrice)"
            }
        
            if let bedsMin = filters["bedrooms"] {
                urlString += "&bedsMin=\(bedsMin)"
            }
            if let baths = filters["bathrooms"] {
            urlString += "&bathsMin=\(baths)"
            }
            if let status = filters["status"] {
                urlString += "&status=\(status)"
            } else {
                urlString += "&status=FOR_SALE"
            }
            if let bedsMax = filters["bedroomsMax"] {
            urlString += "&bedsMax=\(bedsMax)"
            }
            if let propertyType = filters["propertyType"] {
            urlString += "&propertyType=\(propertyType)"
            }
        
        
            
            guard let url = URL(string: urlString) else {
                showAlert(message: "Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("1298fb8878mshcb8be78b31448d6p1d5237jsn0fdd35ec0355", forHTTPHeaderField: "x-rapidapi-key")
            request.setValue("zillow-com1.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "No data received")
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(PropertyResponse.self, from: data)
                    self.properties = result.props
                    
                    DispatchQueue.main.async {
                        if self.properties.isEmpty {
                            self.showAlert(message: "No properties found matching your criteria")
                        }
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {
                        self.showAlert(message: "Failed to parse property data")
                    }
                }
            }
            
            task.resume()
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    extension SearchZillowViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return properties.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as? PropertyTableViewCell else {
                return UITableViewCell()
            }

            let property = properties[indexPath.row]
            
            cell.addressLabel.text = property.address
            if let price = property.price {
                cell.priceLabel.text = "$\(price.formattedWithSeparator)"
            } else {
                cell.priceLabel.text = "Price not available"
            }

            var details = ""
            if let beds = property.bedrooms {
                details += "\(beds) beds "
            }
            if let baths = property.bathrooms {
                details += "| \(baths) baths"
            }
            cell.detailLabel.text = details

            if let imgUrl = property.imgSrc, let url = URL(string: imgUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            cell.propertyImageView.image = UIImage(data: data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.propertyImageView.image = UIImage(systemName: "house")
                        }
                    }
                }
            } else {
                cell.propertyImageView.image = UIImage(systemName: "house")
            }

            return cell
        }

        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let property = properties[indexPath.row]
            FavoriteManager.shared.addToFavorites(property)

            let alert = UIAlertController(title: "Added!", message: "Property added to favorites.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)

        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }


extension SearchZillowViewController: FilterDelegate {
    func didApplyFilters(_ filters: [String: String]) {
        self.filters = filters
        fetchProperties()
    }
    
        
    }

extension Double {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
}
