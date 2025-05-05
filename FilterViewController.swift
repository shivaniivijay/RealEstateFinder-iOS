//
//  FilterViewController.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-13.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(_ filters: [String: String])
}

class FilterViewController: UIViewController {

    @IBOutlet weak var minBedsField: UITextField!
    @IBOutlet weak var maxBedsField: UITextField!
    @IBOutlet weak var bathrooms: UITextField!
    @IBOutlet weak var Status: UITextField!
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    @IBOutlet weak var propertyType: UITextField!

    weak var delegate: FilterDelegate?

    @IBAction func applyFiltersTapped(_ sender: UIButton) {
        var filters: [String: String] = [:]
        if let minBeds = minBedsField.text, !minBeds.isEmpty {
            filters["bedsMin"] = minBeds
        }
        if let maxBeds = maxBedsField.text, !maxBeds.isEmpty {
            filters["bedsMax"] = maxBeds
        }
        if let bathrooms = bathrooms.text, !bathrooms.isEmpty {
            filters["bathrooms"] = bathrooms
        }
        if let Status = Status.text, !Status.isEmpty {
            filters["status"] = Status
        }
        if let minPrice = minPrice.text, !minPrice.isEmpty {
            filters["priceMin"] = minPrice
        }
        if let maxPrice = maxPrice.text, !maxPrice.isEmpty {
            filters["priceMax"] = maxPrice
        }
        if let propertyType = propertyType.text, !propertyType.isEmpty {
            filters["propertyType"] = propertyType
        }
        
        delegate?.didApplyFilters(filters)
        dismiss(animated: true)
    }
}

