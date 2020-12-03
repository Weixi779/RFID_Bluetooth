//
//  NavigationViewUI.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/26.
//

import SwiftUI

struct ViewModifierUI: ViewModifier {
        
    var backgroundColor: UIColor?
    
    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

struct clippedCapsule_I: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17.5, weight: .bold, design: .default))
            .foregroundColor(Color(.white))
            .padding(.vertical)
            .padding(.horizontal,45)
            .background(Color("ButtonColor"))
            .clipShape(Capsule())
    }
}

struct clippedCapsule_II: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .bold, design: .default))
            .foregroundColor(Color("ButtonColor"))
            .padding(.vertical)
            .padding(.horizontal,45)
            .background(Color(.white))
            .clipShape(Capsule())
    }
}

struct HiddenNGB:ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Home"))
            .edgesIgnoringSafeArea([.top, .bottom])
    }
}

extension View {
 
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(ViewModifierUI(backgroundColor: backgroundColor))
    }
    
    func clipedCapsule_I() -> some View{
        self.modifier(clippedCapsule_I())
    }

    func clipedCapsule_II() -> some View{
        self.modifier(clippedCapsule_II())
    }

    func hiddenNGB() -> some View{
        self.modifier(HiddenNGB())
    }
}

