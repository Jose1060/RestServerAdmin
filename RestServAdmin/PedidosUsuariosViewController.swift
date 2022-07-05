//
//  PedidosUsuariosViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 2/07/22.
//

import UIKit
import FirebaseDatabase

class PedidosUsuariosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (pedidos.count == 0){
            return 1
        }else{
            return pedidos.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pedidoCelda", for: indexPath)
        print(pedidos.count, "-------------------")
        
        if (pedidos.count == 0){
            cell.textLabel?.text = "No hay pedido 🥲"
            return cell
        }else{
            
            let pedido = pedidos[indexPath.row]
            cell.textLabel?.text = pedido.Nombre
            cell.detailTextLabel?.text = "S/. " + String(pedido.Precio)
            
            return cell
        }

    }
    
    
    var cliente = ""
    var pedidos:[Pedido] = []
    
    @IBOutlet weak var listaPedidos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaPedidos.dataSource = self
        listaPedidos.delegate = self
        
         Database.database().reference().child("clientes").child(cliente).child("pedidos").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot.key)
            print("resultados", snapshot)
            let pedido = Pedido()
             pedido.ID = snapshot.key
             pedido.Precio = (snapshot.value as! NSDictionary)["precio"] as! Double
             pedido.Tiempo = (snapshot.value as! NSDictionary)["tiempo"] as! Double
             pedido.Nombre = (snapshot.value as! NSDictionary)["nombre"] as! String
            self.pedidos.append(pedido)
            self.listaPedidos.reloadData()
            })
        
        Database.database().reference().child("clientes").child(cliente).child("pedidos").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.pedidos{
                if snap.ID == snapshot.key{
                    self.pedidos.remove(at: iterator)
                }
                iterator += 1
            }
            self.listaPedidos.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let pedido = pedidos[indexPath.row]
            
            Database.database().reference().child("clientes").child(cliente).child("pedidos").child(pedido.ID).removeValue()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
