//
//  ShareLiftView.swift
//  Social Media for Lifting
//
//  Created by Matthew on 3/19/25.
//

import SwiftUI

struct ShareLiftView: View {
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
            
            Toggle(isOn: $prHit) {
                Text("Hit a PR?!")
            }
            .padding(.top, 30)
            //TODO: nove this hit a pr to below the add your gym
            
            if prHit {
                TextField("Bench by 20lbs", text: $prDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 10)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.gray)
                TextField("Add your gym", text: $gymDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                print("Lift Shared: \(selectedSplit ?? "None"), PR: \(prHit), Gym: \(atGym), PR Details: \(prDetails), Gym Details: \(gymDetails)")
                
                // TODO: needs to reset the add lift when hit, for now we can just print and thats it
            }) {
                Text("Share")
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

struct ShareLift_View: PreviewProvider {
    static var previews: some View {
        ShareLiftView()
    }
}
