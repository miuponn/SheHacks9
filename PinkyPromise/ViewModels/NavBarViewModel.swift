//
//  NavBarViewModel.swift
//  PinkyPromise
//
//  Created by Lauren Hong  on 2025-01-12.
//

import SwiftUI

struct WithBottomNavBar: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                BottomNavBar()
            }
            .ignoresSafeArea(.keyboard) // Prevents keyboard from pushing up the nav bar
        }
    }
}

// Extension to make it easier to use the modifier
extension View {
    func withBottomNavBar() -> some View {
        modifier(WithBottomNavBar())
    }
}
