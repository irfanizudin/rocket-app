//
//  Rocket.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import Foundation

struct Rocket: Codable {
    let id: String?
    let name: String?
    let description: String?
    let cost_per_launch: Int?
    let country: String?
    let first_flight: String?
    let flickr_images: [String]?
}
