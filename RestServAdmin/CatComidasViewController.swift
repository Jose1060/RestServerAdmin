//
//  CatComidasViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 2/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CatComidasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var comidas:[Comida] = []

    @IBOutlet weak var listaComidas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaComidas.dataSource = self
        listaComidas.delegate = self
 
         Database.database().reference().child("comidas").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            print("resultados")
            let comida = Comida()
            comida.ID = snapshot.key
            comida.Nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            comida.Precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            comida.Tiempo = (snapshot.value as! NSDictionary)["tiempo"] as! Double
            comida.Imagen = (snapshot.value as! NSDictionary)["imagen"] as! String
             comida.ImagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            self.comidas.append(comida)
            self.listaComidas.reloadData()
        })
        Database.database().reference().child("comidas").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.comidas{
                if snap.ID == snapshot.key{
                    self.comidas.remove(at: iterator)
                }
                iterator += 1
            }
            self.listaComidas.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comidas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell()
        let comida = comidas[indexPath.row]
        celda.textLabel?.text = comida.Nombre
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let comida = comidas[indexPath.row]
            
            Database.database().reference().child("comidas").child(comida.ID).removeValue()
            Storage.storage().reference().child("comidas").child("\(comida.ImagenID).jpg").delete{
                (error) in
                print("Se elimino la imagen correctamente")
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comida = comidas[indexPath.row]
        performSegue(withIdentifier: "segueComidaVer", sender: comida)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueComidaVer" {
            let siguienteVC = segue.destination as! ComidaVerViewController
            siguienteVC.comida = sender as! Comida
        }
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
