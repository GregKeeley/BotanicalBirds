//
//  flickerSearch.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/1/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

/// This is the model when looking up photos to provide a secret and ID in order to do the lookup with "flickerPhoto" model
// MARK: - Welcome
struct FlickerSearchResult: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let photo: [PhotoResult]
}

// MARK: - Photo
struct PhotoResult: Codable {
    // ID and secret are needed for the photo lookup
    let id, secret, server: String
    let farm: Int
}
