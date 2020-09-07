//
//  ViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import DataPersistence
import SafariServices

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
    var randomDuos = [FavoriteDuo]()
    
    public var dataPersistence: DataPersistence<FavoriteDuo>?
    
    var currentSortType = SortType.randomDuos {
        didSet {
            tableView.reloadData()
        }
    }

    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataPersistence()
        tableView.dataSource = self
        tableView.delegate = self
        loadAllData()
        setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteDuos()
    }
    
    //MARK:- Functions
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }
    private func getFavoritesFromRandomPairVC() {
        let barViewControllers = self.tabBarController?.viewControllers
        let randoVC = barViewControllers![1] as! RandomPairViewController
        self.favoriteDuos = randoVC.favoriteDuos
    }
    private func loadAllData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()!
        plantData = PlantsSpecies.decodeFlowers()!
        generateRandomDuos()
    }
    // Note: This is a great example of indexing into the smaller of two arrays for data!
    private func generateRandomDuos() {
        var i = 0
        for _ in 0..<min(plantData.count, birdData.count) {
            let birdCommonName = birdData[i].commonName
            let birdScientificName = birdData[i].scientificName
            let plantName = plantData[i].name
            let randomDuo = FavoriteDuo(birdCommonName: birdCommonName, birdScientificName: birdScientificName, plantName: plantName)
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
    private func setupDataPersistence() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            dataPersistence = tabBarController.dataPersistence
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
    
    @IBAction func aboutButtonPressed(_ sender: UIBarButtonItem) {
        if let aboutVC = UIStoryboard(name: "AboutViewController", bundle: nil).instantiateViewController(identifier: "aboutViewController") as? AboutViewController {
            if let navigator = navigationController {
                navigator.pushViewController(aboutVC, animated: true)
            }
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

//MARK:- Extensions
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentSortType {
        case .randomDuos:
            let item = randomDuos[indexPath.row]
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                detailVC.duo = item
                if let navigator = navigationController {
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        case .birds:
            let item = birdData[indexPath.row]
            let itemToPass = FavoriteDuo(birdCommonName: item.commonName, birdScientificName: item.scientificName, plantName: "")
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                detailVC.duo = itemToPass
                if let navigator = navigationController {
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        case .plants:
            let item = plantData[indexPath.row]
            let itemToPass = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: item.name)
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                detailVC.duo = itemToPass
                if let navigator = navigationController {
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        case .favorites:
            guard let item = favoriteDuos?[indexPath.row] else {
                return
            }
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                detailVC.duo = item
                if let navigator = navigationController {
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        }
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
            if favoriteDuos?.count ?? 0 >= 1 {
                return favoriteDuos?.count ?? 0
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        switch currentSortType {
        case .randomDuos:
            navigationItem.title = "Random Pairs"
            navigationController?.navigationBar.prefersLargeTitles = true
            let randomDuo = randomDuos[indexPath.row]
            cell.textLabel?.text = ("\(randomDuo.birdCommonName) + \(randomDuo.plantName)")
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
            if favoriteDuos?.count ?? 0 >= 1 {
                let favorite = favoriteDuos?[indexPath.row]
                cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird") + \(favorite?.plantName ?? "Plant")")
                cell.detailTextLabel?.text = ""
            } else {
                cell.textLabel?.text = "Looks like favorites is empty"
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if favoriteDuos?.count ?? 0 > 0 {
        return currentSortType == .favorites
        } else {
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if currentSortType == .favorites {
                favoriteDuos?.remove(at: indexPath.row)
                tableView.reloadData()
            }
        case .insert:
            break
        default:
            print("...")
        }
    }
}

extension ListViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
        //        self.dataPersistence = stack
    }
}
