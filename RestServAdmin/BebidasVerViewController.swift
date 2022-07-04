//
//  BebidasVerViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 3/07/22.
//

import UIKit
import SDWebImage

class BebidasVerViewController: UIViewController {
    var bebida = Bebida()
    
    
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var precioText: UITextField!
    @IBOutlet weak var TiempoText: UITextField!
    @IBOutlet weak var imagenView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreText.text = bebida.Nombre
        precioText.text = String(bebida.Precio)
        TiempoText.text = String(bebida.Tiempo)
        imagenView.sd_setImage(with: URL(string: bebida.Imagen), completed : nil)
    }
    

    

}
