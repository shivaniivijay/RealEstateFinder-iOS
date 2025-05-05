//
//  Property.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-12.
//

struct PropertyResponse: Codable {
    let props: [Property]
}

struct Property: Codable {
    let address: String
    let price: Double?
    let bedrooms: Int?
    let bathrooms: Int?
    let imgSrc: String?
    let propertyType: String?
    let livingArea: Int?
    let lotAreaValue: Double?
    let lotAreaUnit: String?
    let listingStatus: String?
    let zpid: String
    let detailUrl: String?
    
}
