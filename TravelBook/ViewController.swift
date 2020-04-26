//
//  ViewController.swift
//  TravelBook
//
//  Created by Oğuz Özgül on 27.04.2020.
//  Copyright © 2020 Oğuz Özgül. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
    }


}

