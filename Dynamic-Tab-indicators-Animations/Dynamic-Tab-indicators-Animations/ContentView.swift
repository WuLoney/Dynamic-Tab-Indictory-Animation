//
//  ContentView.swift
//  Dynamic-Tab-indicators-Animations
//
//  Created by shrise31 on 2023/3/28.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = tabs_[0]
    @State private var tabs: [Tab] = tabs_
    @State private var contentOffset: CGFloat = 0
    
    // Animation value
    @State private var indicatorWidth: CGFloat = 0
    @State private var indicatorPosition: CGFloat = 0
    
    @State private var currentIndex: Int64 = 1
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs) { tab in
                GeometryReader { geometryProxy in
                    let size = geometryProxy.size
                    Text(tab.pageName)
                        .font(Font.title)
                        .foregroundColor(Color.white)
                        .frame(width: size.width, height: size.height)
                        .background(
                            Rectangle()
                                .fill(Color.gray)
                                .edgesIgnoringSafeArea(.all)
                        )
                }
                .clipped()
                .ignoresSafeArea()
                .offsetX { rect in
                    if selection.pageName == tab.pageName {
                        contentOffset = rect.minX - (rect.width * CGFloat(index(of: tab)))
                    }
                    
                    updateTabFrame(rect.width)
                }
                .tag(tab)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode.never))
        .ignoresSafeArea()
        .overlay(TabsView(), alignment: .top)
        .preferredColorScheme(.dark)
    }
    
    /// Calculating Tab Width & Position
    func updateTabFrame(_ tabViewWidth: CGFloat) {
        let inputRange = tabs.indices.compactMap { index -> CGFloat? in
            return CGFloat(index) * tabViewWidth
        }
        
        let outputRangeForWidth = tabs.compactMap { tab -> CGFloat? in
            return tab.width
        }
        
        let outputRangeForPosition = tabs.compactMap { tab -> CGFloat? in
            return tab.minX
        }
        
        let widthInterpolation = LinearInterpolation(inputRange: inputRange, outputRange: outputRangeForWidth)
        
        let positionInterpolation = LinearInterpolation(inputRange: inputRange, outputRange: outputRangeForPosition)
        
        indicatorWidth = widthInterpolation.calculate(for: -contentOffset)
        indicatorPosition = positionInterpolation.calculate(for: -contentOffset)
    }
    
    func index(of tab: Tab) -> Int {
        return tabs.firstIndex(of: tab) ?? 0
    }
    
    @ViewBuilder
    func TabsView() -> some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: Layout.SafeAreaTopHeight)
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach($tabs) { $tab in
                            Text(tab.pageName)
                                .fontWeight(.semibold)
                                .frame(minWidth: 0, maxWidth: .infinity)
                            // 保存每个标签的位置
                                .offsetX { rect in
                                    if tab.minX == 0 && tab.width == 0 {
                                        tab.minX = rect.minX
                                        tab.width = rect.width
                                    }
                                }
                                .id(tab.index)
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    selection = tab
                                }
                            
                            if tabs.last != tab {
                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .padding([.vertical, .horizontal], 12)
                    .overlay(LineView(), alignment: .bottomLeading)
                }
                .foregroundColor(Color.black)
                .onChange(of: selection) { newValue in
                    
                    // 保持当前View的左边和右边，始终有两个View存在屏幕内
                    if newValue.index <= tabs.count && newValue.index > 0 {
                        let index = newValue.index > 2 ? newValue.index - 2 : newValue.index
                        
                        // 当前View
                        let currentTab = self.tabs.filter({ $0.index == index }).first
                        // 当前View右边的view
                        let nextTab = self.tabs.filter({ $0.index == newValue.index + 1 }).first
                        // 当前View左边的view
                        let firstTab = self.tabs.filter({ $0.index == newValue.index - 1 }).first
                        
                        guard let currentItem = currentTab, let nextItem = nextTab, let firstItem = firstTab else {
                            return
                        }
                        
                        let rightOffsetValue = (currentItem.minX + currentItem.width) + (nextItem.minX + nextItem.width)
                        let leftOffsetValue = currentItem.minX - (firstItem.minX + firstItem.width) - 20
                        
                        debugPrint("rightOffset: \(rightOffsetValue)")
                        debugPrint("leftOffset: \(leftOffsetValue)")
                        
                        withAnimation {
                            if rightOffsetValue >= UIScreen.main.bounds.width && newValue.index > currentIndex {
                                scrollProxy.scrollTo(newValue.index + 1)
                            }
                            else if leftOffsetValue <= 0 && newValue.index < currentIndex
                            {
                                scrollProxy.scrollTo(newValue.index - 1)
                            }
                        }
                    }
                    currentIndex = newValue.index
                }
            }
        }
        .background(Color.red)
        .edgesIgnoringSafeArea(.top)
    }
    
    @ViewBuilder
    func LineView() -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: indicatorWidth, height: 2)
            .offset(x: indicatorPosition, y: -3)
    }
}

struct Layout {
    
    static var SafeAreaTopHeight: CGFloat {
        get {
            let top = UIApplication.shared.windows.first?.safeAreaInsets.top
            return top ?? 0
        }
    }
    
    static var SafeBottomHeight: CGFloat {
        get {
            let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom
            return bottom ?? 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
