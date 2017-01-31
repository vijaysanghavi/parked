//
//  LogViewController.swift
//  Parked
//
//  Created by Mihaela Miches on 1/15/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit
import MapKit


class LogViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var visits: [Visit] = []
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        closeButton.isHidden = true
        
        Location.shared.findCar(allTheThings: true) { locations, kind in
            self.visits = locations
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.showAnnotations(visits, animated: true)
    }
}
