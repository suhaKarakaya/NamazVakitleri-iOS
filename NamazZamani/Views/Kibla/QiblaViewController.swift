//
//  QiblaViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 2.04.2022.
//

import UIKit
import CoreLocation


class QiblaViewController: UIViewController {

    @IBOutlet weak var imageQibla: UIImageView!
    var locationManager = CLLocationManager()
    var angle: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func degreesToRadians(_ x: CGFloat) -> CGFloat {
        return (Double.pi * x / 180.0)
    }
    
    
    func getHeadingForDirectionFromCoordinate(fromLoc: CLLocationCoordinate2D, toLoc: CLLocationCoordinate2D) -> CGFloat {

        let userLocationLatitude = degreesToRadians(fromLoc.latitude);
        let userLocationLongitude = degreesToRadians(fromLoc.longitude);

        let targetedPointLatitude = degreesToRadians(toLoc.latitude);
        let targetedPointLongitude = degreesToRadians(toLoc.longitude);

        let longitudeDifference = targetedPointLongitude - userLocationLongitude;

        let y = sin(longitudeDifference) * cos(targetedPointLatitude);
        let x = cos(userLocationLatitude) * sin(targetedPointLatitude) - sin(userLocationLatitude) * cos(targetedPointLatitude) * cos(longitudeDifference);
        var radiansValue = atan2(y, x);

        if(radiansValue < 0.0) {
            radiansValue += 2*Double.pi
        }

        return radiansValue;
    }
    
    
    
}

extension QiblaViewController: CLLocationManagerDelegate {
    
    // Location Manager Delegate stuff
    // If failed
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            var direction = newHeading.magneticHeading;

            if (direction > 180) {
                direction = 360 - direction;

            } else{
                direction = 0 - direction;
            }
        // Rotate the arrow image
        UIView.animate(withDuration: 0.1) {
            self.imageQibla.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(direction) + self.angle);
        }


    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let toLoc = CLLocationCoordinate2DMake(21.4225289,39.8239929);

        angle = getHeadingForDirectionFromCoordinate(fromLoc: locations.first!.coordinate, toLoc: toLoc)
    }

    // authorization status
    private func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch (status) {
        case .notDetermined:
            break;
        case .denied:
            break;
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() //Will update location immediately
            locationManager.startUpdatingHeading()
            break;
        default:
            break;
            
        }

    }
    
}

