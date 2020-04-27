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
    var annotationLatitude : Double = 0.0
    var annotationlongtude : Double = 0.0
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
            fetchRequest.predicate = NSPredicate(format: "id= %@", stringUUID)
            
            do {
                 let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title =  result.value(forKey: "title") as? String {
                            annotationTitle = title
                            if let subtitle =  result.value(forKey: "subtitle") as? String {
                                annotationSubTitle = subtitle
                                if let latitude =  result.value(forKey: "latitude") as? Double {
                                    annotationLatitude = latitude
                                    if let longtude =  result.value(forKey: "longtude") as? Double {
                                        annotationlongtude = longtude
                                        
                                        let annotation = MKPointAnnotation()
                                        annotation.title = annotationTitle
                                        annotation.subtitle = annotationSubTitle
                                        
                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationlongtude)
                                        annotation.coordinate = coordinate
                                        mapView.addAnnotation(annotation)
                                        nameText.text = annotationTitle
                                        commentText.text   = annotationSubTitle
                                        
                                        locationManager.stopUpdatingLocation()
                                        
                                        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        let region =    MKCoordinateRegion(center: coordinate, span: span)
                                        mapView.setRegion(region, animated: true)
                                    }
                                }
                            }
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
        if selectedTitle == "" {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
               let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
               let region = MKCoordinateRegion(center: location, span: span)
               mapView.setRegion(region, animated: true)
        } else {
            //
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "myAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.green
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if selectedTitle != "" {
            let newLocation = CLLocation(latitude: annotationLatitude, longitude: annotationlongtude)
            CLGeocoder().reverseGeocodeLocation(newLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlaceMarks = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlaceMarks)
                        item.name = self.annotationTitle
                        let launcOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launcOptions)
                        
                    }
               
                }
            }
        }
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
        
        NotificationCenter.default.post(name: NSNotification.Name("yeniHarita"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
}

