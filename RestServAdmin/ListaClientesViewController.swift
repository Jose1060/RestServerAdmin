//
//  ListaClientesViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 3/07/22.
//

import UIKit
import FirebaseDatabase

class ListaClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clientes:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = clientes[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var listaClientes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listaClientes.dataSource = self
        listaClientes.delegate = self
        
        let a = Database.database().reference().child("clientes").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot.key)
            print("resultados")
            self.clientes.append(snapshot.key)
            self.listaClientes.reloadData()
            })
        print(a)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cliente = clientes[indexPath.row]
        performSegue(withIdentifier: "segueClientePedidos", sender: cliente)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueClientePedidos" {
            let siguienteVC = segue.destination as! PedidosUsuariosViewController
            siguienteVC.cliente = sender as! String
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
