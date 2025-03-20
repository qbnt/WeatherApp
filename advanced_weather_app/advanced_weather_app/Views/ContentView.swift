//
//  ContentView.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var weatherManager: WeatherManager

    @State private var selectedTab: Tab
    
    init(initialTab: Tab = .currently) {
            _selectedTab = State(initialValue: initialTab)
        }

    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(
                            colors: [Color.cyan.opacity(0.5), Color.white]),
                            center: .topTrailing,
                            startRadius: 50,
                            endRadius: 900)
            .ignoresSafeArea()

            VStack {
                TopBarView( )
                    .cornerRadius(20)
                    .padding([.top, .horizontal])

                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        tab.view
                            .tabItem {
                                Label(tab.tabInfo.title, systemImage: tab.tabInfo.icon)
                            }
                            .tag(tab)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                BottomBarView(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }

        }
    }
}

#Preview {
    ContentView(initialTab: .currently)
        .environmentObject(LocationManager.preview)
        .environmentObject(WeatherManager.preview)
}
