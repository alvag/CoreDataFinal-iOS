//
//  MapaViewController.swift
//  CoreDataFial
//
//  Created by Max Alva on 2/06/18.
//  Copyright © 2018 Max Alva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController, CLLocationManagerDelegate {
    
    var coordLugares: Lugares!
    var manager = CLLocationManager()
    var latitudMapa : CLLocationDegrees!
    var longitudMapa: CLLocationDegrees!
    @IBOutlet weak var mapa: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        latitudMapa = coordLugares.latitud
        longitudMapa = coordLugares.longitud
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacion = CLLocationCoordinate2DMake(latitudMapa, longitudMapa)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(localizacion, span)
        self.mapa.setRegion(region, animated: true)
        
        let anotacion = MKPointAnnotation()
        anotacion.coordinate = (localizacion)
        anotacion.title = coordLugares.nombre
        anotacion.subtitle = coordLugares.descripcion
        mapa.addAnnotation(anotacion)
        mapa.selectAnnotation(anotacion, animated: true)
    }


}
