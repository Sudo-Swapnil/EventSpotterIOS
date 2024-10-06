//
//  CircleProgress.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/28/23.
//

import SwiftUI

struct CircleProgress: View {
    var progress: Double
//    @State var progress: Double = 0.79
    var body: some View {
        ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .foregroundColor(Color(red: 180/255, green: 121/255, blue: 0/255))
                        
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 15))
                        .rotationEffect(Angle(degrees: 0))
                        .foregroundColor(Color(red: 252/255, green: 165/255, blue: 3/255))
            
                    Text(String(format: "%.0f%", (progress * 100)))
                            .font(.title)
                            .foregroundColor(.white)
//                            .foregroundColor(Color.gray)
                }
                .frame(width: 70, height: 70, alignment: .center)
    }
}

struct CircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgress(progress: 0.50)
    }
}
