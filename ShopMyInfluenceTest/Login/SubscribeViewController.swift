//
//  SubscribeViewController.swift
//  ShopMyInfluenceTest
//
//  Created by mac on 29/05/2022.
//

import UIKit
import TextFieldEffects
import FirebaseAuth


class SubscribeViewController: UIViewController {

    @IBOutlet weak var emailTF: HoshiTextField!
    @IBOutlet weak var passwordTF: HoshiTextField!
    @IBOutlet weak var subscribeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeBtn.layer.cornerRadius = 5
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func subscribeClick(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            
            let alert = UIAlertController(title: "Alerte", message: "Veuillez remplir les champs !", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {
           [unowned self] error, result in
            
            guard error == nil else {
                let alert = UIAlertController(title: "Alerte", message: "Une erreur est survenue !", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true)
                print(error.debugDescription)
                return
            }
            let alert = UIAlertController(title: "Alerte", message: "Votre compte a été créer avec succès !", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true)
        })
    }
}
