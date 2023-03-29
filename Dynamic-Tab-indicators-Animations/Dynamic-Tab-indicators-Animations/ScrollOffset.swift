//
//  ScrollOffset.swift
//  Dynamic-Tab-indicators-Animations
//
//  Created by shrise31 on 2023/3/28.
//

import SwiftUI


extension View {
    
    @ViewBuilder
    func offsetX(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay(
                GeometryReader { geometryProxy in
                    
                    let rect = geometryProxy.frame(in: .global)
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            )
    }
}

struct OffsetKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
