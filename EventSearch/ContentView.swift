//
//  ContentView.swift
//  EventSearch
//
//  Created by Swapnil Chhatre on 4/27/23.
//

import SwiftUI
import Alamofire
import SwiftyJSON



class SuggestionsState: ObservableObject {
    @Published var isSuggestAPIComplete = false
}

struct ContentView: View {
    @StateObject private var favorites = Favorites()
    @StateObject var suggestionsState = SuggestionsState()
    @State var suggestions: [TypeAhead] = []
    @State private var showMainScreen = false
    @State var category: String = "Default"
    @State private var detectLocation = false
    @State private var distance = "10"
    @State private var keyword = ""
    @State private var location = ""
    @State private var showLocationField = true
    
    private var allowSubmit: Bool {
        return !location.isEmpty && !query.isEmpty && !distance.isEmpty
    }
    @State private var showTable = false
    @State private var refreshTable = false
    @State private var data = true
    
    @State private var query: String = ""
    @State private var showResults = false
    @State private var selectedResult: String?
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: FavoritesView().environmentObject(Favorites())) {
                                Image(systemName: "heart.circle")
                                    .font(.largeTitle)
                                    .padding(.top, -30)
                                    .padding(.bottom, 20)
                            }
                        }
                        
                        VStack {
                            Group {
                                HStack{
                                    Text("Keyword:")
                                        .foregroundColor(.gray)
                                    TextField("Required", text: $query, onCommit: {
                                        self.suggestKeyword()
                                    })
                                }
                                .sheet(isPresented: $showResults) {
                                    
                                    if suggestionsState.isSuggestAPIComplete {
                                        
                                        VStack {
                                            Text("Suggestions")
                                                .font(.title)
                                                .multilineTextAlignment(.center)
                                                .padding(.top, 20)
                                                .bold()
                                            List (suggestions) { suggestion in
                                                Text(suggestion.name)
                                                    .onTapGesture {
                                                        self.query = suggestion.name
                                                        self.showResults = false
                                                        suggestions = []
                                                    }
                                                
                                            }
                                        }
                                    } else {
                                        VStack {
                                            ProgressView("Please wait")
                                        }
                                    }
                                }
                                
                                Divider()
                            }
                            
                            
                            Group {
                                HStack{
                                    Text("Distance:")
                                        .foregroundColor(.gray)
                                    TextField("Event Keyword", text: $distance)
                                        .keyboardType(.numberPad)
                                }
                                Divider()
                            }
                            
                            
                            Group {
                                HStack{
                                    Text("Category:")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Picker(selection: $category,
                                       label: Text("Picker"),
                                       content: {
                                            Text("Default").tag("Default")
                                            Text("Music").tag("Music")
                                            Text("Sports").tag("Sports")
                                            Text("Arts & Theatre").tag("Arts & Threatre")
                                            Text("Films").tag("Films")
                                            Text("Miscellanoeus").tag("Miscellanoeus")
                                        })
                                }
                                Divider()
                            }
                            
                            
                            if showLocationField {
                                Group {
                                    HStack{
                                        Text("Location:")
                                            .foregroundColor(.gray)
                                        TextField("Required", text: $location)
                                    }
                                    Divider()
                                }
                            }
                            
                            
                            Group {
                                HStack{
                                    Toggle(isOn: $detectLocation) {
                                        Text("Auto-detect my loction:")
                                            .foregroundColor(.gray) 
                                    }
                                    .onChange(of: detectLocation) { value in
                                        showLocationField = !value
                                        if value == true{
                                            self.location = "Los Angeles"
                                        }
                                        else {
                                            self.location = ""
                                        }
                                        
                                    }

                                }
                                Divider()
                            }
                            
                            HStack {
                                Spacer()
                                Button("Submit"){
                                    self.showTable = false
                                    print("Submitted clicked!")
                                    print("Keyword: ", query)
                                    print("Category: ", category)
                                    print("Location: ", location)
                                    print("Distance: ", distance)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            self.showTable = true
                                            print("Show table: ", self.showTable)
                                        }
                                }
                                .frame(width: 120, height: 50)
                                .background(allowSubmit ? .red : .gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .disabled(!allowSubmit)
                                          
                                Spacer()
                                Button("Clear"){
                                    selectedResult = ""
                                    query = ""
                                    category = "Default"
                                    keyword = ""
                                    distance = "10"
                                    location = ""
                                    detectLocation = false
                                    showTable = false
                                }
                                .frame(width: 120, height: 50)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                Spacer()
                            }
                            .padding(.vertical)
                                            
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                    }

                    .padding(.horizontal)

                    Spacer()
                
                    if showTable {
                        EventsTable(keyword: query, distance: distance, category: category, location: location)
                            .environmentObject(favorites)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.17))
                .navigationBarTitle("Events Search")
            }
            
        }
    }
    
    private func suggestKeyword() {
        self.showResults = true
        let safeQuery = query.replacingOccurrences(of: " ", with: "+")
        let url = "https://csci571-160797.wl.r.appspot.com/api/typeAhead?value=\(safeQuery)"
//        let url = "http://localhost:3000/api/test/suggestion?=\(safeQuery)"
        print(url)
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let jsonArray = json["_embedded"]["attractions"].arrayValue
                suggestions = []
                for suggestion in jsonArray {
                    let id = UUID()
                    let attraction = suggestion["name"].stringValue
                    print(id)
                    print(attraction)
                    let currentSuggestion = TypeAhead(id: id, name: attraction)
                    suggestions.append(currentSuggestion)
                    }
                print("setting showresults to true")
                
                self.suggestionsState.isSuggestAPIComplete = true

                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// adding
struct TypeAhead : Identifiable {
    var id: UUID
    var name: String
}

struct SheetView: View {
    var suggestions: [TypeAhead]
    @Binding var selectedResult: String?
    @Binding var isPresented: Bool
    @Binding var query: String

    var body: some View {
        NavigationView {
            List(suggestions, id: \.id) { result in
                Button(action: {
                    self.selectedResult = result.name
                    self.query = result.name
                    self.isPresented = false
                }) {
                    Text(result.name)
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                UITableView.appearance()
            }
            
            .background(Color.white)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                        Text("Suggestions")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
            }
        }
        .animation(.easeInOut(duration: 0.3))
        .transition(.move(edge: .bottom))
    }
}
