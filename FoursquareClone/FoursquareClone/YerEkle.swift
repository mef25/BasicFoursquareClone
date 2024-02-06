//
//  YerEkle.swift
//  FoursquareClone
//
//  Created by Mehmet Emin Fırıncı on 5.02.2024.
//

import UIKit

class YerEkle: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var atmosphere: UITextField!
    @IBOutlet weak var resim: UIImageView!
    @IBOutlet var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled=false
        resim.isUserInteractionEnabled=true
        let tiklama = UITapGestureRecognizer(target: self, action: #selector(galeriAc))
        resim.addGestureRecognizer(tiklama)
        
        let klavyekapat = UITapGestureRecognizer(target: self, action: #selector(klavyegizle))
        view.addGestureRecognizer(klavyekapat)
    }
    
    @IBAction func nextButon(_ sender: Any) {
        if name.text != "" && type.text != "" && atmosphere.text != ""{
            if let secilenResim = resim.image{
                PlaceModel.sharedInstance.placename = name.text!
                PlaceModel.sharedInstance.placetype = type.text!
                PlaceModel.sharedInstance.placeatmosphere = atmosphere.text!
                PlaceModel.sharedInstance.placeimage = secilenResim
            }
            performSegue(withIdentifier: "haritaac", sender: nil)
        }else{
            self.alert(mesaj: "Error")
        }
        
    }
    
    @objc func galeriAc(){
        let picker = UIImagePickerController()
        picker.delegate=self
        picker.sourceType = .photoLibrary
        picker.allowsEditing=false
        present(picker, animated: true, completion: nil)
    }
    @objc func klavyegizle(){
        view.endEditing(true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        resim.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        nextButton.isEnabled=true
    }
    
    func alert(mesaj:String){
        let alarm = UIAlertController(title: "ERROR", message: mesaj, preferredStyle: .alert)
        let buton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alarm.addAction(buton)
        present(alarm, animated: true, completion: nil)
    }
   
}
