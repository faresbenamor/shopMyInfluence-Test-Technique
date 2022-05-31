//
//  ViewController.swift
//  ShopMyInfluenceTest
//
//  Created by mac on 29/05/2022.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTF: HoshiTextField!
    @IBOutlet weak var passwordTF: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 5
        hideKeyboardWhenTappedAround()
    }

    @IBAction func loginBtnClick(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {

            let alert = UIAlertController(title: "Alerte", message: "Veuillez remplir les champs !", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }

        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {
            result, error in

            guard error == nil else {
                print("error")
                return
            }
            self.performSegue(withIdentifier: "toHome", sender: self)
        })
    }
    
    @IBAction func subscribeClick(_ sender: UIButton) {
        performSegue(withIdentifier: "toSubscribe", sender: self)
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
