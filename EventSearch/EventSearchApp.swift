//
//  EventSearchApp.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/27/23.
//

import SwiftUI

@main
struct EventSearchApp: App {
    @StateObject private var favorites = Favorites()
    var body: some Scene {
        WindowGroup {
            
//            EventsTable()
            
//            EventTabMenu(eventIdInfo: "abc123", eventTitleInfo: "Ed Shereen!", eventVenueInfo: "Los+Angeles+Memorial+Coliseum")
            
            
//            let artistsInfo = Binding<String>(get: { return "" }, set: { _ in })
//            let isEventMusicRelated = Binding<Bool>(get: { return false }, set: { _ in })
//            EventDetail(eventIdInfo: "rZ7HnEZ1AKZ8PP", artistsInfoString: artistsInfo, isEventMusicRelated: isEventMusicRelated, currEventForFavorite: Event(id: "rZ7HnEZ1AKZ8PP", date: "123", name: "123", genre: "123", venue: "123"))
//                .environmentObject(favorites)
            
//            EventArtist(artistsInfoString: "Ed Sheeran|Taylor Swift", isEventMusicRelated: true)
//            EventVenue(eventTitle: "Ed Sheeran: +-=÷x Tour", venueNameInfo: "galen+center")
//            EventVenue()
//            EventDetail()
//            EventTabMenu()
//            EventsTable(keyword: "Ed Sheeran", distance: "100", category: "Default", location: "Los Angeles")
            ContentView()
                .environmentObject(favorites)
        }
    }
}
