import SwiftUI

struct Restaurant {
    var name: String
    var type: String
    var location: String
    var image: String
    var isFavorite: Bool
    
    init(name: String, type: String, location: String, image: String, isFavorite: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isFavorite = isFavorite
    }
    
    init() {
        self.init(name: "", type: "", location: "", image: "", isFavorite: false)
    }
}

struct RestaurantListView: View {
    
    @State var restaurants = [
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false),
        
    ]
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            ForEach(restaurants.indices, id: \.self) { index in
                BasicTextImageRow(restaurant: $restaurants[index])
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                        }
                        .tint(.green)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .tint(.orange)
                    }
                
            }
            //            .onDelete(perform: { indexSet in
            //                    restaurants.remove(atOffsets: indexSet)
            //            })
            
            // .listRowSeparator(.hidden)
        }
        .padding(0)
        // .listStyle(.plain)
    }
}

#Preview {
    RestaurantListView()
}

#Preview("Dark mode") {
    RestaurantListView()
        .preferredColorScheme(.dark)
}

struct BasicTextImageRow: View {
    
    // MARK: - Binding
    
    @Binding var restaurant: Restaurant
    
    // MARK: - State variables
    
    @State private var showError = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(restaurant.image)
                .resizable()
                .frame(width: 120, height: 118)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.gray)
            }
            
            if restaurant.isFavorite {
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .contextMenu {
            
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            
            Button(action: {
                self.restaurant.isFavorite.toggle()
            }) {
                HStack {
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            
            
        }
        .alert("Not yet available", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("Sorry, this feature is not available yet. Please retry later.")
        }
        .frame(maxWidth: .infinity)
        
    }
}


#Preview("BasicTextImageRow", traits: .sizeThatFitsLayout) {
    BasicTextImageRow(restaurant: .constant(
        Restaurant(name: "TEA STOP", type: "Coffee & Tea Shop", location: "楊梅埔心", image: "drinker001", isFavorite: false)
    ))
}
