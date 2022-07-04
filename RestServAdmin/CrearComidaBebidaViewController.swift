//
//  CrearComidaBebidaViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 2/07/22.
//

import UIKit
import FirebaseStorage
import AVFoundation
import FirebaseDatabase

class CrearComidaBebidaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    let opciones = ["comidas", "bebidas"]
    var imagenID = NSUUID().uuidString
    var imagePicker = UIImagePickerController()
    
    var pickerView = UIPickerView()
    
    @IBOutlet weak var tipoText: UITextField!
    @IBOutlet weak var imagenImg: UIImageView!
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var precioText: UITextField!
    @IBOutlet weak var tiempoText: UITextField!
    
    @IBAction func fotoTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func guardarTapped(_ sender: Any) {
        
        if (imagenImg.image == nil || tipoText.text == "" || nombreText.text == "" || precioText.text == "" || tiempoText.text == ""){
            let alertaVC = UIAlertController(title: "Campos sin llenar", message: "Por favor llene todos los capos", preferredStyle: .alert)
            let okAccion = UIAlertAction(title: "Atrapar", style: .default, handler: nil)
            alertaVC.addAction(okAccion)
        
            self.present(alertaVC, animated: true, completion: nil)
            return
        }
        
        let imagenesFolder = Storage.storage().reference().child(tipoText.text!)
        let imagenData = imagenImg.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata: nil){
            (metadata, error) in
            if error != nil {
                print("Ocurrio un error al subir imagen: \(String(describing: error))")
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                //self.elegirContactoBoton.isEnabled = true
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un erro al obtener informacion de imagen", accion: "Cancelar")
                        //self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error la subir imagen: \(String(describing: error))")
                        return
                    }
                    //self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                    print("URL",url?.absoluteString ?? "none")
                    if((url) != nil){
                        let snap = ["nombre": self.nombreText.text!, "precio" : Float(self.precioText.text!), "tiempo" : Float(self.tiempoText.text!), "imagen": url?.absoluteString ?? "none", "imagenID" : self.imagenID] as [String : Any]
                        Database.database().reference().child(self.tipoText.text!).childByAutoId().setValue(snap)
                        print(snap)
                    }
                    
                })
                
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagenImg.image = image
        imagenImg.backgroundColor = UIColor.clear
        //guardar.isEnabled = true
        imagePicker.dismiss(animated: true, completion : nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        imagePicker.delegate = self
        tipoText.inputView = pickerView
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CrearComidaBebidaViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return opciones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return opciones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipoText.text = opciones[row]
        tipoText.resignFirstResponder()
    }
}
