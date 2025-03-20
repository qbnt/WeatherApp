//
//  BottomBarView.swift
//  weather_app
//
//  Created by Quentin Banet on 20/02/2025.
//

import SwiftUI

struct BottomBarView: View {
    @Binding var selectedTab: Tab

    let tabs: [(tab: Tab, icon: String, name: String)] = [
        (.currently, "house.fill", "Currently"),
        (.today, "sunrise.fill", "Today"),
        (.weekly, "calendar", "Weekly")
    ]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.tab) { item in
                Spacer()
                Button(action: { selectedTab = item.tab }) {
                    VStack {
                        Image(systemName: item.icon)
                            .font(.system(size: 18))
                            .foregroundColor(selectedTab == item.tab ? Color.blue : Color.gray)
                        Text("\(item.name)")
                            .foregroundColor(selectedTab == item.tab ? Color.blue : Color.gray)
                    }
                    .frame(width: 80, alignment: .center)
                    .shadow(color: Color.gray.opacity(0.6), radius: 10, x: 0, y: -9)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    BottomBarView(selectedTab: .constant(.currently))
}
