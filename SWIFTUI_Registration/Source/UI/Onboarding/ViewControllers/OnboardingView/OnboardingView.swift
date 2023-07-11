//
//  OnboardingView.swift
//  MainTarget
//
//  Created by o.sander on 28.06.2023.
//  
//

import SwiftUI
import Combine

extension OnboardingView {
    enum Actions {
        case login
        case signup
    }
}

struct OnboardingView: View {

    let actions: PassthroughSubject<Actions, Never>
    let pages = Onboarding.pages
    @State private var currentIndex: Int = 0
    private var showNavigationBar: Bool { currentIndex > 0 }
    private var isLastPage: Bool { currentIndex == pages.count - 1 }

    var body: some View {
        ZStack {
            Colors.backgoundColor.ignoresSafeArea()
            navigationBar
                .animation(.interactiveSpring(response: 0.5), value: showNavigationBar)
            onboardingContent
        }
    }

    var navigationBar: some View {
        HStack {
            Button {
                currentIndex -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Colors.rose1)
                    .font(.headline.weight(.bold))
                    .frame(minWidth: 44, minHeight: 44)
            }
            .padding(.horizontal, 8)
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .offset(y: showNavigationBar ? 0 : -120)
    }

    var onboardingContent: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                ForEach(0..<pages.count, id: \.self) { index in
                    pageContent(size: size, index: index)
                        .padding(.bottom, 70)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Next button
            .overlay(alignment: .bottom) {
                Button {
                    if isLastPage {
                        actions.send(.signup)
                    } else {
                        currentIndex += 1
                    }
                } label: {
                    HStack {
                        if isLastPage {
                            Text("Sign Up")
                                .font(.poppinsFixed(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 22).weight(.black))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: isLastPage ? 224 : 44, height: isLastPage ? 58 : 44)
                    .background(Colors.rose1)
                    .clipShape(
                        RoundedRectangle(cornerRadius: isLastPage ? 29 : 22,
                                         style: isLastPage ? .continuous : .circular)
                    )
                }
                .offset(y: -80)
                .animation(.interactiveSpring(response: 0.5), value: isLastPage)
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: -8) {
                    Text("Already have an account?")
                        .font(.poppinsFixed(size: 12))
                        .foregroundColor(Colors.primary)
                    Button {
                        actions.send(.login)
                    } label: {
                        Text("Login")
                            .font(.poppinsFixed(size: 13, weight: .bold))
                            .foregroundColor(Colors.rose1)
                            .frame(minHeight: 40.0)
                    }
                }
                .offset(y: isLastPage ? 0 : 150)
                .animation(.interactiveSpring(response: 0.5), value: isLastPage)
            }
            .offset(y: -20)
        }
    }

    func pageContent(size: CGSize, index: Int) -> some View {
        VStack(spacing: 35) {
            let page = pages[index]
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.7),
                    value: currentIndex)

            Group {
                Text(page.title)
                    .font(.poppinsFixed(size: 22, weight: .bold))
                    .foregroundColor(Colors.rose1)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7)
                        .delay(0.1),
                        value: currentIndex)

                Text(page.subtitle)
                    .font(.poppinsFixed(size: 16))
                    .foregroundColor(Colors.primary)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7)
                        .delay(currentIndex == index ? 0.2 : 0.0),
                        value: currentIndex)

            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: 230)
        }
        .offset(x: -size.width * CGFloat(currentIndex - index))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(actions: .init())
    }
}
