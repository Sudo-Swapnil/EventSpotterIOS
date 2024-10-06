//
//  FavoriteRow.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/29/23.
//

import SwiftUI

struct FavoriteRow: View {
    
    @State private var date = "2023-09-16"
    @State private var title = "Ed Shaeeran: +-=÷x Tour"
    @State private var genre = "Music | Pop | Pop"
    @State private var venue = "Levi's® Stadium"
    
    var body: some View {
        HStack{
            Text(date)
                .frame(maxWidth: 100)
            
            Text(title)
                .frame(maxWidth: 130)
            
            Text(genre)
                .frame(maxWidth: 80)
            
            Text(venue)
                .frame(maxWidth: 80)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
    }
}

struct FavoriteRow_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRow()
    }
}
