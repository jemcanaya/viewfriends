//
//  LocationFetcher.swift
//  AddFriends
//
//  Created by Jemerson Canaya on 3/4/25.
//

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func end() {
        manager.stopUpdatingLocation()
    }
    
    func getLastKnownLocation() -> CLLocationCoordinate2D {
        guard let lastKnownLocation else {
            return CLLocationCoordinate2D()
        }
        
        return lastKnownLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        if let lastKnownLocation {
            print("Last known location updated: \(lastKnownLocation)")
        } else {
            print("Failed to update last known location.")
        }
        
    }
}
