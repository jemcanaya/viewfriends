//
//  Friends.swift
//  My App
//
//  Created by Jemerson Canaya on 3/4/25.
//
import SwiftUI
import CoreLocation

struct Friends: Codable, Equatable, Identifiable, Comparable {
    var id: UUID = UUID()
    var imageData: Data?
    var name: String
    var contactNumber: String
    var socialMedia: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var image: Image {
        
        if let imageData = imageData {
            
            if let inputImage = UIImage(data: imageData) {
                return Image(uiImage: inputImage)
            }
            
        }
        
        return Image("sampleImage")

    }
    
    #if DEBUG
    static let example = Friends(
        id: UUID(),
        imageData: nil,
        name: "Jemerson Canaya",
        contactNumber: "+639177123456",
        socialMedia: "@jemersoncanaya",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        latitude: 7.1907,
        longitude: 125.4553
    )
    #endif
    
    static func <(lhs: Friends, rhs: Friends) -> Bool {
        lhs.name > rhs.name
    }
}

@Observable
class Friend {
    
    let savedPath = URL.documentsDirectory.appending(path: "SavedFriends")
    
    var friends = [Friends]() {
        didSet {
            do {
                let data = try JSONEncoder().encode(friends)
                try data.write(to: savedPath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Failed to save friends: \(error)")
            }
            
        }
    }
    
    init() {
        do {
            let savedFriends = try Data(contentsOf: savedPath)
            if let decodedFriends = try? JSONDecoder().decode([Friends].self, from: savedFriends) {
                friends = decodedFriends
                return
            }
            
            friends = []
            
        } catch {
            print("Failed to load friends: \(error)")
        }
        
        friends = []
        
    }
}
