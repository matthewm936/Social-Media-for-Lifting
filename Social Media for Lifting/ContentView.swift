import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "house")
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
    }
}

struct ScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Preview for Xcode canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
