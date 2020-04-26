//
//  ViewController.swift
//  TravelBook
//
//  Created by Oğuz Özgül on 27.04.2020.
//  Copyright © 2020 Oğuz Özgül. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self // Lokalizayonu Göster
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Ne Kadar Tahmin edecek Best En İyisi
        locationManager.requestWhenInUseAuthorization() // Kullanıcı İzni WheninUse program çalıştığında
        locationManager.startUpdatingLocation() // kullanıcıyı yeri almaya başlıyor
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.latitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    }

}

