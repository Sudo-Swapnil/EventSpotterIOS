//
//  EventTabMenu.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/28/23.
//

import SwiftUI

struct EventTabMenu: View {
    var eventIdInfo: String
    var eventTitleInfo: String
    var eventVenueInfo: String
    @State private var artistsInfoString: String = "Ed Sheeran|Russ|Maisie Peters"
    @State private var isEventMusicRelated: Bool = false
    

    
    var body: some View {
        TabView {
            let favorites = Favorites()
            let artistsInfo = Binding<String>(get: { return "" }, set: { _ in })
            
            EventDetail(eventIdInfo: eventIdInfo, artistsInfoString: artistsInfo, isEventMusicRelated: $isEventMusicRelated, currEventForFavorite: Event(id: "abc123", date: "123", name: "123", genre: "123", venue: "123"))
                .environmentObject(favorites)
                .tabItem {
                    Label("Events", systemImage: "text.bubble")
                }
            EventArtist(artistsInfoString: artistsInfoString, isEventMusicRelated: self.isEventMusicRelated)
                .tabItem {
                    Label("Artist/Team", systemImage: "guitars")
                }
            EventVenue(eventTitle: eventTitleInfo, venueNameInfo: eventVenueInfo.replacingOccurrences(of: " ", with: "+"))
                .tabItem {
                    Label("Venue", systemImage: "location")
                }
        }
    } 
}

struct EventTabMenu_Previews: PreviewProvider {
    static var previews: some View {
        EventTabMenu(eventIdInfo: "abc123", eventTitleInfo: "Ed Shereen!", eventVenueInfo: "Los+Angeles+Memorial+Coliseum")
    }
}
