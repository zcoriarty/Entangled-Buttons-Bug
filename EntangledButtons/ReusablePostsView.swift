//
//  ReusablePostsView.swift
//  EntangledButtons
//
//  Created by Zachary Coriarty on 8/20/23.
//

import SwiftUI

struct ReusablePostsView: View {
    @ObservedObject var viewModel: ReusablePostsViewModel
    @State private var showDropdown: Bool = false
    @State private var isGroupActionSheetPresented: Bool = false
    @State private var isMakingNewGroup: Bool = false
    @State private var newGroupName: String = ""
    @State private var selectedGroupIndex: Int = 0
    @State private var membersLoaded: Bool = false
    @State var includeNav: Bool
    @State private var showRequestSheet: Bool = false


    var pseudoNavigationBar: some View {
        HStack {
            HStack {
                Text(viewModel.currentGroupName)
                    .font(.headline)
                Image(systemName: "chevron.down")
                    .font(.headline)
            }
            .onTapGesture {
                withAnimation {
                    showDropdown.toggle()
                }
            }

            
            Spacer()
            
            if includeNav {
                    Button(action: {
                        showRequestSheet.toggle()
                    }) {
                        Image(systemName: "bell.fill")
                            .font(.title3)
                            .overlay(
                                Group {
                                    if viewModel.requestCount > 0 {
                                        Text("\(viewModel.requestCount)")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(5)  // Adjust as needed for padding around the number
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                }
                                .offset(x: 5, y: -9), // Adjust x and y for better positioning
                                alignment: .topTrailing
                            )

                }
            

//                NavigationLink(destination: SearchView(userName: viewModel.userName, userProfileURL: viewModel.userProfileURL, existingGroups: viewModel.userGroups)) {
//                    Image(systemName: "magnifyingglass")
//                        .font(.title3)
//                }
            }
        }
    }
    



    init(basedOnUID: Bool = false, uid: String = "", includeNav: Bool) {
        self.viewModel = ReusablePostsViewModel(basedOnUID: basedOnUID, uid: uid)
        self.includeNav = includeNav
    }

    @AppStorage("user_UID") var userUID: String = ""
    /// - View Properties
    var body: some View {
        ZStack(alignment: .top) {
            VStack (alignment: .trailing, spacing: 0) {
                pseudoNavigationBar
                    .padding(.bottom)
                
//                if viewModel.groupMembers.count > 1 {
//                    memberProfilePictures // Add this line
//                        .padding(.bottom)
//                        .padding(.bottom, 10)
//                }


                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack{
                        if viewModel.isFetching{
                            ProgressView()
                                .padding(.top,30)
                        }else{
//                            if viewModel.posts.isEmpty{
                                /// No Post's Found on Firestore
                                Text("No Post's Found")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top,30)
//                            }else{
//                                /// - Displaying Post's
////                                Posts()
//                            }
                        }
                    }
                    
                    
                }
            }

            .blur(radius: showDropdown ? 4.0 : 0) // Add the blur for your modal too

            // Click Outside to Dismiss
            if showDropdown {
                Button(action: {
                    withAnimation {
                        showDropdown.toggle()
                    }
                }) {
                    Color.clear
                }
            }
            
            if showDropdown {
                VStack(alignment: .leading, spacing: 5) {


                }
                .padding()
                .background(Color.black.opacity(0.9).cornerRadius(15))
                .frame(maxWidth: 250)
                .transition(.move(edge: .leading))
//                .position(x: 78, y: CGFloat(45 + (30 * viewModel.userGroups.count)))
            }


        }

        .sheet(isPresented: $showRequestSheet) {
            RequestSheetView(viewModel: viewModel)
        }

        if let url = viewModel.selectedImageURL {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 4.0)
                .onTapGesture {
                    viewModel.selectedImageURL = nil
                }
            Button(action: {
                viewModel.selectedImageURL = nil
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
            })
            .position(x: 40, y: 40)
        }
        
    }
      


}


struct RequestSheetView: View {
    @ObservedObject var viewModel: ReusablePostsViewModel
    
    @State private var isPopupVisible: Bool = false
    @State private var popupMessage: String = ""
    @State private var popupColor: Color = .clear
    @State private var popupIcon: String = ""
    
    var body: some View {
        VStack {
            Text("Join Requests")
                .font(.headline)
                .padding()
            
            List(viewModel.groupRequests, id: \.userUID) { request in
                
                if viewModel.requestCount == 0 {
                    // Display the no-requests card here
                    VStack(alignment: .center, spacing: 20) {
                        Text("No requests to join your group yet. Share it below!")
                            .font(.headline)
                            .padding()
                        
                        Button(action: {
                            // Handle share button tap action here
                            print("Share button tapped")
                        }) {
                            Text("Share Group")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding()
                } else {
                    
                    VStack(spacing: 15) {
                        HStack {
                            //                            WebImage(url: URL(string: request.userProfilePicURL ?? "")).placeholder {
                            //                                // MARK: Placeholder Image
                            //                                Image("NullProfile")
                            //                                    .resizable()
                            //                            }
                            //                            .resizable()
                            //                            .aspectRatio(contentMode: .fill)
                            //                            .frame(width: 50, height: 50)
                            //                            .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                // Username
                                Text(request.userName)
                                
                                //                                Text(timeAgo(from: request.requestTimestamp ?? Date()))
                                //                                    .font(.subheadline)
                                //                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            
                        }
                        
                        HStack() {
                            
                            Button(action: {
                                print("Deny button tapped")
                                
                                Task {
                                    await viewModel.denyUserRequest(userID: request.userUID)
                                }
                                
                            }) {
                                Text("Deny")
                                    .padding()

                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                            // Approve Button
                            Button(action: {
                                print("Approve button tapped")
                                Task {
                                    await viewModel.admitUserToGroup(userID: request.userUID, group: HabitGroup(id: viewModel.currentGroupID, name: viewModel.currentGroupName), userName: request.userName, profilePic: request.userProfilePicURL ?? "")
                                }
                            }) {
                                Text("Approve")
                                    .padding()
                                
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        //        .popup(isPresented: $isPopupVisible) {
        //            HStack {
        //                Image(systemName: popupIcon)
        //                    .resizable()
        //                    .frame(width: 20, height: 20)
        //                    .foregroundColor(popupColor == Color.green ? Color.white : Color.red)
        //                Text(popupMessage)
        //                    .foregroundColor(Color.white)
        //            }
        //            .padding()
        //            .background(popupColor)
        //            .cornerRadius(15)
        //        } customize: {
        //            $0.type(.floater())
        //                .position(.bottom)
        //                .autohideIn(3) // Dismiss after 3 seconds
        //        }
    }
}
