//
//  UIViewController.swift
//  Parked
//
//  Created by Mihaela Miches on 1/18/17.
//  Copyright © 2017 me. All rights reserved.
//

import MapKit

extension UIViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation)  { return nil }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.pinTintColor = .orange
        pinView.canShowCallout = true
        
        return pinView
    }
}
