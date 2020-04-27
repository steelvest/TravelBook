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
import CoreData
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    var locationManager = CLLocationManager()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var selectedTitle = ""
    var selectedTitleId : UUID?
    
    
    var annotationTitle = ""
    var annotationSubTitle = ""
    var annotationLatitude  : Double
    var annotationlongtude : Double
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        
        mapView.delegate = self
        locationManager.delegate = self // Lokalizayonu Göster
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Ne Kadar Tahmin edecek Best En İyisi
        locationManager.requestWhenInUseAuthorization() // Kullanıcı İzni WheninUse program çalıştığında
        locationManager.startUpdatingLocation() // kullanıcıyı yeri almaya başlıyor
        
        let gestureRecorganizer =   UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecorganizer:)))
        gestureRecorganizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecorganizer)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //let klavyeKapat = UITapGestureRecognizer(target: "self", action: #selector(hideKeyboard))
        //view.addGestureRecognizer(klavyeKapat)
        
        view.addGestureRecognizer(tap)
        
        if selectedTitle != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let stringUUID = selectedTitleId!.uuidString
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            fetchRequest.predicate = NSPredicate(format: "id %@", stringUUID)
            
            do {
                 let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title =  result.value(forKey: "title") as? String {
                            annotationTitle = title
                        }
                        if let subtitle =  result.value(forKey: "subtitle") as? String {
                            annotationSubTitle = subtitle
                        }
                        if let latitude =  result.value(forKey: "latitude") as? Double {
                            annotationLatitude = latitude
                        }
                        if let longtude =  result.value(forKey: "longtude") as? Double {
                            annotationlongtude = longtude
                        }
                        
                    }
                }
            } catch {
                print("Hata Var ")
            }
           
            
        }else {
            
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func chooseLocation(gestureRecorganizer : UILongPressGestureRecognizer) {
        if gestureRecorganizer.state == .began {
            let touchedPoint =  gestureRecorganizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameText.text
            annotation.subtitle =   commentText.text
            self.mapView.addAnnotation(annotation)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
               let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
               let region = MKCoordinateRegion(center: location, span: span)
               mapView.setRegion(region, animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subtitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longtude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do {
            try  context.save()
            print("Success")
        } catch {
            print("Hata Oldu")
        }
        
       
        
        
        
    }
    
}

