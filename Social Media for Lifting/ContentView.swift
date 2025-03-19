import SwiftUI

// Sample data structure for test users and previous posts
struct Post: Identifiable {
    let id = UUID()
    let username: String
    let content: String
}

// Mock Data
let samplePosts = [
    Post(username: "Lifter123", content: "Hit a new PR on bench today!"),
    Post(username: "StrongGal99", content: "Deadlifts feeling smooth today."),
    Post(username: "GymBro2024", content: "Squats are pain but worth it!"),
]

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house")
                }

            AddLiftView()
                .tabItem {
                    Label("Add Lift", systemImage: "plus.app")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}


// FeedView where users can see the feed
struct FeedView: View {
    @State private var showButton = true // Track visibility of the button
    
    var body: some View {
        VStack {
            // Feed content - Placeholder for now
            ScrollView {
                VStack {
                    // Show the 'Tell a Friend to Lift' button at the top
                    if showButton {
                        Button(action: {
                            // Action when button is clicked
                            print("Tell a friend to lift!")
                        }) {
                            Text("Tell a Friend to Lift")
                                .font(.title2)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }

                    // Feed content below the button
                    Text("Feed content goes here.")
                        .padding()
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ScrollViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                })
                .onPreferenceChange(ScrollViewOffsetKey.self) { value in
                    // When user scrolls, hide the button after a certain scroll position
                    withAnimation {
                        if value < -100 {
                            self.showButton = false
                        } else {
                            self.showButton = true
                        }
                    }
                }
            }
        }
    }
}

import PhotosUI

struct ProfileView: View {
    @State private var username = "User Name"
    @State private var bio = "My bio"
    @State private var followers = 250
    @State private var following = 180
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill") // Placeholder
    @State private var isNightOwl = false
    @State private var isEditingProfile = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        VStack {
//            // Switch Button to toggle Night Owl or Early Bird
//            HStack {
//                Button(action: {
//                    isNightOwl.toggle()
//                }) {
//                    Text(isNightOwl ? "Switch to Early Bird" : "Switch to Night Owl")
//                        .font(.body)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                Spacer()
//            }
//            .padding(.top, 50)

            // Profile Image
            profileImage?
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .padding(.top, 20)
    

            // Username
            Text(username)
                .font(.title)
                .bold()

            // Bio
            Text(bio)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)

            // Followers and Following count
            HStack {
                VStack {
                    Text("\(followers)")
                        .font(.title2)
                        .bold()
                    Text("Followers")
                        .font(.subheadline)
                }
                Spacer()
                VStack {
                    Text("\(following)")
                        .font(.title2)
                        .bold()
                    Text("Following")
                        .font(.subheadline)
                }
            }
            .padding()

            // Edit Profile Button
            Button(action: {
                isEditingProfile = true
            }) {
                Text("Edit Profile")
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(username: $username, bio: $bio, profileImage: $profileImage)
            }

            Spacer()
        }
        .padding()
    }
}

// Edit Profile View
struct EditProfileView: View {
    @Binding var username: String
    @Binding var bio: String
    @Binding var profileImage: Image?
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Picture")) {
                    HStack {
                        Spacer()
                        profileImage?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        Spacer()
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Select New Profile Picture")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                if let uiImage = UIImage(data: data) {
                                    profileImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Username")) {
                    TextField("Enter your username", text: $username)
                }
                
                Section(header: Text("Bio")) {
                    TextField("Write something about yourself...", text: $bio)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}



// ScrollViewOffsetKey to capture the scroll position
struct ScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Add Lift View where users can add their lift info
struct AddLiftView: View {
    @State private var selectedSplit: String? = nil
    @State private var prHit = false
    @State private var atGym = false
    @State private var prDetails = ""
    @State private var gymDetails = ""
    
    let splits = ["Upper", "Lower", "Push", "Pull", "Legs", "Cardio"]
    
    var body: some View {
        VStack {
            Text("Add Lift")
                .font(.headline)
                .padding(.top, 20)
            
            // Grid view for workout splits
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(splits, id: \.self) { split in
                    Button(action: {
                        selectedSplit = selectedSplit == split ? nil : split // Toggle selection
                    }) {
                        Text(split)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedSplit == split ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.top, 20)
            
            // PR Hit checkbox
            Toggle(isOn: $prHit) {
                Text("Hit a PR?!")
            }
            .padding(.top, 30)
            
            // Text Fields for PR and Gym details (only visible if toggled on)
            if prHit {
                TextField("Bench 315 x 2?!", text: $prDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 10)
            }
            
            // Gym entry field with location icon
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.gray)
                TextField("Where'd you lift? Shoutout your gym:", text: $gymDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.top, 10)
            
            Spacer()
            
            // Share Lift button at the bottom
            Button(action: {
                // Handle share functionality here (e.g., save to DB or share the lift)
                print("Lift Shared: \(selectedSplit ?? "None"), PR: \(prHit), Gym: \(atGym), PR Details: \(prDetails), Gym Details: \(gymDetails)")
            }) {
                Text("Share Lift")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

// SearchView where users can search for other profiles
struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // Search field, similar to Instagram's
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search profiles", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding()
            
            // Placeholder for search results
            ScrollView {
                Text("Search results will appear here.")
                    .padding()
            }
        }
    }
}

// Preview for Xcode canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
