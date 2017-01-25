//
//  ViewController.swift
//  Filtros
//
//  Created by cice on 25/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var intensidad: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagenActual: UIImage!
    var context: CIContext!
    var filtroActual: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importarImagen))
        
        context = CIContext() //Mejor crear uno y utilizarlo durante toda la aplicacion, crear varios context consume muchos recursos
        filtroActual = CIFilter(name: "CISepiaTone")
    }
    
    func importarImagen() {
    
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return} //Asegurarse de que coge una imagen, si no sale
        dismiss(animated: true)
        imagenActual = image //Para hacer los cambios a una copia y no en la original
        
        //Los filtros son como diccionarios, con las claves(Key) le indicas los valores
        let imagenInicial = CIImage(image: imagenActual)//Creamos un objeto de tipo CIImage, lo necesitamos para utilizar core image
        filtroActual.setValue(imagenInicial, forKey: kCIInputImageKey)//Le estamos dando un valor[imagen a utilizar, y un forkey(le indica al contexto como aplicar el filtro que le estamos dando(ES EL INPUT DE IMAGEN))]
        aplicarProcesamiento()
    }
    
    func aplicarProcesamiento(){
        let inputKeys = filtroActual.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            filtroActual.setValue(intensidad.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            filtroActual.setValue(intensidad.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            filtroActual.setValue(intensidad.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            filtroActual.setValue(CIVector(x: imagenActual.size.width / 2, y: imagenActual.size.height / 2), forKey: kCIInputCenterKey)
        }
       // filtroActual.setValue(intensidad.value, forKey: kCIInputIntensityKey)//Este forkey especifica la intensidad de un valor
        if let cgimg = context.createCGImage(filtroActual.outputImage!, from: filtroActual.outputImage!.extent){//If let para comprobar que nuestro contexto tiene una imagen
        
            let imagenProcesada = UIImage(cgImage: cgimg)
            imageView.image = imagenProcesada
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cambiarFiltro(_ sender: AnyObject) {
        
        let ac = UIAlertController(title: "Elige tu filtro", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: establecerFiltro))
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(ac, animated: true)
    }
    
    func establecerFiltro(action:UIAlertAction){
    
        guard imagenActual != nil else {return} // Es igual con un if imagenactual!= nill o if let
        filtroActual = CIFilter(name: action.title!)
        
        let imagenInicial = CIImage(image: imagenActual)
        filtroActual.setValue(imagenInicial, forKey: kCIInputImageKey)
        aplicarProcesamiento()
    
    }

    @IBAction func guardar(_ sender: AnyObject) {

        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image), nil)
        
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfor: UnsafeRawPointer){
    
        if let error = error {
            let ac = UIAlertController(title: "Error al guardar", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present (ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Imagen Guardada", message: "Tu imagen modificada ha sido guardada con éxito", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present (ac, animated: true)
        }
    
    }
    
    
    @IBAction func cambiarIntensidad(_ sender: AnyObject) {
        aplicarProcesamiento()
        
        
        
    }
    
    
}

