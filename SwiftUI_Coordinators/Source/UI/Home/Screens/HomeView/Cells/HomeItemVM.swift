//
//  HomeItemVM.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import Foundation

struct HomeItemVM: Hashable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    let imageName: String
}

extension HomeItemVM {
    static var items: [HomeItemVM] {
        [
            HomeItemVM(id: 0,
                       title: "Schedule",
                       subtitle: "Easily schedule event/games \nthen find like minded players for \nbattle. You up for it?",
                       imageName: "illustration_home_1"),
            HomeItemVM(id: 1,
                       title: "Statistics",
                       subtitle: "All data from previous and\nupcoming games can be found here",
                       imageName: "illustration_home_2"),
            HomeItemVM(id: 2,
                       title: "Discover  Combats",
                       subtitle: "Find out what’s new and compete \namong players with new \nchallenges and earn cash with \ngame points ",
                       imageName: "illustration_home_3"),
            HomeItemVM(id: 3,
                       title: "Message Players",
                       subtitle: "ound the profile of a player\n that interests you? Start a\n conversation",
                       imageName: "illustration_home_4")
        ]
    }
}
