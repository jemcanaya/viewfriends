//
//  ViewFriends.swift
//  My App
//
//  Created by Jemerson Canaya on 3/4/25.
//
import SwiftUI
import MapKit

struct ViewFriends: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var friend = Friend()
    
    var friends: Friends
    
    @State private var isFullImageShown: Bool = false
    
    @State private var showDeleteConfirmation: Bool = false
    
    var friendPosition : MapCameraPosition {
        return MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: friends.latitude, longitude: friends.longitude),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        )
    }
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    friends.image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 350)
                        .onTapGesture {
                            isFullImageShown.toggle()
                        }
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 350)
                    .frame(maxWidth: .infinity)
                    .alignmentGuide(.bottom) { _ in 0 }
                    .padding(.bottom, -40)
                    .onTapGesture {
                        isFullImageShown.toggle()
                    }
                    
                    VStack {
                        Spacer()
                        
                        Text(friends.name)
                            .font(.title)
                            .fontDesign(.serif)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(friends.socialMedia)
                            .font(.title3)
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                    }
                    .frame(height: 350)
                    .padding(.bottom, 25)
                    .navigationDestination(isPresented: $isFullImageShown) {
                        friends.image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 25))
                            .padding(25)
                            
                    }
                }
                
                List {
                    Section("Contact Number") {
                        Text(friends.contactNumber)
                    }
                    
                    Section("Description") {
                        Text(friends.description)
                    }
                    
                    Section("Location") {
                        Map(initialPosition: friendPosition, interactionModes: []) {
                            Marker(friends.name, coordinate: friends.coordinate)
                        }
                        .frame(height: 300)
                        .padding(.horizontal, -20)
                        .padding(.vertical, -10)
                    }
                    
                    Button("Delete friend", role: .destructive) { showDeleteConfirmation = true }
                }
                
            }
            
        }
        .alert("Are you sure you want to delete this friend?", isPresented: $showDeleteConfirmation) {

            Button("Delete Friend", role: .destructive) {
                
                friend.friends.removeAll(where: { $0.id == friends.id })
                dismiss()
                
            }
            
        } message: {
            Text("Action cannot be undone.")
        }
    }
}

#Preview {
    ViewFriends(friends: .example)
}
