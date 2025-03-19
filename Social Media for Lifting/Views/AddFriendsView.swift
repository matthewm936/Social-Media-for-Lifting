import SwiftUI

struct AddFriendsView: View {
    @State private var searchText = ""
    @State private var recentSearches: [String] // Now directly passed in the initializer

    // Custom initializer for testing purposes
    init(recentSearches: [String] = []) {
        _recentSearches = State(initialValue: recentSearches) // Set the initial value of the state property
    }

    var body: some View {
        VStack {
            // Search field, similar to Instagram's
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 8) // Shift the magnifying glass to the right
                TextField("Search profiles", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding()

            // Recent searches section
            VStack(alignment: .leading) {
                Text("Recent Searches")
                    .font(.headline)
                    .padding(.leading, 16) // Left-align the title
            }
            .padding(.top, 20)

            // Display recent searches or "No recent searches"
            if recentSearches.isEmpty {
                Spacer() // Pushes the "No recent searches" to the center vertically
                Text("No recent searches")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center) // Center align the text
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    .frame(maxHeight: .infinity, alignment: .top) // Adjust vertical alignment
            } else {
                ScrollView {
                    ForEach(recentSearches, id: \.self) { search in
                        Text(search)
                            .padding(.vertical, 5)
                    }
                }
            }
        }
        .padding()
    }
}

struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with recent searches
        AddFriendsView(recentSearches: ["John Doe", "Jane Smith", "Mike Ross"])
            .previewDisplayName("With Recent Searches")

        // Preview with no recent searches
        AddFriendsView(recentSearches: [])
            .previewDisplayName("No Recent Searches")
    }
}
