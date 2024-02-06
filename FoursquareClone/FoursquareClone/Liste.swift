//
//  tableView.swift
//  FoursquareClone
//
//  Created by Mehmet Emin Fırıncı on 5.02.2024.
//

import UIKit
import Firebase
class Liste: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    var namearray = [String]()
    var typearray = [String]()
    var atmosarray = [String]()
    var imagearray = [String]()
    var latitudearray = [Double]()
    var longitudearray = [Double]()
    
    var secilenname = ""
    var secilentype = ""
    var secilenatmo = ""
    var secilenlati = Double()
    var secilenlong = Double()
    var secilenimage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate=self
        table.dataSource=self
        getDataFromFirebase()
        
        
    }
    @IBAction func logout(_ sender: Any) {
        do{
        try Auth.auth().signOut()
        }catch{
        let alarm = GirisEkrani()
        alarm.alert(mesaj: "Error")
        }
        performSegue(withIdentifier: "main", sender: nil)
    }
    
    @IBAction func addButon(_ sender: Any) {
        
    }
    
    func getDataFromFirebase(){
        let database = Firestore.firestore()
        database.collection("Places").order(by: "name", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                self.alert(mesaj: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    self.namearray.removeAll(keepingCapacity: false)
                    self.typearray.removeAll(keepingCapacity: false)
                    self.atmosarray.removeAll(keepingCapacity: false)
                    self.imagearray.removeAll(keepingCapacity: false)
                    self.latitudearray.removeAll(keepingCapacity: false)
                    self.longitudearray.removeAll(keepingCapacity: false)
                    
                    for documents in snapshot!.documents{
                        if let name = documents.get("name") as? String{
                            self.namearray.append(name)
                        }
                        if let type = documents.get("type") as? String{
                            self.typearray.append(type)
                        }
                        if let atmo = documents.get("atmosphere") as? String{
                            self.atmosarray.append(atmo)
                        }
                        if let image = documents.get("image") as? String{
                            self.imagearray.append(image)
                        }
                        if let lati = documents.get("latitude") as? Double{
                            self.latitudearray.append(lati)
                        }
                        if let long = documents.get("longitude") as? Double{
                            self.longitudearray.append(long)
                        }
                    }
                    self.table.reloadData()
                    }
                }
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namearray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = namearray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenname = namearray[indexPath.row]
        secilentype = typearray[indexPath.row]
        secilenatmo = atmosarray[indexPath.row]
        secilenimage = imagearray[indexPath.row]
        
        secilenlati = latitudearray[indexPath.row]
        secilenlong = longitudearray[indexPath.row]
        
        performSegue(withIdentifier: "goster", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goster"{
            let hedef = segue.destination as! Goster
            hedef.name = secilenname
            hedef.type = secilentype
            hedef.atmo = secilenatmo
            hedef.resim = secilenimage
            
            hedef.latitudegoster = secilenlati
            hedef.longitudegoster = secilenlong
        }
    }

    func alert(mesaj:String){
        let alarm = UIAlertController(title: "ERROR", message: mesaj, preferredStyle: .alert)
        let buton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alarm.addAction(buton)
        present(alarm, animated: true, completion: nil)
    }
   
    
}

