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
    @IBOutlet weak var spaceLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var location: CLLocationCoordinate2D?
    
    var vm: EventDetailViewModel?
    
    func setUp(vm: EventDetailViewModel) {
        self.vm = vm
        locationNameLabel.text = vm.event.city
        descriptionLabel.text = vm.event.description
        
        timeLabel.text = Utils.timeFormatter.string(from: vm.event.date)
        if let endDate = vm.event.endDate {
            if Calendar.current.isDate(vm.event.date, inSameDayAs: endDate) {
                timeLabel.text = "\(Utils.timeFormatter.string(from: vm.event.date)) - \(Utils.timeFormatter.string(from: endDate))"
            }
        }

        dateLabel.text = Utils.dateFormatter.string(from: vm.event.date)
        typeLabel.text = vm.event.eventSubType
        spaceLabel.text = vm.event.eventType
        priceLabel.text = vm.event.visibility
        
        
        let address = "\(vm.event.street), \(vm.event.postCode), \(vm.event.city), \(vm.event.country)"

        self.mapView.alpha = 0.5
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                self.location = CLLocationCoordinate2DMake(placemark.location?.coordinate.latitude ?? 0, placemark.location?.coordinate.longitude ?? 0)
                if let location = self.location {
                    let region = MKCoordinateRegion(center: location, span: MKCoordinateSpanMake(0.05, 0.05))
                    self.mapView.setRegion(region, animated: true)
                    self.addPins()
                    self.mapView.alpha = 1.0
                }
            }
            else {
                print(error?.localizedDescription)
            }
        })
        
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    var selectedItem: Member?
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.showMapDirections()
    }
    
    @IBAction func tapLocation(_ sender: Any) {
        self.showMapDirections()
    }
    
    func showMapDirections() {
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
            CNPostalAddressCityKey : self.vm?.event.city,
            CNPostalAddressCountryKey : self.vm?.event.country,
            CNPostalAddressPostalCodeKey : self.vm?.event.postCode,
            CNPostalAddressLocalizedPropertyNameAttribute : self.vm?.event.street
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
