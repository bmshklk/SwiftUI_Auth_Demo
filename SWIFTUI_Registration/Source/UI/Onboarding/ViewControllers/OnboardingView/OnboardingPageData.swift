//
//  OnboardingPageData.swift
//  MainTarget
//
//  Created by o.sander on 28.06.2023.
//  
//

import Foundation

struct OnboardingPageData: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let imageName: String
}

struct Onboarding {
    static var pages: [OnboardingPageData] {
        [
            OnboardingPageData(id: 1,
                               title: "Get Paid! Playing Video Game",
                               subtitle: "Earn points and real cash when you win a battle with no delay in cashing out",
                               imageName: "illustration_onboarding_1"),
            OnboardingPageData(id: 2,
                               title: "Schedule Games With Friends",
                               subtitle: "Easily create an upcoming event and get ready for battle. Yeah! real combat fella.",
                               imageName: "illustration_onboarding_2"),
            OnboardingPageData(id: 3,
                               title: "Text, Audio and Video Chat",
                               subtitle: "Intuitive real life experience on mobile. Chat with fellow gamers before and after combat for free!",
                               imageName: "illustration_onboarding_3"),
        ]
    }
}
