//
//  JobDetailCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import Contacts


class EventDetailCell: UICollectionViewCell, MKMapViewDelegate {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var location: CLLocationCoordinate2D?
    
    func setUp(vm: EventDetailViewModel) {

        locationNameLabel.text = vm.event.locationName
        descriptionLabel.text = vm.event.description
        timeLabel.text = "5pm - 7pm" // todo:
        dateLabel.text = "24th May" // todo:
        priceLabel.text = "Free"
        
        
        self.location = CLLocationCoordinate2D(latitude: 51.5074, longitude: 0.1278)
        if let location = self.location {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(0.05, 0.05))
            mapView.setRegion(region, animated: true)
            addPins()
        }

    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    var selectedItem: Member?
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("did select")
        guard let location = self.location else { return }
        
//        let addressDict = [
//            CNPostalAddressStreetKey : "Rambla Prim 1-17",
//            CNPostalAddressCityKey : "Barcelona",
//            CNPostalAddressPostalCodeKey : "08019",
//            CNPostalAddressCountryKey : "Spain",
//            CNPostalAddressISOCountryCodeKey : "es",
//            CNPostalAddressLocalizedPropertyNameAttribute: "Centre de Convencions Internacional de Barcelona",
//            ]

        let addressDict = [
            CNPostalAddressCityKey : "London",
            CNPostalAddressCountryKey : "UK",
            CNPostalAddressISOCountryCodeKey : "uk"
            ]

        
        let placeMark = MKPlacemark(coordinate: location, addressDictionary: addressDict)
        
        
        //        https://maps.apple.com/?address=Rambla Prim 1-17, 08019 Barcelona B, Spain&auid=3539465272521020608&ll=41.410013,2.219335&lsp=9902&q=Centre de Convencions Internacional de Barcelona&t=m
        
        
        let mapItem = MKMapItem(placemark: placeMark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = false
        }
        else {
            annotationView!.annotation = annotation
        }

        let image = UIImage(named: "mapPin")!
        annotationView!.image = image
//        annotationView?.layer.cornerRadius = 50
//        annotationView?.layer.borderWidth = 1
//        annotationView?.layer.borderColor = UIColor(hexString: "C5C5C5").cgColor
//        annotationView?.clipsToBounds = true
//        annotationView?.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    
    func addPins() {
//        let location = self.location // CLLocationCoordinate2D(latitude: CLLocationDegrees(latRange), longitude: CLLocationDegrees(longRange))

        if let location = self.location {
            let pin = MKPointAnnotation()
            pin.coordinate = location
            pin.title = ""
            mapView.addAnnotation(pin)
        }
        
        
    }
    
}
