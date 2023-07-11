//
//  HomeView.swift
//  SwiftUI_Coordinators
//
//  Created by o.sander on 11.07.2023.
//

import SwiftUI

struct HomeView: View {
    var menuAction: VoidBlock

    var body: some View {
        VStack {
            HStack {
                Button(action: menuAction) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(Colors.primary)
                        .frame(width: 44.0, height: 44.0)
                    Spacer()
                }
                .padding(.horizontal, 12)
            }
            collection
        }
    }

    var collection: some View {
        GeometryReader { proxy in
            let itemHeight = (proxy.size.height - proxy.safeAreaInsets.bottom) / 4
            ScrollView {
                VStack {
                    ForEach(HomeItemVM.items, id: \.self) { item in
                        HomeItemCell(item: item)
                            .frame(height: itemHeight)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(menuAction: { })
    }
}
