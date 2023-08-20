//
//  ReusablePostsViewModel.swift
//  EntangledButtons
//
//  Created by Zachary Coriarty on 8/20/23.
//

import SwiftUI

struct GroupRequest: Codable {
    var userUID: String
    var userName: String
    var requestTimestamp: Date?  // When the request was made
    var userProfilePicURL: String?
    
    enum CodingKeys: CodingKey {
        case userUID
        case userName
        case requestTimestamp
        case userProfilePicURL
    }
    
    // Initializer for when you manually create a GroupRequest
    init(userUID: String, userName: String, requestTimestamp: Date?, userProfilePicURL: String? = nil) {
        self.userUID = userUID
        self.userName = userName
        self.requestTimestamp = requestTimestamp
        self.userProfilePicURL = userProfilePicURL
    }
}


class ReusablePostsViewModel: ObservableObject {
    var basedOnUID: Bool
    var uid: String

    @Published var isFetching: Bool = true
    @Published var selectedImageURL: URL?
//    @Published var selectedPost = Post.empty
//    @Published var comments: [Comment] = []
    @Published var isCommentViewPresented = false
    @Published var newGroupName: String = ""
    @Published var hasFetchedUser: Bool = false
    @Published var isFetchingPosts = false
    @Published var currentGroupID: String = ""
    @Published var currentGroupName: String = ""
    @Published var userName: String = ""
    @Published var userProfileURL: URL? = nil
//    @Published var posts: [Post] = []
//    @Published var userGroups: [HabitGroup] = []
//    @Published var groupMembers: [Member] = []
    @Published var groupRequests: [GroupRequest] = []  // Assuming you have a GroupRequest model
    @Published var requestCount: Int = 0



//    @Published var paginationDoc: QueryDocumentSnapshot?
    @AppStorage("user_UID") var userUID: String = ""
    
    init(basedOnUID: Bool = false, uid: String = "") {
        self.basedOnUID = basedOnUID
        self.uid = uid
        createFakeGroupRequest()
//        fetchInitialData()
    }
    
    private func createFakeGroupRequest() {
        let fakeRequest = GroupRequest(
            userUID: "fakeUID1234",
            userName: "Fake User",
            requestTimestamp: Date(),
            userProfilePicURL: "https://example.com/fake_profile_pic.jpg"
        )
        self.groupRequests.append(fakeRequest)
        self.requestCount += 1
    }

    

    
    func denyUserRequest(userID: String) async {
        print("deny user func called")
        let group = HabitGroup(id: self.currentGroupID, name: self.currentGroupName)
//        let firestore = Firestore.firestore()
//        let groupDocument = firestore.collection("Groups").document(group.id)
        do {
//            try await groupDocument.collection("requests").document(userID).delete()
            await MainActor.run {
                if let index = self.groupRequests.firstIndex(where: { $0.userUID == userID }) {
                    self.groupRequests.remove(at: index)
                    self.requestCount -= 1
                }
            }
        } catch {
            print("Error denying request: \(error.localizedDescription)")
        }
    }
    
    func admitUserToGroup(userID: String, group: HabitGroup, userName: String, profilePic: String) async {
        print("approve user func called")

//        let firestore = Firestore.firestore()
//        let userDocument = firestore.collection("Users").document(userID)

        // Prepare the group data to be added to the user's groups
        let groupData: [String: Any] = [
            "id": group.id,
            "name": group.name
        ]
        
//        do {
            // 1. Add the group to the user's groups array
//            try await userDocument.updateData([
//                "groups": FieldValue.arrayUnion([groupData])
//            ])
            
            // 2. Add the user to the group's members collection
//            let groupDocument = firestore.collection("Groups").document(group.id)
//            let membersCollection = groupDocument.collection("members")

//            try await membersCollection.document(userID).setData([
//                "userID": userID,
//                "userName": userName,
//                "profilePicURL": profilePic
//            ])
            
            // 3. Remove the user's request from the group's "requests" collection
//            try await groupDocument.collection("requests").document(userID).delete()
            
            await MainActor.run {
                
                if let index = groupRequests.firstIndex(where: { $0.userUID == userID }) {
                    groupRequests.remove(at: index)
                    requestCount -= 1
                }
            }

            print("User \(userID) has been admitted to group \(group.name).")

            // Success Popup
//            popupMessage = "User approved successfully!"
//            popupColor = Color.green
//            popupIcon = "checkmark"
//            isPopupVisible = true
//        } catch {
            // Error Popup
//            popupMessage = "Error approving user!"
//            popupColor = Color.red
//            popupIcon = "xmark"
//            isPopupVisible = true
//        }
    }



}

struct HabitGroup: Codable {
    var id: String
    var name: String
}


