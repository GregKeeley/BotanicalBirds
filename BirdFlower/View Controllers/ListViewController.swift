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
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables/Constants
    var birdData = [BirdsSpecies]()
    var plantData = [PlantsSpecies]()
    var favoriteDuos: [FavoriteDuo]? {
        didSet {
            print("There are \(favoriteDuos?.count ?? -1) favorites")
            tableView.reloadData()
        }
    }
    var randomDuos = [String]()
    
    public var dataPersistence: DataPersistence<FavoriteDuo>?
    
    var currentSortType = SortType.randomDuos {
        didSet {
            tableView.reloadData()
        }
    }
//    init(_ dataPersistence: DataPersistence<FavoriteDuo>) {
//        self.dataPersistence = dataPersistence
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataPersistence()
        tableView.dataSource = self
        tableView.delegate = self
        loadAllData()
        
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteDuos()
    }
    //MARK:- Functions
    private func getFavoritesFromRandomPairVC() {
        let barViewControllers = self.tabBarController?.viewControllers
        let randoVC = barViewControllers![1] as! RandomPairViewController
        self.favoriteDuos = randoVC.favoriteDuos
    }
    private func loadAllData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()!
        plantData = PlantsSpecies.decodeFlowers()!
//        fetchFavoriteDuos()
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
            print("Failed to load favorites")
//            showAlert(title: "Well, this is embarassing", message: "Failed to load favorites...")
        }
    }
    //MARK:- IBActions
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
    private func setupDataPersistence() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            dataPersistence = tabBarController.dataPersistence
        }
    }
}

//MARK:- Extensions
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
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
            if favoriteDuos?.count ?? -1 >= 1 {
                return favoriteDuos?.count ?? -1
            } else {
                return 1
            }
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
            if favoriteDuos?.count ?? -1 >= 1 {
                let favorite = favoriteDuos?[indexPath.row]
                cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird") + \(favorite?.plantName ?? "Plant")")
                cell.detailTextLabel?.text = ""
            } else {
                cell.textLabel?.text = "Looks like favorites is empty"
            }
        }
        return cell
    }
}

extension ListViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
//        self.dataPersistence = stack
    }
}
