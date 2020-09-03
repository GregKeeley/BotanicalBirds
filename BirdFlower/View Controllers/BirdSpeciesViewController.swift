//
//  ViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import DataPersistence

enum SortType {
    case birds
    case plants
    case favorites
    case randomDuos
}

class BirdSpeciesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var birdData = [BirdsSpecies]() 
    var plantData = [PlantsSpecies]()
    var favoriteDuos: [String]?
    var randomDuos = [String]() {
        didSet {
            
        }
    }
    
    var dataPersistence: DataPersistence<String>?
    
    var currentSortType = SortType.randomDuos {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadAllData()
    }
    private func loadAllData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()!
        plantData = PlantsSpecies.decodeFlowers()!
        fetchFavoriteDuos()
        generateRandomDuos()
    }
    // Note: This is a great example of indexing into the smaller of two arrays for data!
    private func generateRandomDuos() {
        var i = 0
        for _ in 0..<min(plantData.count, birdData.count) {
            let bird = birdData[i]
            let plant = plantData[i]
                randomDuos.append("\(bird) + \(plant)")
            i += 1
        }
    }
    private func fetchFavoriteDuos() {
        do {
            favoriteDuos = try dataPersistence?.loadItems()
        } catch {
            showAlert(title: "Well, this is embarassing", message: "Failed to load favorites...")
        }
    }
    @IBAction func toggleButtonPressed(_ sender: UIBarButtonItem) {
        switch currentSortType {
        case .birds:
            currentSortType = .plants
        case .plants:
            currentSortType = .favorites
        case .favorites:
            currentSortType = .randomDuos
        case .randomDuos:
            currentSortType = .birds
        }
    }
    
}
extension BirdSpeciesViewController: UITableViewDelegate {
    
}
extension BirdSpeciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        // Common name
        switch currentSortType {
        case .randomDuos:
            let randomDuo = randomDuos[indexPath.row]
            cell.textLabel?.text = ("\(randomDuo)")
        case .birds:
            let bird = birdData[indexPath.row]
            cell.textLabel?.text = "\(bird.commonName)"
            // Scinetific name
            cell.detailTextLabel?.text = "\(bird.scientificName)"
        case .plants:
            let flower = plantData[indexPath.row]
            cell.textLabel?.text = ("\(flower.name )")
        case .favorites:
            let favorite = favoriteDuos?[indexPath.row]
            cell.textLabel?.text = ("\(favorite ?? "BIRD + PLANT")")
        }
        return cell
    }
}
extension BirdSpeciesViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
        self.dataPersistence = stack
    }
}
