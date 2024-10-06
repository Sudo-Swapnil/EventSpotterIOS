import SwiftUI
import Alamofire
import SwiftyJSON
import Kingfisher

class TableState: ObservableObject {
    @Published var isTableAPIComplete = false
}

struct EventsTable: View {
    
    @State var eventTableItems: [EventTableItem] = []
    
    @StateObject var tableState = TableState()
    
    var keyword: String
    var distance: String
    var category: String
    var location: String

    
    var body: some View {
        
        VStack {

            
            VStack {
                if tableState.isTableAPIComplete && !eventTableItems.isEmpty {
                    List{
                        Section("Result") {
                            
                            ForEach(eventTableItems) { eventRowData in
                                
                                
                                NavigationLink(destination: EventTabMenu(eventIdInfo: eventRowData.id, eventTitleInfo: eventRowData.title, eventVenueInfo: eventRowData.venue.replacingOccurrences(of: " ", with: "+"))) {
                                    HStack {
                                        Text(eventRowData.dateTime)
                                            .foregroundColor(Color.secondary)
                                        //                            .frame(maxWidth: 100, maxHeight: 80)
                                        Spacer()
                                        KFImage(URL(string: eventRowData.imageURL))
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                        
                                        Spacer()
                                        Text(eventRowData.title)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: 100, maxHeight: 80)
                                        
                                        Spacer()
                                        Text(eventRowData.venue)
                                            .foregroundColor(Color.secondary)
                                            .frame(maxWidth: 120, maxHeight: 80)
                                        //                            .frame(maxWidth: 80, maxHeight: 80)
                                        Spacer()
                                        
                                    }
                                    
                                    .padding(.vertical, 0)
                                }
                            }
                            
                        }
                        
                    }
                    .navigationTitle("Events Search")
                    
                }
                
                else if tableState.isTableAPIComplete && eventTableItems.isEmpty {
                    VStack {
                        VStack {
                            HStack {
                                Text("Results")
                                    .font(.title)
                                    .padding(.horizontal, 20)
                                Spacer()
                            }
                                Divider()
                                HStack {
                                    Text("No results available")
                                        .foregroundColor(.red)
                                    Spacer()
                                }.padding(.horizontal)
                        }
//                        .background(.gray)
                        .padding(.all)
                    }
                    
                    
                    
                }
                else {
                    VStack {
                        VStack {
                            HStack {
                                Text("Results")
                                    .font(.title)
                                    .padding(.horizontal, 20)
                                Spacer()
                            }
                                Divider()
                                ProgressView("Please Wait")
                        }
                        .padding(.all)
                    }
                    
                }
            }
            .onAppear(perform: loadData)
        }
        
    }
    
    func loadData() {
//        let nodeURL = "http://localhost:3000/api/test/table/taylor"
//        let nodeURL = "http://localhost:3000/api/getTableInformation"
        let nodeURL = "https://csci571-160797.wl.r.appspot.com/api/getTableInformation"
        let parameters: Parameters = [
            "keyword": keyword,
            "distance": distance,
            "category": category,
            "location": location,
            "autolocation": ""
            ]
        print(parameters)
        print(nodeURL)
        //http://localhost:3000/api/getTableInformation?keyword=%22Taylor+Swift%22&distance=1000&category=Default&location=Los+Angeles&autolocation=
//        AF.request(nodeURL).responseJSON { response in
            AF.request(nodeURL, parameters: parameters).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("TABLES: ALL OK")
                    //
                    let json = JSON(value)
                    print("THIS IS PRINTED!")
                    let jsonArray = json.arrayValue
                    self.eventTableItems = jsonArray.map { eventItem in
                        let title = eventItem["name"].stringValue
                        let id = eventItem["id"].stringValue
                        let date = eventItem["dates"]["start"]["localDate"].stringValue
                        let time = eventItem["dates"]["start"]["localTime"].stringValue
                        let dateTime = date + "|" + time
                        let imageURL = eventItem["images"][0]["url"].stringValue
                        let venue = eventItem["_embedded"]["venues"][0]["name"].stringValue
                        return EventTableItem( id: id, dateTime: dateTime,  imageURL: imageURL, title: title, venue: venue)
                    }
                    print("Reaching here")
                    print(self.eventTableItems)
                    tableState.isTableAPIComplete = true
                    
                case .failure(let error):
                    print("TABLES: SOMETHING WENT WRONG")
                    print(response.data)
                    print(error.localizedDescription)
                    tableState.isTableAPIComplete = true
                }
            }
        }
}

struct EventsTable_Previews: PreviewProvider {
    static var previews: some View {
        EventsTable(keyword: "Ed Sheeran!", distance: "1000", category: "Default", location: "Los Angeles")
    }
}

struct EventTableItem: Identifiable {
    let id: String
    let dateTime: String
    let imageURL: String
    let title: String
    let venue: String
}
