//
//  TrefleAPIClient.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

// TODO: Replace instances of strings for the API call (completion handler, success case)
struct TrefleAPIClient {
    static func getPlantSpecies(completion: @escaping (Result<[String], AppError>) -> ()) {
        let trefleEndpoint = ""
        guard let url = URL(string: trefleEndpoint) else {
            completion(.failure(.badURL(trefleEndpoint)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode([String].self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
            
        }
    }
}
