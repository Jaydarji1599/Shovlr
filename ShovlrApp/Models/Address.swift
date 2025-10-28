//
//  Address.swift
//  Shovlr
//
//  Model representing a service address
//

import Foundation

struct Address: Codable, Identifiable, Equatable {
    let id: UUID
    var streetLine1: String
    var streetLine2: String?
    var city: String
    var province: String
    var postalCode: String
    var latitude: Double?
    var longitude: Double?

    init(
        id: UUID = UUID(),
        streetLine1: String,
        streetLine2: String? = nil,
        city: String,
        province: String,
        postalCode: String,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.streetLine1 = streetLine1
        self.streetLine2 = streetLine2
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
    }

    var fullAddress: String {
        var components = [streetLine1]
        if let line2 = streetLine2, !line2.isEmpty {
            components.append(line2)
        }
        components.append("\(city), \(province) \(postalCode)")
        return components.joined(separator: ", ")
    }

    var shortAddress: String {
        "\(streetLine1), \(city)"
    }
}
