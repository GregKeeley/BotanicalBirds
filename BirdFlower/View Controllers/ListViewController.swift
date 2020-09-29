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
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterStack: UIStackView!
    
    //MARK:- Variables/Constants
    var resultSearchController = UISearchController()
    var birdData = [BirdsSpecies]() {
        didSet {
            tableView.reloadData()
        }
    }
    var plantData = [PlantsSpecies]() {
        didSet {
            tableView.reloadData()
        }
    }
    var favoriteDuos: [FavoriteDuo]? {
        didSet {
            if favoriteDuos?.isEmpty ?? true {
                //                resultSearchController.searchBar.isUserInteractionEnabled = true
                tableView.backgroundView = EmptyView.init(title: "Looks like you don't have any favorites :(", message: "Head over to the \"Shuffle\" tab and tap the heart button on any pair you want to save and come back here to check them out", imageName: "heart.fill")
                tableView.separatorStyle = .none
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
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
    var currentSortMethod = SortMethod.ascending {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    var filterIsActive = false {
        didSet {
            if filterIsActive {
                collectionViewTopConstraint.constant = 8
                filterStack.isHidden = false
            } else {
                collectionViewTopConstraint.constant = -44
                filterStack.isHidden = true
            }
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
        setupSearchController()
        sortAllDataCollections()
        filterIsActive = false
//        configureMessageLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteDuos()
        generateRandomDuos()
        tableView.reloadData()
        checkToEnableShuffle()
        configureMessageLabel()
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
    private func configureMessageLabel() {
        messageLabel.sizeToFit()
        messageLabel.layer.cornerRadius = 4
        messageLabel.clipsToBounds = true
        lowerBound = view.frame.height * 0.07
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        shuffleBarButton.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        sortMethodBarButton.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        navigationItem.hidesSearchBarWhenScrolling = true
        setSearchBarPlaceHolderText(currentListType)
        view.backgroundColor = .systemBackground
    }
    
    private func sortAllDataCollections() {
        if currentSortMethod == .ascending {
            birdData = birdData.sorted(by: {$0.commonName < $1.commonName})
            plantData = plantData.sorted(by: {$0.name < $1.name})
            favoriteDuos = favoriteDuos?.sorted(by: {$0.birdCommonName < $1.birdCommonName})
            randomDuos = randomDuos.sorted(by: {$0.birdCommonName < $1.birdCommonName})
            filteredRandoms = filteredRandoms.sorted(by: {$0.birdCommonName < $1.birdCommonName})
            filteredFavorites = filteredFavorites?.sorted(by: {$0.birdCommonName < $1.birdCommonName})
            filteredBirdData = filteredBirdData.sorted(by: {$0.commonName < $1.commonName})
            filteredPlantData = filteredPlantData.sorted(by: {$0.name < $1.name})
        } else {
            birdData = birdData.sorted(by: {$0.commonName > $1.commonName})
            plantData = plantData.sorted(by: {$0.name > $1.name})
            favoriteDuos = favoriteDuos?.sorted(by: {$0.birdCommonName > $1.birdCommonName})
            randomDuos = randomDuos.sorted(by: {$0.birdCommonName > $1.birdCommonName})
            filteredRandoms = filteredRandoms.sorted(by: {$0.birdCommonName > $1.birdCommonName})
            filteredFavorites = filteredFavorites?.sorted(by: {$0.birdCommonName > $1.birdCommonName})
            filteredBirdData = filteredBirdData.sorted(by: {$0.commonName > $1.commonName})
            filteredPlantData = filteredPlantData.sorted(by: {$0.name > $1.name})
        }
        tableView.reloadData()
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
            filteredFavorites = favoriteDuos?.sorted(by: {$0.birdCommonName < $1.birdCommonName})
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
    // TODO: Move these variables to the proper section
    let upperBound = CGFloat(0)
    var lowerBound = CGFloat(100)
    
    private func animateLabelForSave(code: Int) {
        // Save Codes
        // 1: Favorite saved successfully
        // 2: FAvorite already saved
        // 3: Favorite removed successfully
        // 4: Error
        messageLabel.alpha = 0.0
        messageLabel.textColor = .white
        var message = ""
        switch code {
        case 1:
            message = "Favorite Saved"
            messageLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6940027566, blue: 0, alpha: 1)
        case 2:
            message = "Already saved"
            messageLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 3:
            message = "Favorite removed"
            messageLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 4:
            message = "Error"
            messageLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        default:
            break
        }
        
            messageLabel.text = message
            while messageLabel.frame.origin.y < lowerBound {
                messageLabelTopConstraint.constant += 1
                UIView.animate(withDuration: 0.5,
                               delay: 0.0,
                               options: [],
                               animations: {
                    self.messageLabel.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: { finished in
                    while self.messageLabel.frame.origin.y > self.upperBound {
                        self.messageLabelTopConstraint.constant -= 1
                        UIView.animate(withDuration: 0.5,
                                       delay: 1.0,
                                       options: [],
                                       animations: {
                            self.messageLabel.alpha = 0.0
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                    }
                })
            }
        }
    private func updateListType() {
        switch currentListType {
        case .birds:
            break
        case .plants:
            break
        case .favorites:
            break
        case .randomDuos:
            break
        }
    }
    //MARK:- IBActions
    @IBAction func toggleButtonPressed(_ sender: UIBarButtonItem) {
        filterIsActive.toggle()
    }
    @IBAction func favoriteFilterButtonPressed(_ sender: UIButton) {
        currentListType = .favorites
    }
    @IBAction func birdsFilterButtonPressed(_ sender: UIButton) {
        currentListType = .birds
    }
    @IBAction func plantsFilterButtonPressed(_ sender: UIButton) {
        currentListType = .plants
    }
    @IBAction func randomPairsFilterButtonPressed(_ sender: UIButton) {
        currentListType = .randomDuos
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
            sortAllDataCollections()
            sortMethodBarButton.title = "Zz-Aa"
        } else {
            currentSortMethod = .ascending
            sortAllDataCollections()
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
            let randomDuo: FavoriteDuo?
            if currentlySearching {
                randomDuo = filteredRandoms[indexPath.row]
            } else {
                randomDuo = randomDuos[indexPath.row]
            }
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                detailVC.duo = randomDuo
                if let navigator = navigationController {
                    dismiss(animated: true, completion: nil)
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        case .birds:
            let bird: BirdsSpecies?
            if currentlySearching {
                bird = filteredBirdData[indexPath.row]
            } else {
                bird = birdData[indexPath.row]
            }
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                let birdToPass = FavoriteDuo(birdCommonName: bird?.commonName ?? "Bird", birdScientificName: bird?.scientificName ?? "Plant", plantName: "")
                detailVC.duo = birdToPass
                if let navigator = navigationController {
                    dismiss(animated: true, completion: nil)
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        case .plants:
            let plant: PlantsSpecies?
            if currentlySearching {
                plant = filteredPlantData[indexPath.row]
            } else {
                plant = plantData[indexPath.row]
            }
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                let plantToPass = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: plant?.name ?? "Plant")
                detailVC.duo = plantToPass
                if let navigator = navigationController {
                    dismiss(animated: true, completion: nil)
                    navigator.pushViewController(detailVC, animated: true)
                }
            }
        case .favorites:
            let favoriteDuo: FavoriteDuo?
            if currentlySearching {
                favoriteDuo = filteredFavorites?[indexPath.row]
            } else {
                favoriteDuo = favoriteDuos?[indexPath.row]
            }
            if let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
                detailVC.duo = favoriteDuo
                if let navigator = navigationController {
                    dismiss(animated: true, completion: nil)
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
            var randomDuo: FavoriteDuo?
            if currentlySearching {
                randomDuo = filteredRandoms[indexPath.row]
            } else {
                randomDuo = randomDuos[indexPath.row]
            }
            cell.textLabel?.text = ("\(randomDuo?.birdCommonName ?? "Bird") + \(randomDuo?.plantName ?? "Plant")")
            cell.detailTextLabel?.text = ""
        case .birds:
            navigationItem.title = "Birds"
            navigationController?.navigationBar.prefersLargeTitles = true
            let bird: BirdsSpecies?
            if currentlySearching {
                bird = filteredBirdData[indexPath.row]
            } else {
                bird = birdData[indexPath.row]
            }
            cell.textLabel?.text = "\(bird?.commonName ?? "Bird")"
            cell.detailTextLabel?.text = "\(bird?.scientificName ?? "Scientific")"
        case .plants:
            navigationItem.title = "Plants"
            navigationController?.navigationBar.prefersLargeTitles = true
            let plant: PlantsSpecies?
            if currentlySearching {
                plant = filteredPlantData[indexPath.row]
            } else {
                plant = plantData[indexPath.row]
            }
            cell.textLabel?.text = ("\(plant?.name ?? "")")
            cell.detailTextLabel?.text = ""
        case .favorites:
            navigationItem.title = "Favorites"
            navigationController?.navigationBar.prefersLargeTitles = true
            let favorite: FavoriteDuo?
            if currentlySearching {
                if filteredFavorites?.count ?? 0 >= 1 {
                    favorite = filteredFavorites?[indexPath.row]
                    if favorite?.plantName == "" {
                        cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird")")
                        cell.detailTextLabel?.text = "Bird only"
                    } else if favorite?.birdCommonName == "" {
                        cell.textLabel?.text = ("\(favorite?.plantName ?? "Plant")")
                        cell.detailTextLabel?.text = "Plant only"
                    } else {
                    cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird") + \(favorite?.plantName ?? "Plant")")
                    cell.detailTextLabel?.text = ""
                    }
                }
            } else {
                if favoriteDuos?.count ?? 0 >= 1 {
                    favorite = favoriteDuos?[indexPath.row]
                    if favorite?.plantName == "" {
                        cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird")")
                        cell.detailTextLabel?.text = "Bird only"
                    } else if favorite?.birdCommonName == "" {
                        cell.textLabel?.text = ("\(favorite?.plantName ?? "Plant")")
                        cell.detailTextLabel?.text = "Plant only"
                    } else {
                        cell.textLabel?.text = ("\(favorite?.birdCommonName ?? "Bird") + \(favorite?.plantName ?? "Plant")")
                        cell.detailTextLabel?.text = ""
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Save Codes
        // 1: Favorite saved successfully
        // 2: FAvorite already saved
        // 3: Favorite removed successfully
        // 4: Error
        
        // Delete a favorite from favorites list
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if self.currentListType == .favorites {
                guard let favoriteItem = self.favoriteDuos?[indexPath.row] else {
                    return
                }
                guard let favoriteIndex = self.favoriteDuos?.firstIndex(of: favoriteItem ) else {
                    return
                }
                do {
                    try self.dataPersistence?.deleteItem(at: favoriteIndex)
                    self.favoriteDuos?.remove(at: indexPath.row)
                    self.animateLabelForSave(code: 3)
                } catch {
                    self.animateLabelForSave(code: 4)
                }
            }
        }
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { (action, indexPath) in
            if self.currentListType != .favorites {
                switch self.currentListType {
                case .birds:
                    var item = BirdsSpecies(commonName: "", scientificName: "")
                    if self.currentlySearching {
                        item = self.filteredBirdData[indexPath.row]
                    } else {
                        item = self.birdData[indexPath.row]
                    }
                    let itemToBeSaved = FavoriteDuo(birdCommonName: item.commonName, birdScientificName: item.scientificName, plantName: "")
                    if !(self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                        do {
                            try self.dataPersistence?.createItem(itemToBeSaved)
                            self.animateLabelForSave(code: 1)
                        } catch {
                            self.animateLabelForSave(code: 4)
                        }
                    } else if (self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                        self.animateLabelForSave(code: 2)
                    }
                case .plants:
                    var item = PlantsSpecies(name: "")
                    if self.currentlySearching {
                        item = self.filteredPlantData[indexPath.row]
                    } else {
                        item = self.plantData[indexPath.row]
                    }
                    let itemToBeSaved = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: item.name)
                    if !(self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                        do {
                            try self.dataPersistence?.createItem(itemToBeSaved)
                            self.animateLabelForSave(code: 1)
                        } catch {
                            self.animateLabelForSave(code: 4)
                        }
                    } else if (self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                        self.animateLabelForSave(code: 2)
                    }
                case .randomDuos:
                    var item = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: "")
                    if self.currentlySearching {
                        item = self.filteredRandoms[indexPath.row]
                    } else {
                        item = self.randomDuos[indexPath.row]
                    }
                    let itemToBeSaved = FavoriteDuo(birdCommonName: item.birdCommonName, birdScientificName: item.birdScientificName, plantName: item.plantName)
                    if !(self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                        do {
                            try self.dataPersistence?.createItem(itemToBeSaved)
                            self.animateLabelForSave(code: 1)
                        } catch {
                            self.animateLabelForSave(code: 4)
                        }
                    } else if (self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                        self.animateLabelForSave(code: 2)
                    }
                default:
                    break
                }
            }
            self.fetchFavoriteDuos()
        }
        favorite.backgroundColor = #colorLiteral(red: 0, green: 0.6940027566, blue: 0, alpha: 1)
        if currentListType == .favorites {
            return [delete]
        } else {
            return [favorite]
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
