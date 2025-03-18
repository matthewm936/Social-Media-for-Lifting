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

// ProfileView where users can see their profile
struct ProfileView: View {
    @State private var username = "User Name"
    @State private var followers = 250
    @State private var following = 180
    @State private var profileImage = Image(systemName: "person.circle.fill") // Placeholder profile image
    @State private var isNightOwl = false
    
    var body: some View {
        VStack {
            // Switch Button to toggle Night Owl or Early Bird
            HStack {
                Button(action: {
                    isNightOwl.toggle()
                }) {
                    Text(isNightOwl ? "Switch to Early Bird" : "Switch to Night Owl")
                        .font(.body)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.top, 50)
            
            // Profile Image
            profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.top, 20)
            
            // Username
            Text(username)
                .font(.title)
                .bold()
            
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
            
            Spacer()
        }
        .padding()
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
                Text("PR Hit")
            }
            .padding(.top, 30)
            
            // Gym checkbox
            Toggle(isOn: $atGym) {
                Text("At Gym")
            }
            .padding(.top, 10)
            
            // Text Fields for PR and Gym details (only visible if toggled on)
            if prHit {
                TextField("Enter PR details", text: $prDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 10)
            }
            
            if atGym {
                TextField("Enter Gym details", text: $gymDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 10)
            }
            
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
