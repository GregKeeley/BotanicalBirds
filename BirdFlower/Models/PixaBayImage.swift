//
//  PixaBayImage.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

struct PixaBayImage: Codable {
    let totalHits: Int
    let hits: [Hit]
    let total: Int
}

struct Hit: Codable, Equatable {
    let largeImageURL: String
    let pageURL: String
    let webformatURL: String
    let previewURL: String
}
