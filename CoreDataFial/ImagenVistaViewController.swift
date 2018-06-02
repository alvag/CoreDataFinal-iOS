//
//  ImagenVistaViewController.swift
//  CoreDataFial
//
//  Created by Max Alva on 2/06/18.
//  Copyright © 2018 Max Alva. All rights reserved.
//

import UIKit

class ImagenVistaViewController: UIViewController {
    
    @IBOutlet weak var imagen: UIImageView!
    var imagenLugar: Imagenes!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagen.image = UIImage(data: imagenLugar.imagen! as Data)

    }
    
    @IBAction func eliminar(_ sender: UIButton) {
    }
    

}
