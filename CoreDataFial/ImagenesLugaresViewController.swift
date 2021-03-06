//
//  ImagenesLugaresViewController.swift
//  CoreDataFial
//
//  Created by Max Alva on 2/06/18.
//  Copyright © 2018 Max Alva. All rights reserved.
//

import UIKit
import CoreData

class ImagenesLugaresViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imagenLugar: Lugares!
    var id: Int16!
    var imagen: UIImage!
    var imagenes: [Imagenes] = []
    var refrescar: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var coleccion: UICollectionView!
    
    func conexion() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coleccion.delegate = self
        coleccion.dataSource = self
        
        self.title = imagenLugar.nombre
        id = imagenLugar.id
        let righButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(accionCamara))
        self.navigationItem.rightBarButtonItem = righButton
        
        // estilo para el collectionview
        
        let itemSize = UIScreen.main.bounds.width / 3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        coleccion.collectionViewLayout = layout
        
        llamarImagenes()
        
        // refresh
        //refrescar = UIRefreshControl()
        coleccion.alwaysBounceVertical = true
        refrescar.tintColor = UIColor.green
        refrescar.addTarget(self, action: #selector(recargarDatos), for: .valueChanged)
        coleccion.addSubview(refrescar)
    }
    
    @objc func accionCamara() {
        
        let alerta = UIAlertController(title: "Tomar foto", message: "Cámara/Galería", preferredStyle: .actionSheet)
        
        let accionCamara = UIAlertAction(title: "Tomar fotografía", style: .default) { (action) in
            self.tomarFotografia()
        }
        
        let accionGaleria = UIAlertAction(title: "Entrar a galería", style: .default) { (action) in
            self.entrarGaleria()
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alerta.addAction(accionCamara)
        alerta.addAction(accionGaleria)
        alerta.addAction(accionCancelar)
        
        present(alerta, animated: true, completion: nil)
        
        
    }
    
    func tomarFotografia() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func entrarGaleria() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagenTomada = info[UIImagePickerControllerEditedImage] as? UIImage
        imagen = imagenTomada
        
        let contexto = conexion()
        let entityImagenes = NSEntityDescription.insertNewObject(forEntityName: "Imagenes", into: contexto) as! Imagenes
        
        let uuid = UUID()
        
        entityImagenes.id = uuid
        entityImagenes.id_lugares = id
        let imagenFinal = UIImagePNGRepresentation(imagen) as Data?
        entityImagenes.imagen = imagenFinal
        
        imagenLugar.mutableSetValue(forKey: "imagenes").add(entityImagenes)
        
        do {
            try contexto.save()
            dismiss(animated: true, completion: nil)
            print("Imagenes guardadas")
            //comentado para probar el swipe
            //self.llamarImagenes()
            //self.coleccion.reloadData()
        } catch let error as NSError {
            print("Error", error)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coleccion.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagenCollectionViewCell
        
        let imagen = imagenes[indexPath.row]
        
        if let imagen = imagen.imagen {
            cell.imagen.image = UIImage(data: imagen as Data)
        }
        
        return cell
    }
    
    func llamarImagenes() {
        let contexto = conexion()
        let idLugar = String(id)
        
        let fetchRequest: NSFetchRequest<Imagenes> = Imagenes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_lugares == %@", idLugar)
        
        do {
            imagenes = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error", error)
        }
    }
    
    @objc func recargarDatos() {
        llamarImagenes()
        coleccion.reloadData()
        stop()
    }
    
    func stop() {
        refrescar.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "imagen", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imagen" {
            let id = sender as! NSIndexPath
            let fila = imagenes[id.row]
            let destino = segue.destination as! ImagenVistaViewController
            destino.imagenLugar = fila
        }
    }
    


}
