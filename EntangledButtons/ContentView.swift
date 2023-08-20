//
//  ContentView.swift
//  EntangledButtons
//
//  Created by Zachary Coriarty on 8/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ReusablePostsView(includeNav: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
