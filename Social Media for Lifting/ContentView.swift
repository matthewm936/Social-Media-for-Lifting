import SwiftUI

struct ContentView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false  // Persistent login state

    var body: some View {
        if isSignedIn {
            TabView {
                FeedView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                ShareLiftView()
                    .tabItem {
                        Label("Share Lift", systemImage: "plus.app")
                    }

                AddFriendsView()
                    .tabItem {
                        Label("Add Friends", systemImage: "magnifyingglass")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
        } else {
            SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
