//
//  ViewController.swift
//  Parked
//
//  Created by Mihaela Miches on 1/5/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findButton: UIButton!
    
    var state: ResponseKind?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Location.shared.delegate = self
        Location.shared.start()
        activityIndicator.stopAnimating()
        
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: mapView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchCar()
    }
    
    func startSearch() {
        mapView.removeAnnotations(mapView.annotations)
        imageView.tintColor = findButton.tintColor
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 1) {
            self.imageView.isHidden = false
            self.label.text = ""
        }
    }
    
    //MARK:-
    func reStack(kind: ResponseKind) {
        imageView.isHidden = true
        imageView.image = nil
        mapView.isHidden = false
        activityIndicator.stopAnimating()
        findButton.isHidden = false
        findButton.setImage(#imageLiteral(resourceName: "gps"), for: .normal)
        
        state = kind
        
        switch kind {
        case .needsPermissions:
            self.imageView.tintColor = .lightGray
            self.imageView.isHidden = false
            self.imageView.image = #imageLiteral(resourceName: "gps")
            self.findButton.setImage(#imageLiteral(resourceName: "unlocked"), for: .normal)
            self.label.text = "Accuracy requires location services and access to motion activity\n\n Your data is intended for your own use and should not be viewed by anyone|\n\n Battery life matters\n\n Tap to allow access"// Kind reminder https://littlebitesofcocoa.com/192-being-a-good-low-power-mode-citizen
        case .locationDisabled:
            self.imageView.image = #imageLiteral(resourceName: "forbidden")
            self.imageView.isHidden = false
            self.label.text = "Location services are disabled\nPlease enable in Settings"
            self.findButton.setImage(#imageLiteral(resourceName: "unlocked"), for: .normal)
        case .noMotionData:
            self.imageView.image = #imageLiteral(resourceName: "forbidden")
            self.imageView.isHidden = false
            self.label.text = "Motion & Fitness is unavailable\nPlease enable in Settings"
            self.findButton.setImage(#imageLiteral(resourceName: "unlocked"), for: .normal)
        case .notFound:
            self.label.text = "🤔"
        case .noLocationData:
            self.label.text = "all set! \n\n go live a little, have fun, and do visit when you need to know where you parked"
        case .manyFound:
            self.label.text = "💯 error"
        case .found:
            self.label.text = "parked here"
        case .driving:
            self.label.text = "please don't use your phone while driving"
            self.findButton.setImage(#imageLiteral(resourceName: "transport"), for: .normal)
        }
        
    }
    
    //MARK:-
    func reStackAnimated(stackKind: ResponseKind) {
        OperationQueue.main.addOperation {
            UIView.animate(withDuration: 0.3) {
                self.reStack(kind: stackKind)
            }
        }
    }
    
    func updateMapAnnotationsAnimated(annotations: [MKAnnotation]) {
        OperationQueue.main.addOperation {
            self.mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    //MARK:-
    func searchCar() {
        startSearch()
        Location.shared.findCar { locations, kind in
            self.reStackAnimated(stackKind: kind)
            self.updateMapAnnotationsAnimated(annotations: locations)
        }
    }
    
    func showSettingsAlert(withTitle title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let enableAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        
        alert.addAction(enableAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- Events
    @IBAction func didTapFindButton(_ sender: UIButton) {
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            Location.shared.coreLocation.requestAlwaysAuthorization()
            self.findButton.setImage(#imageLiteral(resourceName: "gps"), for: .normal)
        } else if (CLLocationManager.authorizationStatus() == .denied) {
            showSettingsAlert(withTitle: "Please enable Location services")
        } else if state == .noMotionData {
            showSettingsAlert(withTitle: "Please enable Motion & Fitness")
        } else {
            searchCar()
        }
    }
}

//MARK:- MapDelegate
extension ViewController: MapDelegate {
    func didUpdateLocation(currentLocation: CLLocation?) {
//       guard let currentLocation = currentLocation else {return}
        
//        let mapRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0))
//        OperationQueue.main.addOperation {
//            self.mapView.setRegion(mapRegion, animated: true)
//        }
//        
    }
}

//MARK:- UIPreviewInteractionDelegate
extension UIViewController: UIViewControllerPreviewingDelegate {
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let logViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logViewController") as? LogViewController
            else { return nil }
        
        return logViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let logViewController = viewControllerToCommit as? LogViewController else { return }
        logViewController.closeButton.isHidden = false
        present(logViewController, animated: true, completion: nil)
    }
}
