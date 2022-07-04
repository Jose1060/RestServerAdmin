//
//  IniciarSesionViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 3/07/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
class IniciarSesionViewController: UIViewController {
   
    @IBOutlet weak var usuarioText: UITextField!
    @IBOutlet weak var claveText: UITextField!
    
    
    //MARK: - Actions
    @IBAction func ingresarTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: usuarioText.text!, password: claveText.text!){
            (user, error) in
            print("Intentando iniciar sesion")
            if error != nil{
                print("Se presento el siguiente error: \(String(describing: error) )")
                let alerta = UIAlertController(title: "Usuario no existe", message: "\(String(describing: error))", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Crear Usuario", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "registerSegue", sender: nil)})
                
                let btnCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                alerta.addAction(btnCancelar)
                alerta.addAction(btnOK)
                
                self.present(alerta, animated: true, completion: nil)
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }
            
        }
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    //MARK: - Funcion Google
    private func setupGoogle(){
            GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            print("Inicio de sesion exitosa")
            self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
        }else{
            print("No hay usuario")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogle()
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

