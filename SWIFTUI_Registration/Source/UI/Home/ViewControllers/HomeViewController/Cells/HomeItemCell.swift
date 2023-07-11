//
//  HomeItemCell.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import SwiftUI

struct HomeItemCell: View {
    let item: HomeItemVM

    var body: some View {
        ZStack {
            LinearGradient.general
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading, spacing: 10) {
                Text(item.title)
                    .font(.appFootnote).bold()
                    .foregroundColor(.white)
                Text(item.subtitle)
                    .font(.appCaption)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .overlay(alignment: .bottomLeading) {
            Image(systemName: "arrow.forward")
                .foregroundColor(.white)
                .padding(24)
        }
        .cornerRadius(10)
    }
}

struct HomeItemCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeItemCell(item: HomeItemVM.items[0])
            .previewLayout(.fixed(width: 315, height: 170))
    }
}
