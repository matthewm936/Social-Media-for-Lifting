//
//  AddFriendsView.swift
//  Social Media for Lifting
//
//  Created by Matthew on 3/19/25.
//

import SwiftUI

struct AddFriendsView: View {
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

struct AddFreinds_View: PreviewProvider {
    static var previews: some View {
        AddFriendsView()
    }
}

