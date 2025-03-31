import SwiftUI

struct MainMenu: View {
    let locationFetcher = LocationFetcher()
    
    @State var friend = Friend()
    
    @FocusState private var isFocused: Bool
    @State private var isSearching: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var selectedIndex: IndexSet?
    
    var filteredFriends: [Friends] {
        if searchText.isEmpty {
            friend.friends
        } else {
            friend.friends.filter {
                $0.name.localizedStandardContains(searchText)
            }
        }
    }
    
    @State private var showingAddFriends = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if friend.friends.isEmpty {
                    ContentUnavailableView("It's empty here", systemImage: "face.dashed.fill")
                } else {
                    
                    if filteredFriends.isEmpty && searchText.isEmpty == false {
                        ContentUnavailableView("Search returns no results", systemImage: "exclamationmark.magnifyingglass")
                    } else {
                        List {
                            
                            ForEach(filteredFriends.sorted()) { friend in
                                NavigationLink {
                                    ViewFriends(friend: self.friend, friends: friend)
                                } label: {
                                    ZStack {
                                        friend.image
                                            .resizable()
                                            .scaledToFill()
                                            .padding(-40)
                                            .frame(maxWidth: .infinity, maxHeight: 60)
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .padding(-40)
                                        Text(friend.name)
                                            .font(.title)
                                            .fontDesign(.rounded)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                            .onDelete(perform: deleteFriends(at:))
                            
                            
                        }
                        .scrollDismissesKeyboard(.immediately)
                    }
                }
                
                Group {
                    if isSearching {
                        
                        HStack {
                            TextField("Search", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 300)
                                .padding(.vertical, 10)
                                .padding(.trailing, 5)
                                .padding(.leading, 10)
                                .background(.quinary)
                                .clipShape(.rect(cornerRadius: 25))
                                .focused($isFocused)
                            Button("Submit", systemImage: "xmark.circle.fill") {
                                withAnimation(.snappy) {
                                    isSearching.toggle()
                                    isFocused.toggle()
                                    searchText.removeAll()
                                }
                                
                            }
                            .buttonStyle(.plain)
                            .labelStyle(.iconOnly)
                            .font(.system(size: 30))
                        }
                        .frame(height: 55)
                        .padding(.bottom, 5)

                        
                    } else {
                        VStack(spacing: 40.0) {
                            VStack {
                                HStack {
                                    Text("Hi There")
                                        .font(.largeTitle)
                                        .fontDesign(.rounded)
                                        .fontWeight(.bold)
                                    
                                    Text("👋")
                                        .font(.system(size: 50.0))
                                }
                                Text("Add your friends at a glance!")
                            }
                            
                            HStack {
                                
                                Spacer()
                                
                                Button {
                                    showingAddFriends.toggle()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 75.0))
                                        .foregroundStyle(.blue)
                                }
                                
                                Spacer()
                                    .overlay {
                                        
                                        if friend.friends.isEmpty == false {
                                            
                                            HStack {
                                                
                                                Spacer()
                                                
                                                Button {
                                                    withAnimation(.snappy) {
                                                        isSearching.toggle()
                                                        isFocused.toggle()
                                                    }
                                                } label: {
                                                    Image(systemName: "magnifyingglass")
                                                        .font(.system(size: 30.0))
                                                }
                                                .padding(.trailing, 20)
                                            }
                                            
                                        }
                                        
                                    }
                                
                            }
                            
                        }
                    }
                                        
                    
                    
                    
                    
                }
                

                
            }
            .overlay(alignment: .top) {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    GeometryReader { geometry in
                        let safeAreaTop = geometry.safeAreaInsets.top
                        
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: safeAreaTop + 20)
                            .ignoresSafeArea()
                            .blur(radius: 15)
                    }
                }
                
            }
            .sheet(isPresented: $showingAddFriends) {
                AddFriends() {
                    saveFriends(savedFriend: $0)
                }
            }
            .alert("Are you sure you want to delete this friend?", isPresented: $showDeleteConfirmation) {
                
                Button("Delete Friend", role: .destructive) {
                    
                    if let selectedIndex {
                        friend.friends.remove(atOffsets: selectedIndex)
                    }
                    
                }
            } message: {
                Text("Action cannot be undone.")
            }

        }
        
    }
    
    func saveFriends(savedFriend: Friends) {
        
        friend.friends.append(savedFriend)
        
    }
    
    func deleteFriends(at offsets: IndexSet) {
        
        showDeleteConfirmation = true
        selectedIndex = offsets
        
        
    }
    
}

#Preview {
    MainMenu()
}
