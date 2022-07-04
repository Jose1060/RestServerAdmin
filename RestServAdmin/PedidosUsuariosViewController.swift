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
        return pedidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = pedidos[indexPath.row]
        return cell
    }
    
    
    var cliente = ""
    var pedidos:[String] = []
    
    @IBOutlet weak var listaPedidos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaPedidos.dataSource = self
        listaPedidos.delegate = self
        
        let a = Database.database().reference().child("clientes").child(cliente).child("pedidos").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot.key)
            print("resultados")
            let pedidos = (snapshot.value as! NSDictionary)["nombre"] as! String
            self.pedidos.append(pedidos)
            self.listaPedidos.reloadData()
            })
        print(a)
        // Do any additional setup after loading the view.
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
