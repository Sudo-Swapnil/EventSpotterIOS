import SwiftUI
import SimpleToast
import Alamofire
import SwiftyJSON
import Kingfisher

class EventDetailTabState: ObservableObject {
    @Published var isEventAPIComplete = false
}

struct EventDetail: View {
    var eventIdInfo: String
    @StateObject var eventDetailTabState = EventDetailTabState()
    @Binding var artistsInfoString: String
    @Binding var isEventMusicRelated: Bool
    @EnvironmentObject var favorites: Favorites
    @State private var title = ""
    @State private var date = ""
    @State private var artist = ""
    @State private var venue = ""
    @State private var genre = ""
    @State private var price = ""
    @State private var status = "Onsale"
    @State private var imageUrl = "https://i.scdn.co/image/ab6761610000e5eb854b6139b96beb6dbc398e06"
    @State private var toastText = "Added to Favorites"
    @State private var fbLink = "https://www.example.com"
    @State private var twitterLink = "https://www.example.com"
    @State private var ticketMasterLink = "https://www.example.com"
    @State private var displayToast = false
    @State private var isEventFavorite = false
    @State private var statusColor: Color = .green
    @State var currEventForFavorite: Event
    
    private let toastOptions = SimpleToastOptions(
            hideAfter: 2
        )
    
    var body: some View {
        
        VStack {
            
            if eventDetailTabState.isEventAPIComplete {
                VStack {
                    Group {
                        Text(title)
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 3.0)
                        Group {
                            HStack() {
                                VStack(alignment: .leading) {
                                    if date != "" {
                                        Text("Date")
                                            .font(.title3)
                                            .bold()
                                        Text(date)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                VStack(alignment: .trailing) {
                                    if artist != "" {
                                        Text("Artist | Team")
                                            .font(.title3)
                                            .bold()
                                        Text(artist)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                            }
                        }
                        .padding(.bottom, 2.0)
                        
                        Group {
                            HStack() {
                                if venue != ""{
                                    VStack(alignment: .leading) {
                                        Text("Venue")
                                            .font(.title3)
                                            .bold()
                                        Text(venue)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    if genre != "" {
                                        Text("Genre")
                                            .font(.title3)
                                            .bold()
                                        Text(genre)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                            }
                        }
                        .padding(.bottom, 2.0)
                        
                        Group {
                            HStack() {
                                if price != "" {
                                    VStack(alignment: .leading) {
                                        Text("Price Range")
                                            .font(.title3)
                                            .bold()
                                        Text(price)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                VStack(alignment: .trailing) {
                                    if status != "" {
                                        Text("Ticket Status")
                                            .font(.title3)
                                            .bold()
                                        Text(status)
                                            .foregroundColor(.white)
                                            .frame(width: 100, height: 28)
                                            .background(statusColor) //TODO: add variable to control color of the text bg
                                            .cornerRadius(8)
                                    }
                                    
                                }
                                
                            }
                        }
                        .padding(.bottom, 2.0)
                        
                    }
                    
                    Group {
                        Button(!isEventFavorite ? "Save Event" : "Remove From Favorite"){
                            print("Button Clicked")
                            if !isEventFavorite{
                                favorites.addFavoriteEvent(event: self.currEventForFavorite)
                                isEventFavorite.toggle()
                            }
                            else {
                                isEventFavorite.toggle()
                                favorites.deleteFavoriteEvent(event: self.currEventForFavorite)
                            }
                            //                    print("SOME: ", self.currEventForFavorite)
                            
                            print("This is favorites: ", favorites.favoriteEvents)
                            displayToast.toggle()
                            
                        }
                        .frame(maxWidth: 130, maxHeight: 50)
                        .background(!isEventFavorite ? Color.blue : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.top, 8)
                        
                        
                        
                        
                        
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .foregroundColor(Color.orange)
                            .frame(width: 250, height: 250)
                            .padding()
                        
                        HStack {
                            Text("Buy Ticket At: ")
                                .bold()
                            Link(destination: URL(string: ticketMasterLink)!) {
                                Text("Ticketmaster")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        HStack {
                            Text("Share on: ")
                                .bold()
                            Link(destination: URL(string: fbLink)!) {
                                Image("facebook")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                            Link(destination: URL(string: twitterLink)!) {
                                Image("twitter")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        }
                        
                    }
                    
                    
                }
                .padding(.horizontal)
                .simpleToast(isShowing: $displayToast, options: toastOptions) {
                    HStack {
                        Text(isEventFavorite ? "Added to favorites." : "Removed from favorites" )
                    }
                    .padding(40)
                    .background(Color.gray.opacity(0.6))
                    .foregroundColor(Color.black)
                    .cornerRadius(10)
                    .position(x:200, y:640)
                    
                }
            }
            else {
                ProgressView("Please wait...")
            }
        
        }.onAppear(perform: loadEventData)
    }
    
    func loadEventData() {
        self.isEventFavorite = favorites.favoriteEvents.contains { event in
            event.id == eventIdInfo
            }
        
        
        var nodeURL = "https://csci571-160797.wl.r.appspot.com/api/getEventInfo" + "?eventId=\(eventIdInfo)"
        print(nodeURL)
        AF.request(nodeURL).responseJSON { response in
//        AF.request("http://localhost:3000/api/eventinfo").responseJSON { response in
            switch response.result {
            case .success(let value):
                print("ALL OK")
                let json = JSON(value)
                let seatmap = json["seatmap"]["staticUrl"].stringValue
                print("SEAT MAP: ", seatmap)
                if seatmap != "" {
                    self.imageUrl = json["seatmap"]["staticUrl"].stringValue
                }
                else {
                    self.imageUrl = "https://t3.ftcdn.net/jpg/04/34/72/82/240_F_434728286_OWQQvAFoXZLdGHlObozsolNeuSxhpr84.jpg"
                }
                print("IMAGE URL: ", self.imageUrl)
                self.genre = getGenre(genreObj: json["classifications"][0]) 
                self.status = setStatus(statusObj: json["dates"]["status"]["code"].stringValue)
                self.date = json["dates"]["start"]["localDate"].stringValue
//
                self.ticketMasterLink = json["url"].stringValue
                self.venue = json["_embedded"]["venues"][0]["name"].stringValue
                self.title = json["name"].stringValue
                self.fbLink = "https://www.facebook.com/sharer/sharer.php?u=\(self.ticketMasterLink)&amp;src=sdkpreparse"
                self.twitterLink = "http://twitter.com/share?url=\(self.ticketMasterLink)"
                self.artist = getArtists(artistObj: json["_embedded"]["attractions"])
                print("ARTIST IN SELF.ARTIST: ", self.artist)
                if json["classifications"][0]["segment"]["name"].stringValue == "Music" {
                    self.isEventMusicRelated = true
                    DispatchQueue.main.async {
                        self.artistsInfoString = self.artist
                        print("1. ARTIST UPDATED: ", self.artistsInfoString)
                        print("2. ARTIST UPDATED: ", self.artist)
                        self.$artistsInfoString.wrappedValue = self.artistsInfoString
                    }
                }
                
                self.currEventForFavorite = Event(id: self.eventIdInfo, date: self.date, name: self.title, genre: self.genre, venue: self.venue)
                
                eventDetailTabState.isEventAPIComplete = true
//                print(json)
            
            case .failure(let error):
                print("SOMETHING WRONG IN URL")
                print(error.localizedDescription)
            }
        }
    }
    
    func getGenre(genreObj: JSON) -> String {
        let temp1 = genreObj["segment"]["name"].stringValue
        let temp2 = genreObj["genre"]["name"].stringValue
        let temp3 = genreObj["subGenre"]["name"].stringValue
        let temp4 = genreObj["type"]["name"].stringValue
        let temp5 = genreObj["subType"]["name"].stringValue
        
        var genArray = [String]()
        
        if temp1 != "" && temp1.lowercased() != "undefined" {
            genArray.append(temp1)
        }
        
        if temp2 != "" && temp2.lowercased() != "undefined" {
            genArray.append(temp2)
        }
        
        if temp3 != "" && temp3.lowercased() != "undefined" {
            genArray.append(temp3)
        }
        
        if temp4 != "" && temp4.lowercased() != "undefined" {
            genArray.append(temp4)
        }
        
        if temp4 != "" && temp4.lowercased() != "undefined" {
            genArray.append(temp4)
        }
        
        if temp5 != "" && temp5.lowercased() != "undefined" {
            genArray.append(temp5)
        }
        
        return genArray.joined(separator: " | ")

    }
    
    func setStatus(statusObj: String) -> String {
          if (statusObj == "onsale") {
              self.status = "On Sale"
              setStatusColor()
              return "On Sale"
          }

          else if (statusObj == "offsale") {
              self.status = "Off Sale"
            setStatusColor()
            return "Off Sale"
          }

          else if (statusObj == "cancelled") {
            self.status = "Cancelled"
            setStatusColor()
            return "Cancelled"
          }

          else if (statusObj == "postponed") {
              self.status = "Postponed"
              setStatusColor()
              return "Postponed"
          }

          else if (statusObj == "rescheduled") {
              self.status = "Rescheduled"
              setStatusColor()
              return "Rescheduled"
          }
          else {
            self.status = ""
            setStatusColor()
            return ""
          }
        
        
    }
    
    func setStatusColor() {
        if status == "On Sale" {
            self.statusColor = .green
        }
        else if status == "Off Sale" {
            self.statusColor = .red
        }
        else if status == "Cancelled" {
            self.statusColor = .black
        }
        else if status == "Postponed" {
            self.statusColor = .orange
        }
        else if status == "Rescheduled" {
            self.statusColor = .orange
        }
        else {
            self.statusColor = .green
        }
    }
 
    func getArtists(artistObj: JSON) -> String {
        var artistsArray = [String]()
        
        for (_, subJson):(String, JSON) in artistObj {
                if let name = subJson["name"].string {
                    artistsArray.append(name)
                }
            }
        print("--- FROM GET ARTIST FUNCTION: ", artistsArray)
        let result = artistsArray.joined(separator: "|")
        print(result)
        return result
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        let favorites = Favorites()
        let artistsInfo = Binding<String>(get: { return "" }, set: { _ in })
        let isEventMusicRelated = Binding<Bool>(get: { return false }, set: { _ in })
        EventDetail(eventIdInfo: "abc123", artistsInfoString: artistsInfo, isEventMusicRelated: isEventMusicRelated, currEventForFavorite: Event(id: "abc123", date: "123", name: "123", genre: "123", venue: "123"))
            .environmentObject(favorites)
    }
}

struct EventInfo: Identifiable {
    let id: String
    let date: String
    let artists: String
    let venue: String
    let genre: String
    let price: String
    let status: String
    let fbLink: String
    let twitterLink: String
    let name: String
    let seatMapLink: String
    let ticketLink: String
}
