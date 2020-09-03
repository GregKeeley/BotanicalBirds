//
//  PlantsListViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import DataPersistence

class PlantsListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var flowerData: [PlantsSpecies]?
    
    var dataPersistence: DataPersistence<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        loadFlowerData()
    }
    
    private func loadFlowerData() {
        flowerData = PlantsSpecies.decodeFlowers()
    }
    
}
extension PlantsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flowerData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantsCell", for: indexPath)

        return cell
    }
    
    
}
extension PlantsListViewController: UITableViewDelegate {
    
}
extension PlantsListViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
        self.dataPersistence = stack
    }
    
    
}
