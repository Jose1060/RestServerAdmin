//
//  CatBebidasViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 2/07/22.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CatBebidasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var bebidas:[Bebida] = []
    @IBOutlet weak var listBebidas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listBebidas.dataSource = self
        listBebidas.delegate = self
 
         Database.database().reference().child("bebidas").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            print("resultados")
            let bebida = Bebida()
            bebida.ID = snapshot.key
            bebida.Nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            bebida.Precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            bebida.Tiempo = (snapshot.value as! NSDictionary)["tiempo"] as! Double
            bebida.Imagen = (snapshot.value as! NSDictionary)["imagen"] as! String
             bebida.ImagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            self.bebidas.append(bebida)
            self.listBebidas.reloadData()
        })
        Database.database().reference().child("bebidas").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.bebidas{
                if snap.ID == snapshot.key{
                    self.bebidas.remove(at: iterator)
                }
                iterator += 1
            }
            self.listBebidas.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bebidas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell()
        let comida = bebidas[indexPath.row]
        celda.textLabel?.text = comida.Nombre
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let bebida = bebidas[indexPath.row]
            
            Database.database().reference().child("bebidas").child(bebida.ID).removeValue()
            Storage.storage().reference().child("bebidas").child("\(bebida.ImagenID).jpg").delete{
                (error) in
                if (error != nil){
                    print("Error", error)
                }
                print("Se elimino la imagen correctamente")
                
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bebida = bebidas[indexPath.row]
        performSegue(withIdentifier: "segueBebidasVer", sender: bebida)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBebidasVer" {
            let siguienteVC = segue.destination as! BebidasVerViewController
            siguienteVC.bebida = sender as! Bebida
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
