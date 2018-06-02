//
//  ImagenesLugaresViewController.swift
//  CoreDataFial
//
//  Created by Max Alva on 2/06/18.
//  Copyright © 2018 Max Alva. All rights reserved.
//

import UIKit

class ImagenesLugaresViewController: UIViewController {
    
    var imagenLugar: Lugares!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = imagenLugar.nombre
        
        let righButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(accionCamara))
        self.navigationItem.rightBarButtonItem = righButton
    }
    
    @objc func accionCamara() {
        print("Abrir camara")
    }

    


}
