//
//  ComidaVerViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 3/07/22.
//

import UIKit
import SDWebImage

class ComidaVerViewController: UIViewController {
    var comida = Comida()
    
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var precioText: UITextField!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var tiempoText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreText.text = comida.Nombre
        precioText.text = String(comida.Precio)
        tiempoText.text = String(comida.Tiempo)
        imagenView.sd_setImage(with: URL(string: comida.Imagen), completed : nil)
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
