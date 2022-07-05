//
//  ListaClientesViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 3/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ListaClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clientes:[Cliente] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if(clientes.count == 0){
            cell.textLabel?.text = "No hay pedidos :c"
            return cell
        }
        
        cell.textLabel?.text = clientes[indexPath.row].ID
        
        return cell
    }
    

    @IBOutlet weak var listaClientes: UITableView!
    
    
    @IBAction func salirTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            dismiss(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listaClientes.dataSource = self
        listaClientes.delegate = self
        
        Database.database().reference().child("clientes").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot.key)
            print("resultados")
            let cliente = Cliente()
            cliente.ID = snapshot.key
            self.clientes.append(cliente)
            self.listaClientes.reloadData()
            })
        
        Database.database().reference().child("clientes").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.clientes{
                if snap.ID == snapshot.key{
                    self.clientes.remove(at: iterator)
                }
                iterator += 1
            }
            self.listaClientes.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cliente = clientes[indexPath.row].ID
        
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
