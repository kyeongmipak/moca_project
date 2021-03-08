//
//  MapViewController.swift
//  Moca
//
//  Created by 김대환 on 2021/03/06.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapLocationModelProtocol, CLLocationManagerDelegate {

    @IBOutlet var myMapView: MKMapView!
    
    var feedItems: NSArray = NSArray()
    var locatinos: [Locations] = []
    var brandName = ""
    
    var mylatitude : CLLocationDegrees = 0.0
    var mylongitude : CLLocationDegrees = 0.0
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let jsonModel = MapLocationModel()
        jsonModel.delegate = self
        jsonModel.downloadItems(brandName: brandName)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest       // 정확도를 최고로 설정
        
        locationManager.requestWhenInUseAuthorization()                 // 위치 데이터를 확인하기 위해 요청
        locationManager.startUpdatingLocation()                         // 위치 업데이트 시작
        
        myMapView.showsUserLocation = true
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            let region = CLCircularRegion(center: userLocation, radius: 5000, identifier: "geofence")
            myMapView.addOverlay(MKCircle(center: userLocation, radius: 500))
            myMapView.setRegion(viewRegion, animated: false)
        }

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }

    
    func itemDownloaded(items: NSArray) {
        feedItems = items
        locatinos = feedItems as! [Locations]
        
        let coor = locationManager.location?.coordinate
        
        let mycoordinate = CLLocation(latitude: mylatitude, longitude: mylongitude)
        
        let cordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mylatitude, mylongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: cordinate, span: span)
        
        self.myMapView.setRegion(region, animated: true)
        
        for i in 0..<locatinos.count{
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            dismiss(animated: true, completion: nil)
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = self.locatinos[i].cafeAddress
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start {
                (response, error) in
                
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if response == nil {
                    print("Error")
                } else{
                    
    //                let annotations = self.myMapView.annotations
    //                self.myMapView.removeAnnotation(annotations as! MKAnnotation)
                    
                    let latitude = response!.boundingRegion.center.latitude
                    let longitute = response!.boundingRegion.center.longitude
                    
                    
                    let coordinate = CLLocation(latitude: latitude, longitude: longitute)
                    
                    let distance = self.distanceCalculate(mycoordinate: mycoordinate, coordinate: coordinate)
                    
                    
                    
                    if distance < 500 {
                        let annotation = MKPointAnnotation()
                        annotation.title = self.locatinos[i].cafeNames
                        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitute)
                        self.myMapView.addAnnotation(annotation)
                        
                        
                    }
                    
                    
                }
            }
        }
        
    }
    
    func distanceCalculate(mycoordinate : CLLocation, coordinate : CLLocation) -> Double{
        let distanceInmeters = mycoordinate.distance(from: coordinate)
        return distanceInmeters
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        mylatitude = (pLocation?.coordinate.latitude)!
        mylongitude = (pLocation?.coordinate.longitude)!
    }
}

extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.white
            circleRenderer.lineWidth = 2.0
            circleRenderer.strokeColor = .blue
            circleRenderer.alpha = 0.5
        }
        return circleRenderer
    }
}
