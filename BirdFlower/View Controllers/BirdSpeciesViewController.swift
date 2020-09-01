//
//  ViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class BirdSpeciesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var birdData: [BirdsSpecies]? {
        didSet {
            print("There are \(birdData?.count ?? 0) birds")
        }
    }
    var flowerData: [Flowers]? {
        didSet {
            print("There are \(flowerData?.count ?? 0) flowers")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadBirdData()
        loadFlowerData()
    }
    private func loadBirdData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()
    }
    private func loadFlowerData() {
        flowerData = Flowers.decodeFlowers()
    }
}
extension BirdSpeciesViewController: UITableViewDelegate {
    
}
extension BirdSpeciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birdData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        // Common name
        let bird = birdData?[indexPath.row]
        
        cell.textLabel?.text = "\(bird?.commonName ?? "BIRD")"
        // Scinetific name
        cell.detailTextLabel?.text = "\(bird?.scientificName ?? "AVIAN")"
        return cell
    }
}
