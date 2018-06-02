//
//  MapaFullViewController.swift
//  CoreDataFial
//
//  Created by Max Alva on 2/06/18.
//  Copyright © 2018 Max Alva. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapaFullViewController: UIViewController {
    
    @IBOutlet weak var mapa: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let anotacion = traerCoordenadas() {
            mapa.addAnnotations(anotacion)
        }

    }
    
    func traerCoordenadas() -> [MKAnnotation]? {
        
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Lugares> = Lugares.fetchRequest()
        
        do {
            let localizaciones = try contexto.fetch(fetchRequest)
            var anotacion = [MKAnnotation]()
            
            for item in localizaciones {
                let nuevaAnotacion = MKPointAnnotation()
                nuevaAnotacion.coordinate.latitude = item.latitud
                nuevaAnotacion.coordinate.longitude = item.longitud
                nuevaAnotacion.title = item.nombre
                nuevaAnotacion.subtitle = item.descripcion
                
                anotacion.append(nuevaAnotacion)
            }
            
            return anotacion
        } catch let error as NSError  {
    
            print("Error", error)
        }
        
        return nil
    }



}
