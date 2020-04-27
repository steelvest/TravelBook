//
//  listViewController.swift
//  TravelBook
//
//  Created by Oğuz Özgül on 27.04.2020.
//  Copyright © 2020 Oğuz Özgül. All rights reserved.
//

import UIKit

class listViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableVİew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        
        
        tableVİew.delegate = self
        tableVİew.dataSource = self
        // Do any additional setup after loading the view.
    }
    @objc func addButton() {
        performSegue(withIdentifier: "toDetailsegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "text"
        return cell
    }
}
