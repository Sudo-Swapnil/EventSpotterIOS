import SwiftUI
import Alamofire
import SwiftyJSON
import MapKit

class VenueState: ObservableObject {
    @Published var isVenueAPIComplete = false
}

struct MapView: UIViewRepresentable {
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                // no annotation
                annotationView?.canShowCallout = true
            }
            else {
                // Some annotation
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
    
    let coordinate: CLLocationCoordinate2D
    
    @Binding var isPresented: Bool
    
    // update UI View
    func updateUIView(_ view: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.removeAnnotations(view.annotations)
        view.addAnnotation(annotation)
        view.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
    }
    
    // update UI View
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    

}

struct EventVenue: View {
    
//    let latitude = 37.7749
//    let longitude = -122.4194
    
    
    @State private var dragOffset = CGSize.zero
    @StateObject var venueState = VenueState()
    var eventTitle: String
    var venueNameInfo: String
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    @State private var venueName = "Levi's® Stadium"
    @State private var address = "4900 Marie P. DeBartolo Way"
    @State private var phoneNumber = "415-GO-49ERS (415-464-9377)"
    @State private var openHours = "9AM to 5PM Monday through Friday."
    @State private var generalRules = "9AM to 5PM Monday through Friday.9AM to 5PM Monday through Friday.9AM to 5PM Monday through Friday.9AM to 5PM Monday through Friday.9AM to 5PM Monday through Friday.9AM to 5PM Monday through Friday.9AM to 5PM Monday through Friday."
    @State private var childRules = "LE"
    
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            
            if venueState.isVenueAPIComplete {
                VStack {
                    if eventTitle != "" {
                        Text(eventTitle)
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                    }
                    
                    Group {
                        VStack {
                            if venueName != "" {
                                Text("Name")
                                    .font(.title3)
                                    .bold()
                                Text(venueName)
                                    .foregroundColor(.secondary)
                                
                            }
                            
                        }.padding(.vertical,5)
                    }
                    
                    Group {
                        VStack {
                            if address != "" {
                                Text("Address")
                                    .font(.title3)
                                    .bold()
                                Text(address)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical,5)
                    }
                    
                    Group {
                        VStack {
                            if phoneNumber != "" {
                                Text("Phone Number")
                                    .font(.title3)
                                    .bold()
                                Text(phoneNumber)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical,5)
                    }
                    
                    Group {
                        VStack {
                            if openHours != "" {
                                Text("Open Hours")
                                    .font(.title3)
                                    .bold()
                                Text(openHours)
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                        .padding(.vertical,5)
                        .padding(.bottom, 40)
                    }
                    
                    Group {
                        VStack {
                            if generalRules != "" {
                                Text("General Rules")
                                    .font(.title3)
                                    .bold()
                                ScrollView {
                                    Text(generalRules)
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(height: 65)
                                .padding(.horizontal)
                            }
                        }
                        
                    }
                    .padding(.bottom, 10)
                    
                    Group {
                        VStack {
                            if childRules != "" {
                                Text("Child Rule")
                                    .font(.title3)
                                    .bold()
                                //                        .padding(.vertical, 0)
                                ScrollView {
                                    Text(generalRules)
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(height: 65)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    Spacer()
                    Button("Show venue on maps"){
                        print("Maps button clicked!")
                        self.isPresented.toggle()
                    }
                    .frame(width: 170, height: 50)
                    .padding(.horizontal)
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    //attaching sheet
                    .sheet(isPresented: $isPresented, onDismiss: {
                        dragOffset = .zero
                    }, content: {
                        ZStack(alignment: .top) {
                            MapView(coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), isPresented: $isPresented)
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            // tracking gesture to add dropping effect
                                            dragOffset = gesture.translation
                                        }
                                        .onEnded { gesture in
                                            // exitting the sheet if dragging more than 120 px
                                            if dragOffset.height > 120 {
                                                isPresented = false
                                            }
                                            dragOffset = .zero
                                        }
                                )
                                .padding()
                                .offset(y: max(dragOffset.height, 0))
                                .animation(.easeInOut(duration: 0.2))
                            
                        }
                    })
                    
                    
                    
                    
                    
                }
                
            }
            
            else {
                ProgressView("Please wait")
            }
        }.onAppear(perform: loadVenueData)
    }
    
    func loadVenueData() {
//        var nodeURL = "http://localhost:3000/api/test/venue" + "?venueName=\(venueNameInfo)"
        print(venueNameInfo)
//        let safeVenue = "Galen Center"
        let parameters: Parameters = [
                "venueName": venueNameInfo
                ]
        var nodeURL = "https://csci571-160797.wl.r.appspot.com/api/getVenueInfo"
//        var nodeURL = "http://localhost:3000/api/test/venue"
        print("NODE URL for VENUE: ", nodeURL)
        AF.request(nodeURL, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.venueName = json["name"].stringValue
                self.phoneNumber = json["boxOfficeInfo"]["phoneNumberDetail"].stringValue
                self.openHours = json["boxOfficeInfo"]["openHoursDetail"].stringValue
                self.childRules = json["generalInfo"]["childRule"].stringValue
                self.generalRules = json["generalInfo"]["generalRule"].stringValue
                
                if let latitudeString = json["location"]["latitude"].string {
                    if let latitude = Double(latitudeString) {
                        self.latitude = latitude
                    }
                }
                
                if let latitudeString = json["location"]["longitude"].string {
                    if let longitude = Double(latitudeString) {
                        self.longitude = longitude
                    }
                }
                
                self.address = getAddress(addObj: json)
                self.venueState.isVenueAPIComplete = true
                print("VENUE API COMPLETE: ", self.venueState.isVenueAPIComplete)
//                print(json)
            
            case .failure(let error):
                print("SOMETHING WENT WRONG!")
                print(error.localizedDescription)
            }
        }
    }
    
    func getAddress(addObj: JSON) -> String{
        var temp1 = addObj["address"]["line1"].stringValue
        var temp2 = addObj["city"]["name"].stringValue
        var temp3 = addObj["state"]["name"].stringValue
        
        var addArray = [String]()
        if temp1 != "" && temp1.lowercased() != "undefined" {
            addArray.append(temp1)
        }
        if temp2 != "" && temp2.lowercased() != "undefined" {
            addArray.append(temp2)
        }
        if temp3 != "" && temp3.lowercased() != "undefined" {
            addArray.append(temp3)
        }
        return addArray.joined(separator: ", ")
    }
     
}

struct EventVenue_Previews: PreviewProvider {
    static var previews: some View {
        EventVenue(eventTitle: "Ed Sheeran: +-=÷x Tour", venueNameInfo: "galen center")
    }
}
