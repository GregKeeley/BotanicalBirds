//
//  flickPhoto.swift
//  WeatherApp
//
//  Created by Gregory Keeley on 9/1/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import Foundation


/// This is the photo with the URL to be used with KingFisher

// MARK: - Welcome
struct Welcome: Codable {
    let photo: Photo
}
// MARK: - Photo
struct Photo: Codable {
    let id, secret: String
    let urls: Urls
}
// MARK: - Urls
struct Urls: Codable {
    let url: [URLElement]
}
// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case type
        case content = "_content"
    }
}
