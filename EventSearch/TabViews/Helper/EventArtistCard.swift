//
//  EventArtistCard.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/28/23.
//

import SwiftUI

struct EventArtistCard: View {
    @State private var artist = "Ed Sheeran"
    @State private var followers = "110M"
    @State private var popularity = "93"
    
    var body: some View {
        VStack{
            Group {
                HStack{
                    Image(systemName: "airpods")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 100, height: 100)
                        .background(.yellow)
                        .cornerRadius(17)
                    Spacer()
                    VStack {
                        Text(artist)
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                        HStack {
                            Text(followers)
                                .foregroundColor(.white)
                                .bold()
                            Text("Followers")
                                .foregroundColor(.white)
                        }.padding(.top, 2)
                        HStack {
                            Image("spotify")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("Spotify")
                                .foregroundColor(.green)
                        }
                    }.padding(.top)
                    Spacer()
                    VStack{
                        Text("Popularity")
                            .foregroundColor(.white)
                            .font(.headline)
//                        CircleProgress()
                        Spacer()
                    }.padding(.top)
                }
            }
            .padding(.horizontal)
            
            Group{
                VStack {
                    HStack {
                        Text("Popular Albums")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 95, height: 95)
                            .background(.yellow)
                            .cornerRadius(17)
                            .padding(.bottom)
                        Spacer()
                        
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 95, height: 95)
                            .background(.yellow)
                            .cornerRadius(17)
                            .padding(.bottom)
                        Spacer()
                        
                        Image(systemName: "ipod")
                            .resizable()
                            .frame(width: 95, height: 95)
                            .background(.yellow)
                            .cornerRadius(17)
                            .padding(.bottom)
                    }
                    
                }
            }
            .padding(.horizontal)
        }
        .frame(width: 380, height: 290)
        .background(Color(red: 76/255, green: 76/255, blue: 76/255))
        .cornerRadius(25)
//        .padding(.bottom, 25)
        
    }
}

struct EventArtistCard_Previews: PreviewProvider {
    static var previews: some View {
        EventArtistCard()
    }
}
