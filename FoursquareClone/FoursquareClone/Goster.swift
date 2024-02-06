//
//  Goster.swift
//  FoursquareClone
//
//  Created by Mehmet Emin Fırıncı on 5.02.2024.
//

import UIKit
import MapKit
import Kingfisher
class Goster: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var atmospherelabel: UILabel!
    @IBOutlet weak var harita: MKMapView!
    
    var location = CLLocationManager()
    
    var name=""
    var type=""
    var atmo=""
    var latitudegoster = Double()
    var longitudegoster = Double()
    var resim=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text=name
        typelabel.text=type
        atmospherelabel.text=atmo
        image.kf.setImage(with: URL(string: self.resim))
        
        harita.delegate=self
        location.delegate=self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        
        let coordinate = CLLocationCoordinate2D(latitude: latitudegoster , longitude: longitudegoster)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        harita.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        annotation.subtitle = type
        self.harita.addAnnotation(annotation)
        
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if pinView == nil{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.canShowCallout = true
                let button = UIButton(type: UIButton.ButtonType.detailDisclosure) // bilgi butonu
                pinView?.rightCalloutAccessoryView = button
            }else{
                pinView?.annotation = annotation
            }
            return pinView
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { // bilgi butonu tıklanırsa
        if latitudegoster != 0.0 && longitudegoster != 0.0{
            var clLocation = CLLocation(latitude: latitudegoster, longitude: longitudegoster)
            CLGeocoder().reverseGeocodeLocation(clLocation, preferredLocale: nil) { placemarks, error in
                if error != nil{
                    self.alert(mesaj: error?.localizedDescription ?? "error")
                }else{
                    if let placemark = placemarks{
                        if placemark.count > 0{
                            let newPlacemark = MKPlacemark(placemark: placemark[0])
                            let item = MKMapItem(placemark: newPlacemark)
                            item.name = self.name
                            let launceOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                            item.openInMaps(launchOptions: launceOptions)
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

    


