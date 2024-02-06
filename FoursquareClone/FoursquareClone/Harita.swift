//
//  Harita.swift
//  FoursquareClone
//
//  Created by Mehmet Emin Fırıncı on 5.02.2024.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage
class Harita: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapKit: MKMapView!
    var locationManager = CLLocationManager()
    
    
    let name = PlaceModel.sharedInstance.placename
    let type = PlaceModel.sharedInstance.placetype
    let atmosphere = PlaceModel.sharedInstance.placeatmosphere
    let image = PlaceModel.sharedInstance.placeimage
    var latitude = PlaceModel.sharedInstance.latitude
    var longitude = PlaceModel.sharedInstance.longitude
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // konum doğruluğu
        locationManager.requestWhenInUseAuthorization() // sadece kullanırken kullanması ayarı
        locationManager.startUpdatingLocation() // konumu almayı başlat
    
        let pinkoy = UILongPressGestureRecognizer(target: self, action: #selector(lokasyonSec(gestureRecognizer:)))
        pinkoy.minimumPressDuration = 3
        mapKit.addGestureRecognizer(pinkoy)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003) // haritanın zoom değerini belirliyor
        let region = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
    }
    
    @objc func lokasyonSec(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{// eğer tıklandıysa
            let touches = gestureRecognizer.location(in: self.mapKit)
            let coordinates = self.mapKit.convert(touches, toCoordinateFrom: self.mapKit)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placename
            annotation.subtitle = PlaceModel.sharedInstance.placetype
            
            self.mapKit.addAnnotation(annotation)
            self.latitude = coordinates.latitude
            self.longitude = coordinates.longitude
        }
    }
    
    @IBAction func saveButon(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let folder = storageRef.child("Places Image")
        let data = image.jpegData(compressionQuality: 0.5)
        let uuid = UUID().uuidString
        let child = folder.child(uuid)
        child.putData(data!, metadata: nil) { metadata, error in
            if error != nil{
                self.alert(mesaj: error?.localizedDescription ?? "error")
            }else{
                child.downloadURL { url, error in
                    if error == nil{
                        let imageurl = url?.absoluteString
                        
                        let database = Firestore.firestore()
                        var databaseCollection : DocumentReference? = nil
                        let saved = ["name" : self.name, "type" : self.type, "atmosphere" : self.atmosphere, "image" : imageurl!, "latitude" : self.latitude, "longitude" : self.longitude] as! [String : Any]
                        databaseCollection = database.collection("Places").addDocument(data: saved){ error in
                            if error != nil{
                                self.alert(mesaj: error?.localizedDescription ?? "error")
                            }else{
                                
                                self.performSegue(withIdentifier: "don", sender: nil)
                                }
                            }
                    }
                }
            }
        }
     
        
       
        }
  
    
    
    func alert(mesaj:String){
        let alarm = UIAlertController(title: "ERROR", message: mesaj, preferredStyle: .alert)
        let buton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alarm.addAction(buton)
        present(alarm, animated: true, completion: nil)
    }

}
