import SwiftUI
import SwiftyJSON
import Alamofire
import Kingfisher
import Foundation

class ArtistState: ObservableObject {
    @Published var isArtistAPIComplete = false
}

struct EventArtist: View {
    
    
    @State var artists: [Artist] = []
    @StateObject var artistState = ArtistState()
    
//    @State private var isMusicRelated = true
    
    var artistsInfoString: String
    var isEventMusicRelated: Bool
    
    var body: some View {
        VStack {
            if isEventMusicRelated {
                VStack {
                    if artistState.isArtistAPIComplete {
                        VStack {
                            List(artists) { artist in
                                
                                VStack{
                                    Group {
                                        HStack{
                                            KFImage(URL(string: artist.imageURL))
                                                .resizable()
                                                .foregroundColor(.green)
                                                .frame(width: 100, height: 100)
                                                .background(.yellow)
                                                .cornerRadius(17)
                                            Spacer()
                                            VStack {
                                                Text(artist.name)
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                    .bold()
                                                HStack {
                                                    Text(artist.followers)
                                                        .foregroundColor(.white)
                                                        .bold()
                                                    Text("Followers")
                                                        .foregroundColor(.white)
                                                }.padding(.top, 2)
                                                
                                                    
                                                    Link(destination: URL(string: artist.spotifyURL)!) {
                                                        HStack {
                                                            Image("spotify")
                                                                .resizable()
                                                                .frame(width: 40, height: 40)
                                                            Text("Spotify")
                                                                .foregroundColor(.green)
                                                        }
                                                    

                                                }
                                            }.padding(.top)
                                            Spacer()
                                            VStack{
                                                Text("Popularity")
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                CircleProgress(progress: (Double(artist.popularity))! / 100)
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
                                            //                                if !artist.topAlbumsImages.isEmpty {
                                            //                                    print(self.artist.topAlbumsImages.count)
                                            HStack {
                                                KFImage(URL(string: artist.topAlbumsImages[0]))
                                                //                                        KFImage(URL(string: artist.topAlbumImages[0]))
                                                    .resizable()
                                                    .frame(width: 95, height: 95)
                                                    .background(.yellow)
                                                    .cornerRadius(17)
                                                    .padding(.bottom)
                                                Spacer()
                                                
                                                KFImage(URL(string: artist.topAlbumsImages[1]))
                                                //                                        Image(systemName: "ipod")
                                                    .resizable()
                                                    .frame(width: 95, height: 95)
                                                    .background(.yellow)
                                                    .cornerRadius(17)
                                                    .padding(.bottom)
                                                Spacer()
                                                
                                                //                                        Image(systemName: "ipod")
                                                KFImage(URL(string: artist.topAlbumsImages[2]))
                                                    .resizable()
                                                    .frame(width: 95, height: 95)
                                                    .background(.yellow)
                                                    .cornerRadius(17)
                                                    .padding(.bottom)
                                            }
                                            //                                }
                                            
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: 380, height: 290)
                                .background(Color(red: 76/255, green: 76/255, blue: 76/255))
                                .cornerRadius(25)
                            }
                        }
                        
                    }
                    else {
                        ProgressView("Please wait...")
                    }
                }.onAppear(perform: loadCard)
            }
            else if isEventMusicRelated && !artistState.isArtistAPIComplete{
                    ProgressView("Please wait...")
            }
            else {
                    Text("No music related artist details to show")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                }
        }
    }
    
    func loadCard() {
//        let dummyartists = "Maroon 5|Ellie Goulding"
        let dummyartists = artistsInfoString
        print("ARTIST STRING: ", dummyartists)
        let parameters: Parameters = [
                "artists": dummyartists
                ]
//        let encodedArtists = dummyartists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let nodeURL = "https://csci571-160797.wl.r.appspot.com/api/spotify"
        
        
        
//        AF.request("http://localhost:3000/api/test/artist").responseJSON { response in
        AF.request(nodeURL, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("in SUCCESS!")
                print(nodeURL)
                //
                let json = JSON(value)
                let jsonArray = json.arrayValue
                var artists = [Artist]()
                let dispatchGroup = DispatchGroup()
                for artist in jsonArray {
                    let id = artist["id"].stringValue
                    dispatchGroup.enter()
                    loadTopAlbums(id: id) { topAlbumsImages in
                        let name = artist["name"].stringValue
                        let followers = formatFollowerCount(followers: artist["followers"]["total"].stringValue)
                        let popularity = artist["popularity"].stringValue
                        let spotifyURL = artist["external_urls"]["spotify"].stringValue
                        let imageURL = artist["images"][0]["url"].stringValue
                        let artist = Artist(id: id, name: name, followers: followers, popularity: popularity, spotifyURL: spotifyURL, imageURL: imageURL, topAlbumsImages: topAlbumsImages)
                        artists.append(artist)
                        
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    self.artists = artists
                    print(artists)
                }
                artistState.isArtistAPIComplete = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func loadTopAlbums(id: String, completion: @escaping ([String]) -> Void) {
        let url = "https://csci571-160797.wl.r.appspot.com/api/spotify/topAlbums?artistId=\(id)"
        var topAlbumImages = [String]()
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for i in 0...2 {
                    var temp = json["items"][i]["images"][1]["url"].stringValue
                    if temp != "" {
                        topAlbumImages.append(temp)
                    }
                }
                print("call successful!")
                print(topAlbumImages)
                completion(topAlbumImages)
            case .failure(let error):
                print(error.localizedDescription)
                completion(topAlbumImages)
            }
        }
    }

    
//    func loadCard() {
//        AF.request("http://localhost:3000/api/test/artist").responseJSON { response in
//                        switch response.result {
//                        case .success(let value):
//                            //
//                            let json = JSON(value)
//                            let jsonArray = json.arrayValue
//                            self.artists = jsonArray.map { artist in
//                                let id = artist["id"].stringValue
//                                let topAlbumsImages = loadTopAlbums(id: id)
//                                let name = artist["name"].stringValue
//                                let followers = formatFollowerCount(followers: artist["followers"]["total"].stringValue)
//                                let popularity = artist["popularity"].stringValue
//                                let spotifyURL = artist["external_urls"]["spotify"].stringValue
//                                let imageURL = artist["images"][0]["url"].stringValue
//
////                                self.topAlbumImages = loadTopAlbums(id: id)
//                                return Artist(id: id, name: name, followers: followers, popularity: popularity, spotifyURL: spotifyURL, imageURL: imageURL, topAlbumsImages: topAlbumsImages)
//                            }
//                        case .failure(let error):
//                            print(error.localizedDescription)
//                        }
//                    }
//
//    }
    
    func formatFollowerCount(followers count: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        let countInt = Int(count) ?? 0
        if countInt < 1000 {
            // handling for not even 1000
            return "\(countInt)"
        } else if countInt < 1000000 {
            // handling for less than 1 million
            let value = Double(countInt) / 1000.0
            let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
            return "\(formattedValue)K"
        } else {
            // any value over 1M
            let value = Double(countInt) / 1000000.0
            let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
            return "\(formattedValue)M"
        }
    }
    
//    func loadTopAlbums(id: String) -> [String]{
//        let url = "http://localhost:3000/api/spotify/topAlbums?artistId=\(id)"
//        var topAlbumImages = [String]()
//        AF.request(url).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//
//                for i in 0...2 {
//                    var temp = json["items"][i]["images"][1]["url"].stringValue
//                    if temp != "" {
//                        topAlbumImages.append(temp)
//                    }
//                }
//                print("call successful!")
//                print(topAlbumImages)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        return topAlbumImages
//    }
    
}

struct EventArtist_Previews: PreviewProvider {
    static var previews: some View {
        EventArtist(artistsInfoString: "Ed Sheeran", isEventMusicRelated: true)
    }
}

struct Artist: Identifiable {
    let id: String
    let name: String
    let followers: String
    let popularity: String
    let spotifyURL: String
    let imageURL: String
    let topAlbumsImages: [String]
}

//struct ArtistAlbum: Identifiable {
//    let id: UUID
//    let imageURL: String
//}
