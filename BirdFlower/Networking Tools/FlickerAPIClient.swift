//
//  FlickerAPIClient.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/1/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

struct FlickerAPI {
    static func searchPhotos(searchQuery: String, contentType: ListType, completion: @escaping (Result<FlickerSearchResult, AppError>) -> ()) {
        var tag = ""
        if contentType == .birds {
            tag = "bird"
        } else {
            tag = "plant"
        }
        let search = searchQuery.replacingOccurrences(of: " ", with: "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        //        let flickerPhotoSearchEndpoint = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.flickerAPIKey)&tags=\(search ?? "Taco")&per_page=1&page=&format=json&nojsoncallback=1&&tags=\(tag)".lowercased()
        //        let safeFlickerPhotoSearchEndpoint = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.flickerAPIKey)&tags=\(search ?? "Taco")&per_page=1&page=&format=json&nojsoncallback=1&safe_search=1&tags=\(tag)".lowercased()
        let flickerPhotoSearchEndpoint = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.flickerAPIKey)&tags=\(search ?? "Taco")&per_page=1&page=&format=json&nojsoncallback=1".lowercased()
        guard let url = URL(string: flickerPhotoSearchEndpoint) else {
            completion(.failure(.badURL(flickerPhotoSearchEndpoint)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (results) in
            switch results {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(FlickerSearchResult.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    static func getUserPhotoURL(photoID: String, photoSecret: String, farm: Int, server: String, completion: @escaping (Result<FlickerPhoto, AppError>) -> ()) {
        let flickerPhotoEndpoint = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(photoSecret)_m.jpg".lowercased()
        guard let url = URL(string: flickerPhotoEndpoint) else {
            completion(.failure(.badURL(flickerPhotoEndpoint)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (results) in
            switch results {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(FlickerPhoto.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
