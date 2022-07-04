//
//  LoginGoogleViewController.swift
//  RestServAdmin
//
//  Created by Mac 01 on 3/07/22.
//

import UIKit

import FirebaseAuth
import GoogleSignIn

extension IniciarSesionViewController: GIDSignInDelegate  {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error{
                print("Error because \(error.localizedDescription)")
                return
            }
            
            guard let auth = user.authentication else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credentials){ (authResult, error) in
                if let error = error{
                    print("Error because \(error.localizedDescription)")
                    return
                }
            }
        if Auth.auth().currentUser != nil{
            print("Inicio de sesion exitosa")
            self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
        }else{
            print("No hay usuario")
        }
        
        }
    
    
}
