//
//  ViewController.swift
//  TermProject-1991336-CYR
//
//  Created by Yerin Choo on 2022/06/11.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    
    var userId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
            guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
                    // 화면 전환 애니메이션 설정
                    secondViewController.modalTransitionStyle = .coverVertical
                    // 전환된 화면이 보여지는 방법 설정 (fullScreen)
                    secondViewController.modalPresentationStyle = .fullScreen
                    self.present(secondViewController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func onLoginButtonTouched(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PWTextField.text!) { [weak self] authResult, error in
            guard self != nil else { return }
            // ...
            if authResult != nil {
                print("Login Success")
                self?.userId = authResult!.user.uid
            } else {
                print("Login Failed", error?.localizedDescription ?? "")
                print(error)
            }
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
    
}

