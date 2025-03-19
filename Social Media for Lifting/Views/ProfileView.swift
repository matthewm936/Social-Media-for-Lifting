import PhotosUI
import SwiftUI


struct ProfileView: View {
    @State private var username = "User Name"
    @State private var bio = "Bio..."
    @State private var followers = 250
    @State private var following = 180
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill") // Placeholder
    @State private var isEditingProfile = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        VStack {
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

struct Profile_View: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
