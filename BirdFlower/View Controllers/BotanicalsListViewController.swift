//
//  BotanicalsListViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class PlantsListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var flowerData: [Flowers]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        loadFlowerData()
    }
    
    private func loadFlowerData() {
        flowerData = Flowers.decodeFlowers()
    }
    
}
extension PlantsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flowerData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        let flower = flowerData?[indexPath.row]
        cell.textLabel?.text = ("\(flower?.name ?? "FLOWER")")
        return cell
    }
    
    
}
extension PlantsListViewController: UITableViewDelegate {
    
}
