import SwiftUI

struct FeedView: View {
    @State private var showButton = true
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if showButton {
                        Button(action: {
                            // TODO: notification here when button is clicked
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

struct ScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Feed_View: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
