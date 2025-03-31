import SwiftUI
import PhotosUI
import UIKit

struct AddFriends: View {
    @Environment(\.dismiss) private var dismiss
    
    let locationFetcher = LocationFetcher()
    
    // Photos related properties
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImageData: Data = Data()
    @State private var selectedImage: Image?
    
    @State private var name: String = ""
    @State private var contactNumber: String = ""
    @State private var socialMedia: String = ""
    @State private var description: String = ""
    
    @FocusState private var isNameFocused: Bool
    @State private var isShowingCamera = false
    @State private var isShowingPhotoPicker = false
    
    var onSave: (Friends) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                if selectedImage == nil {
                    Circle()
                        .frame(width: 150, height: 150)
                        .overlay {
                            ZStack {
                                Color.white
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 150))
                            }
                        }
                        .clipShape(.circle)
                        .shadow(radius: 10)
                } else {
                    selectedImage?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(.circle)
                        .shadow(radius: 10)
                }
                
                if selectedImage != nil {
                    TextField("Name", text: $name)
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .disabled(selectedImage == nil)
                        .focused($isNameFocused)
                }
                
                
                
//                PhotosPicker("\(selectedImage == nil ? "Add new" : "Update") profile image", selection: $pickerItem, matching: .any(of: [.images, .not(.screenshots)]))
//                    .foregroundStyle(selectedImage == nil ? .blue : .yellow)
                
                Button("\(selectedImage == nil ? "Add new" : "Update") profile image") {
                    isShowingPhotoPicker = true
                }
                .foregroundStyle(selectedImage == nil ? .blue : .yellow)
                
            }
            .padding(.vertical, 15.0)
            .onChange(of: pickerItem, loadImage)
            .onAppear(perform: startLocationTracking)
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage, selectedImageData: $selectedImageData, focusedState: _isNameFocused)
            }
            .sheet(isPresented: $isShowingPhotoPicker) {
                Form {
                    Button {
                        isShowingCamera = true
                    } label: {
                        HStack {
                            Image(systemName: "camera")
                            Text("Import from Camera")
                        }
                    }
                    PhotosPicker(selection: $pickerItem, matching: .any(of: [.images, .not(.screenshots)])) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Import from Photos")
                        }
                    }
                    
                }
                .onDisappear {
                    isShowingPhotoPicker = false
                }
                .presentationDetents([.medium])
            }
            .onChange(of: pickerItem) {
                
                isShowingPhotoPicker = false
                
            }
            .onChange(of: isShowingCamera) {
                
                isShowingPhotoPicker = false
                
            }
            
            Form {
                Section("Contact Number") {
                    TextField("Contact Number", text: $contactNumber)
                        .keyboardType(.namePhonePad)
                }
                
                Section("Social Media") {
                    TextField("Social Media", text: $socialMedia)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel(Text("Description"))
                }
            }
            .disabled(selectedImage == nil)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        stopLocationTracking()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("saved")
                        
                        let latitude = locationFetcher.getLastKnownLocation().latitude
                        let longitude = locationFetcher.getLastKnownLocation().longitude
                        
                        let friend = Friends(imageData: selectedImageData, name: name, contactNumber: contactNumber, socialMedia: socialMedia, description: description, latitude: latitude, longitude: longitude)
                        onSave(friend)
                        stopLocationTracking()
                        dismiss()
                    }
                }
            }

        }
                
        
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await pickerItem?.loadTransferable(type: Data.self) else { return }
            
            selectedImageData = imageData
            
            guard let inputImage = UIImage(data: selectedImageData) else { return }
            
            selectedImage = Image(uiImage: inputImage)
            
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFocused = true
            }
        }
    }
    
    init(onSave: @escaping (Friends) -> Void) {
        self.onSave = onSave
    }
    
    func startLocationTracking() {
        locationFetcher.start()
    }
    
    func stopLocationTracking() {
        locationFetcher.end()
    }
    
    
}

#Preview {
    AddFriends() { _ in }
}
