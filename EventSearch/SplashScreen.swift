//
//  SplashScreen.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 5/1/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Image("launchScreen")
            Spacer()
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
