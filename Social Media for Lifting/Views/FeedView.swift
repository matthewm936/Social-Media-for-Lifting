//
//  FeedView.swift
//  Social Media for Lifting
//
//  Created by Matthew on 3/19/25.
//

import SwiftUI

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let content: String
}

let samplePosts = [
    Post(username: "Lifter123", content: "Hit a new PR on bench today!"),
    Post(username: "StrongGal99", content: "Deadlifts feeling smooth today."),
    Post(username: "GymBro2024", content: "Squats are pain but worth it!"),
]
// TODO: add these into the feed so we can see this stuff, make sure to delimate posts by a thin grey line that doesn not go all the way across the screen

// TODO: also change these posts to look like this format ex. 'Name of Person' with profile picture, lifted at 'gym', and hit 'legs', bc the gym isn't always necessary make a few data points without that,also add in a few w a pr, make sure however that like instagrams feed, each 'post' (smaller in height bc no picture, contains the user's name, username, split part htey lifted, and the pr if added, and the gy

struct FeedView: View {
    @State private var showButton = true
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
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

struct Feed_View: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
