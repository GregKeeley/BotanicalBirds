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

enum ListType {
    case birds
    case plants
    case favorites
    case randomDuos
}
enum SortMethod {
    case ascending
    case descending
}
class ListViewController: UIViewController {

    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shuffleBarButton: UIBarButtonItem!
    @IBOutlet weak var sortMethodBarButton: UIBarButtonItem!
    
    //MARK:- Variables/Constants
    
    var resultSearchController = UISearchController()
    
    var birdData = [BirdsSpecies]()
    var plantData = [PlantsSpecies]()
    var favoriteDuos: [FavoriteDuo]? {
        didSet {
            if favoriteDuos?.isEmpty ?? true {
//                resultSearchController.searchBar.isUserInteractionEnabled = true
                tableView.backgroundView = EmptyView.init(title: "Looks like you don't have any favorites :(", message: "Head over to the \"Shuffle\" tab and tap the heart button on any pair you want to save and come back here to check them out", imageName: "heart.fill")
                tableView.separatorStyle = .none
            } else {
                tableView.backgroundView = nil
            }
        }
    }
    var randomDuos = [FavoriteDuo]() {
        didSet {
            tableView.reloadData()
        }
    }
    var filteredBirdData = [BirdsSpecies]()
    var filteredPlantData = [PlantsSpecies]()
    var filteredFavorites: [FavoriteDuo]?
    var filteredRandoms = [FavoriteDuo]()
    
    public var dataPersistence: DataPersistence<FavoriteDuo>?
    
    // Determines whether the sorting method is ascending or descending
    var currentSortMethod = SortMethod.ascending
    
    // Set to true when a user is using the search bar
    var currentlySearching = false
    // Used to capture what the user is searching for, to be displayed as section header
    var searchText = ""
    
    var currentListType = ListType.randomDuos {
        didSet {
            tableView.reloadData()
            checkToEnableShuffle()
        }
    }
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataPersistence()
        tableView.dataSource = self
        tableView.delegate = self
//        searchBar.delegate = self
        loadAllData()
        setupNavigationBar()
        setupSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteDuos()
        generateRandomDuos()
        tableView.reloadData()
        checkToEnableShuffle()
    }
    
    //MARK:- Functions
    private func setupSearchController() {
        resultSearchController = ({
        let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.obscuresBackgroundDuringPresentation = false
            controller.automaticallyShowsSearchResultsController = false
            tableView.tableHeaderView = controller.searchBar
            return controller
    })()
        
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        shuffleBarButton.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        sortMethodBarButton.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        navigationItem.hidesSearchBarWhenScrolling = true
        setSearchBarPlaceHolderText(currentListType)
    }
    private func getFavoritesFromRandomPairVC() {
        let barViewControllers = self.tabBarController?.viewControllers
        let randoVC = barViewControllers![1] as! RandomPairViewController
        self.favoriteDuos = randoVC.favoriteDuos
    }
    private func loadAllData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()!
        plantData = PlantsSpecies.decodeFlowers()!
        fetchFavoriteDuos()
    }
    // Note: This is a great example of indexing into the smaller of two arrays for data!
    private func generateRandomDuos() {
        for _ in 0..<min(plantData.count, birdData.count) {
            let birdCommonName = birdData.randomElement()?.commonName ?? ""
            let birdScientificName = birdData.randomElement()?.scientificName ?? ""
            let plantName = plantData.randomElement()?.name ?? ""
            let randomDuo = FavoriteDuo(birdCommonName: birdCommonName, birdScientificName: birdScientificName, plantName: plantName)
            randomDuos.append(randomDuo)
        }
    }
    private func fetchFavoriteDuos() {
        do {
            favoriteDuos = try dataPersistence?.loadItems()
        } catch {
            print("Failed to load favorites")
        }
    }
    private func setupDataPersistence() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            dataPersistence = tabBarController.dataPersistence
        }
    }
    private func checkToEnableShuffle() {
        if currentListType == .randomDuos {
            shuffleBarButton.isEnabled = true
        } else {
            shuffleBarButton.isEnabled = false
        }
        
    }
    private func searchList(_ query: String, listType: ListType) {
        switch listType {
        case .birds:
            filteredBirdData = birdData.filter {
                $0.commonName.lowercased().contains(query.lowercased())
            }
        case .plants:
            filteredPlantData = plantData.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        case .randomDuos:
            filteredRandoms = randomDuos.filter {
                $0.birdCommonName.lowercased().contains(query.lowercased()) || $0.plantName.lowercased().contains(query.lowercased())
            }
        case .favorites:
            filteredFavorites = favoriteDuos?.filter  {
                $0.birdCommonName.lowercased().contains(query.lowercased()) || $0.plantName.lowercased().contains(query.lowercased())
                }
        }
    }
    private func setSearchBarPlaceHolderText(_ listType: ListType) {
        switch listType {
        case .birds:
            resultSearchController.searchBar.placeholder = "Search Birds"
        case .favorites:
            resultSearchController.searchBar.placeholder = "Search Favorites"
        case .plants:
            resultSearchController.searchBar.placeholder = "Search Plants"
        case .randomDuos:
            resultSearchController.searchBar.placeholder = "Search Random Pairs"
        }
    }
    //MARK:- IBActions
    @IBAction func toggleButtonPressed(_ sender: UIBarButtonItem) {
        switch currentListType {
        case .birds:
            currentListType = .plants
            setSearchBarPlaceHolderText(currentListType)
        case .plants:
            currentListType = .favorites
            setSearchBarPlaceHolderText(currentListType)
        case .favorites:
            currentListType = .randomDuos
            setSearchBarPlaceHolderText(currentListType)
        case .randomDuos:
            currentListType = .birds
            setSearchBarPlaceHolderText(currentListType)
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
    @IBAction func shuffleRandomDuos(_ sender: UIBarButtonItem) {
        randomDuos.removeAll()
        generateRandomDuos()
    }
    @IBAction func changeSortMethodButtonPressed(_ sender: UIBarButtonItem) {
        if currentSortMethod == .ascending {
            currentSortMethod = .descending
            sortMethodBarButton.title = "Zz-Aa"
        } else {
            currentSortMethod = .ascending
            sortMethodBarButton.title = "Aa-Zz"
        }
        tableView.reloadData()
    }
}

//MARK:- Extensions
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentListType {
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
        switch currentListType {
        case .randomDuos:
            if currentlySearching {
                return filteredRandoms.count
            } else {
                return randomDuos.count
            }
        case .birds:
            if currentlySearching {
                return filteredBirdData.count
            } else {
            return birdData.count
            }
        case .plants:
            if currentlySearching {
                return filteredPlantData.count
            } else {
            return plantData.count
            }
        case .favorites:
            if currentlySearching {
               return filteredFavorites?.count ?? 0
            } else {
            return favoriteDuos?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        switch currentListType {
        case .randomDuos:
            navigationItem.title = "Random Pairs"
            navigationController?.navigationBar.prefersLargeTitles = true
            let randomDuo: FavoriteDuo?
            if currentlySearching {
                var sortRandomDuos = filteredRandoms.sorted(by: {$0.birdCommonName < $1.birdCommonName})
                if currentSortMethod == .descending {
                    sortRandomDuos = filteredRandoms.sorted(by: {$0.birdCommonName > $1.birdCommonName})
                }
                randomDuo = sortRandomDuos[indexPath.row]
            } else {
                var sortRandomDuos = randomDuos.sorted(by: {$0.birdCommonName < $1.birdCommonName})
                if currentSortMethod == .descending {
                    sortRandomDuos = randomDuos.sorted(by: {$0.birdCommonName > $1.birdCommonName})
                }
                randomDuo = sortRandomDuos[indexPath.row]
            }
            cell.textLabel?.text = ("\(randomDuo?.birdCommonName ?? "bird") + \(randomDuo?.plantName ?? "Plant")")
            cell.detailTextLabel?.text = ""
        case .birds:
            navigationItem.title = "Birds"
            navigationController?.navigationBar.prefersLargeTitles = true
            let bird: BirdsSpecies?
            if currentlySearching {
                var sortedBirds = filteredBirdData.sorted(by: {$0.commonName < $1.commonName })
                if currentSortMethod == .descending {
                    sortedBirds = filteredBirdData.sorted(by: {$0.commonName > $1.commonName})
                }
                bird = sortedBirds[indexPath.row]
            } else {
                var sortedBirds = birdData.sorted(by: {$0.commonName < $1.commonName })
                if currentSortMethod == .descending {
                    sortedBirds = birdData.sorted(by: {$0.commonName > $1.commonName})
                }
                bird = sortedBirds[indexPath.row]
            }
            cell.textLabel?.text = "\(bird?.commonName ?? "Bird")"
            cell.detailTextLabel?.text = "\(bird?.scientificName ?? "Scientific Name")"
        case .plants:
            navigationItem.title = "Plants"
            navigationController?.navigationBar.prefersLargeTitles = true
            let plant: PlantsSpecies?
            if currentlySearching {
                var sortedPlants = filteredPlantData.sorted(by: {$0.name < $1.name })
                if currentSortMethod == .descending {
                    sortedPlants = filteredPlantData.sorted(by: {$0.name > $1.name })
                }
                plant = sortedPlants[indexPath.row]
            } else {
                var sortedPlants = plantData.sorted(by: {$0.name < $1.name })
                if currentSortMethod == .descending {
                    sortedPlants = plantData.sorted(by: {$0.name > $1.name })
                }
                plant = sortedPlants[indexPath.row]
            }
            cell.textLabel?.text = ("\(plant?.name ?? "Plant")")
            cell.detailTextLabel?.text = ""
        case .favorites:
            navigationItem.title = "Favorites"
            navigationController?.navigationBar.prefersLargeTitles = true
            let favorite: FavoriteDuo?
            if currentlySearching {
                var sortedFavorites = filteredFavorites?.sorted(by: { $0.birdCommonName < $1.birdCommonName })
                if currentSortMethod == .descending {
                    sortedFavorites = filteredFavorites?.sorted(by: { $0.birdCommonName > $1.birdCommonName })
                }
                if sortedFavorites?.count ?? 0 >= 1 {
                    favorite = sortedFavorites?[indexPath.row]
                    cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird") + \(favorite?.plantName ?? "Plant")")
                    cell.detailTextLabel?.text = ""
                }
            } else {
                var sortedFavorites = favoriteDuos?.sorted(by: { $0.birdCommonName < $1.birdCommonName })
                if currentSortMethod == .descending {
                    sortedFavorites = favoriteDuos?.sorted(by: { $0.birdCommonName > $1.birdCommonName })
                }
                if sortedFavorites?.count ?? 0 >= 1 {
                    favorite = sortedFavorites?[indexPath.row]
                    cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird") + \(favorite?.plantName ?? "Plant")")
                    cell.detailTextLabel?.text = ""
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if favoriteDuos?.count ?? 0 > 0 {
            return currentListType == .favorites
        } else {
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // Check sort type is favorites (We dont want to be able to delete anything else)
            if currentListType == .favorites {
                // Make sure we have a favorite item
                guard let favoriteItem = favoriteDuos?[indexPath.row] else {
                    return
                }
                // Get the index of the item to remove later
                guard let favoriteIndex = favoriteDuos?.firstIndex(of: favoriteItem ) else {
                    showAlert(title: "Could not find favorite", message: "Failed to remove favorite, or it wasn't a favorite to begin with")
                    return
                }
                do {
                    // Delete the favorite item from data persistence
                    try dataPersistence?.deleteItem(at: favoriteIndex)
                } catch {
                    showAlert(title: "Failed to remove favorite", message: "Your guess is as good as mine")
                }
                // Finally, we can remove the item from the array of favorites, and reload the tableview
                favoriteDuos?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //                tableView.reloadData()
            }
        case .insert:
            break
        default:
            print("...")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if currentlySearching {
            switch currentListType {
            case .birds:
                return ("\(filteredBirdData.count) items found")
            case .plants:
                return ("\(filteredPlantData.count) items found")
            case .favorites:
                return ("\(filteredFavorites?.count ?? 0) items found")
            case .randomDuos:
                return ("\(filteredRandoms.count) items found")
            }
        }
        return ""
    }
}

extension ListViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
        //        self.dataPersistence = stack
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            currentlySearching = false
            tableView.reloadData()
            return
        }
        currentlySearching = true
        loadAllData()
        //        if !searchText.isEmpty {
        self.searchText = searchText
        searchList(searchText, listType: currentListType)
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentlySearching = false
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        loadAllData()
        tableView.reloadData()
    }
}
