import SwiftUI

struct ShareLiftView: View {
    @State private var selectedSplit: String? = nil
    @State private var prHit = false
    @State private var atGym = false
    @State private var prDetails = ""
    @State private var gymDetails = ""
    
    // New state for workout type and time
    @State private var workoutType: String = "Choose your lifting style" // Default to 'Regular'
    @State private var currentTime = Date() // Use Date for time, so we can update it
    @State private var showTimePicker = false // Toggle for showing time picker
    
    let splits = ["Upper", "Lower", "Push", "Pull", "Legs", "Cardio", "Full Body", "Abs"]
    let workoutTypes = [
        "Active Recovery",
        "Athletic Training",
        "Bodybuilding",
        "Boxing",
        "Calisthenics",
        "Cardio",
        "Cross-Training",
        "Endurance",
        "Functional",
        "HIIT",
        "Mobility/Stretching",
        "Powerlifting",
        "Strength Training",
        "Yoga",
        "Pilates",
        "Choose your lifting style"
    ]

    // Function to get current time formatted
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: currentTime)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Add Lift")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)
            
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(splits, id: \.self) { split in
                    Button(action: {
                        selectedSplit = selectedSplit == split ? nil : split // Toggle selection
                    }) {
                        Text(split)
                            .font(.title2)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedSplit == split ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            
            Picker("Select Workout Style", selection: $workoutType) {
                ForEach(workoutTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .font(.title3)
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            if prHit {
                HStack {
                    TextField("Bench by 20lbs", text: $prDetails)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 5)
                    
                    Button(action: {
                        prDetails = ""
                        prHit = false
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                    }
                    .padding(.top, 5)
                }
            } else {
                Button(action: {
                    prHit.toggle()
                }) {
                    Text("Hit a personal record?!")
                        .foregroundColor(.blue)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 5)
            }
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.gray)
                TextField("Tag your gym", text: $gymDetails)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.top, 5)
            
            Text("Time: \(getCurrentTime())")
                .font(.title)
                .padding()
                .frame(width: 250, height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onTapGesture {
                    showTimePicker.toggle()
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Time Picker
            if showTimePicker {
                DatePicker(
                    "",
                    selection: $currentTime,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                print("Lift Shared: \(selectedSplit ?? "None"), PR: \(prHit), Gym: \(gymDetails), PR Details: \(prDetails), Workout Type: \(workoutType), Time: \(getCurrentTime())")
                // TODO: Add functionality for sharing lift
            }) {
                Text("Share")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)
        }
        .padding(16) // Reduced padding to make UI less crowded
        .onAppear {
            currentTime = Date()
        }
    }
}

struct ShareLift_View: PreviewProvider {
    static var previews: some View {
        ShareLiftView()
    }
}
