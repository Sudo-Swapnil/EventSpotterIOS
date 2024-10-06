//
//  Favorites.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/29/23.
//

import SwiftUI

class Favorites: ObservableObject {
    @AppStorage("favoriteEvents") var favoriteEventsData: Data = Data()
    @Published var favoriteEvents: [Event] = []

    init() {
        loadFavoriteEvents()
//        #if DEBUG
//        if favoriteEvents.isEmpty {
//            favoriteEvents.append(Event(id: "1", date: "2023-05-10", name: "Test Event", genre: "Test Genre", venue: "Test Venue"))
//            saveFavoriteEvents()
//        }
//        #endif
    }

    func addFavoriteEvent(event: Event) {
        print("Executing in addFavorites function")
        favoriteEvents.append(event)
        print("Appended favorites")
        saveFavoriteEvents()
    }

    func deleteFavoriteEvent(event: Event) {
        if let index = favoriteEvents.firstIndex(of: event) {
            favoriteEvents.remove(at: index)
            saveFavoriteEvents()
        }
    }

    private func saveFavoriteEvents() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoriteEvents)
            favoriteEventsData = data
        } catch {
            print("\(error.localizedDescription)")
        }
    }

    private func loadFavoriteEvents() {
        do {
//            print("Decoder running...")
            let decoder = JSONDecoder()
            let events = try decoder.decode([Event].self, from: favoriteEventsData)
            favoriteEvents = events
//            print(favoriteEvents)
        } catch {
            print("Error loading favorite events: \(error.localizedDescription)")
        }
    }
}


struct FavoritesView: View {
    
    @EnvironmentObject var favorites: Favorites
    
    var body: some View {
        NavigationView {
            Group {
                if favorites.favoriteEvents.isEmpty {
                    Text("No favorites found")
                        .font(.title2)
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(favorites.favoriteEvents) { event in
                            HStack{
                                Text(event.date)
//                                    .frame(maxWidth: 120)
                                Spacer()
                                Text(event.name)
//                                    .frame(maxWidth: 130)
                                Spacer()
                                Text(event.genre)
//                                    .frame(maxWidth: 80)
                                Spacer()
                                Text(event.venue)
                            }
                                
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                favorites.deleteFavoriteEvent(event: favorites.favoriteEvents[index])
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Favorites")
            Spacer()
        }
    }
}

struct Event: Identifiable, Codable, Equatable {
    var id: String
    var date: String
    var name: String
    var genre: String
    var venue: String
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(Favorites())
    }
}






