//
//  ViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import DataPersistence

class BirdSpeciesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var birdData: [BirdsSpecies]?
    
    var dataPersistence: DataPersistence<String>?
    
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadBirdData()
    }
    private func loadBirdData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()
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
extension BirdSpeciesViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
        self.dataPersistence = stack
    }
}
