//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Mehmet Emin Fırıncı on 31.01.2024.
//

import UIKit
import Firebase
class GirisEkrani: UIViewController {
    @IBOutlet weak var buton: UIButton!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var sifre: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sifre.isSecureTextEntry=true
        let klavyekapat = UITapGestureRecognizer(target: self, action: #selector(klavyegizle))
        view.addGestureRecognizer(klavyekapat)
    }
    
    @IBAction func giris(_ sender: Any) {
        if mail.text != "" && sifre.text != "" {
            Auth.auth().signIn(withEmail: mail.text!, password: sifre.text!) { data, error in
                if error != nil{
                    self.alert(mesaj: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "pencere2", sender: nil)
                }
            }
        }else{
            self.alert(mesaj: "Username/Password is wrong")
        }
        
        
    }
    @objc func klavyegizle(){
        view.endEditing(true)
    }
    
    @IBAction func kayitOl(_ sender: Any) {
        if mail.text != "" && sifre.text != ""{
            Auth.auth().createUser(withEmail: mail.text!, password: sifre.text!) { data, error in
                if error != nil {
                    self.alert(mesaj: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "pencere2", sender: nil)
                }
            }
        }else{
            self.alert(mesaj: "Username/Password is wrong")
        }
        
        
    }
 
    @IBAction func eye(_ sender: Any) {
        if sifre.isSecureTextEntry == true{
            sifre.isSecureTextEntry = false
        }else{
            sifre.isSecureTextEntry = true
        }
    }
    
    
    
    func alert(mesaj:String){
        let alarm = UIAlertController(title: "ERROR", message: mesaj, preferredStyle: .alert)
        let buton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alarm.addAction(buton)
        present(alarm, animated: true, completion: nil)
    }

}

