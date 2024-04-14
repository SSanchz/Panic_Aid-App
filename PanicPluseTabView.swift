//
//  PanicPulseTabView.swift
//  PanicPulse
//
//  Created by Caitlyn Brown on 3/18/24.
//

import SwiftUI

struct PanicPulseTabView: View {
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            ContentView()
                .tag("Content")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    PanicPulseTabView()
}
