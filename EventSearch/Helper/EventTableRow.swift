import SwiftUI


struct EventTableRow: View {
    
    @State private var date = "2023-09-16|18:00"
    @State private var image = ""
    @State private var title = "Ed Sheeran: +-=÷x ABCV"
    @State private var venue = "Levi's® Stadium"
    
    var body: some View {
        VStack {
            HStack {
                Text(date)
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: 80, maxHeight: 80)
                
                Image(systemName: "play.square")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: 110, maxHeight: 80)
                    
                
                Text(venue)
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: 80, maxHeight: 80)
                Spacer()
                    
            }
            
            .padding(.vertical, 20)
        }
    }
}

struct EventTableRow_Previews: PreviewProvider {
    static var previews: some View {
        EventTableRow()
    }
}
