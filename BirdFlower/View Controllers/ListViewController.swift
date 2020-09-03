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

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var birdData = [BirdsSpecies]()
    var plantData = [PlantsSpecies]()
    var favoriteDuos: [String]? {
        didSet {
            print("There are \(favoriteDuos?.count ?? -1) favorites")
        }
    }
    var randomDuos = [String]() {
        didSet {
            
        }
    }
    
    var dataPersistence: DataPersistence<String>?
    
    var persistenceDelegate: PersistenceStackClientDelegate?
    
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
        persistenceDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteDuos()
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
            let bird = birdData[i].commonName
            let plant = plantData[i].name
            let randomDuo = ("\(bird) + \(plant)")
            randomDuos.append(randomDuo)
            i += 1
            
        }
    }
    private func fetchFavoriteDuos() {
        do {
            favoriteDuos = try dataPersistence?.loadItems()
            dump(favoriteDuos)
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
extension ListViewController: UITableViewDelegate {
    
}
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSortType {
        case .randomDuos:
            return randomDuos.count
        case .birds:
            return birdData.count
        case .plants:
            return plantData.count
        case .favorites:
            return favoriteDuos?.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        // Common name
        switch currentSortType {
        case .randomDuos:
            navigationItem.title = "Random Pairs"
            navigationController?.navigationBar.prefersLargeTitles = true
            let randomDuo = randomDuos[indexPath.row]
            cell.textLabel?.text = ("\(randomDuo)")
            cell.detailTextLabel?.text = ""
        case .birds:
            navigationItem.title = "Birds"
            navigationController?.navigationBar.prefersLargeTitles = true
            let bird = birdData[indexPath.row]
            cell.textLabel?.text = "\(bird.commonName)"
            // Scinetific name
            cell.detailTextLabel?.text = "\(bird.scientificName)"
        case .plants:
            navigationItem.title = "Plants"
            navigationController?.navigationBar.prefersLargeTitles = true
            let flower = plantData[indexPath.row]
            cell.textLabel?.text = ("\(flower.name )")
            cell.detailTextLabel?.text = ""
        case .favorites:
            navigationItem.title = "Favorites"
            navigationController?.navigationBar.prefersLargeTitles = true
            let favorite = favoriteDuos?[indexPath.row]
            cell.textLabel?.text = ("\(favorite ?? "Coming soon")")
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
}
extension ListViewController: PersistenceStackClientDelegate {
    func setStack(stack: DataPersistence<String>) {
        self.dataPersistence = stack
    }
}
