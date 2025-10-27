//
//  OnboardingView.swift
//  Shovlr
//
//  Onboarding carousel showing app benefits
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool

    let pages = [
        OnboardingPage(
            icon: "snowflake",
            title: "On-Demand Snow Removal",
            description: "Get your driveway and walkways cleared at the tap of a button",
            color: Colors.primary
        ),
        OnboardingPage(
            icon: "dollarsign.circle.fill",
            title: "Upfront Pricing",
            description: "Know exactly what you'll pay before requesting service - no surprises",
            color: Colors.secondary
        ),
        OnboardingPage(
            icon: "checkmark.seal.fill",
            title: "Trusted Service",
            description: "Reliable local providers ready to clear your snow quickly and safely",
            color: Colors.success
        )
    ]

    var body: some View {
        ZStack {
            Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        showOnboarding = false
                    }
                    .foregroundColor(Colors.textSecondary)
                    .padding()
                }

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // Bottom button
                VStack(spacing: 16) {
                    if currentPage == pages.count - 1 {
                        PrimaryButton(title: "Get Started") {
                            showOnboarding = false
                        }
                        .padding(.horizontal)
                    } else {
                        Button("Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .foregroundColor(Colors.primary)
                        .font(.system(size: 18, weight: .semibold))
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Image(systemName: page.icon)
                .font(.system(size: 100))
                .foregroundColor(page.color)

            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.system(size: 18))
                    .foregroundColor(Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
