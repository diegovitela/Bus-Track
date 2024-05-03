
import SwiftUI
import MapKit

struct BusStop: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7830, longitude: -122.4715), // Coordenadas ajustadas
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isLoading: Bool = true
    @State private var fillAmount: CGFloat = 0.0

    private var busStops = [BusStop(name: "Camión", coordinate: CLLocationCoordinate2D(latitude: 37.7890, longitude: -122.4100))]

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 20)
                        .overlay(
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: fillAmount, height: 20)
                                .animation(Animation.linear(duration: 3), value: fillAmount)
                        )
                        .onAppear {
                            withAnimation(Animation.linear(duration: 3)) {
                                fillAmount = 300
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isLoading = false
                            }
                        }
                } else {
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: busStops) { busStop in
                        MapAnnotation(coordinate: busStop.coordinate) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                    .onAppear {
                        region.center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    }
                    .edgesIgnoringSafeArea(.all)

                    HStack {
                        Spacer()
                        NavigationLink(destination: DriversListView()) {
                            Image(systemName: "doc.text.below.ecg")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        NavigationLink(destination: WorldTemplate()) {
                            Image(systemName: "bus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        NavigationLink(destination: ProfileTemplate()) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .accentColor(.black)
    }
}






struct Driver: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String // Asume que tienes estas imágenes en tus assets
    let trips: Int
    let rating: Int // Considerando estrellas de 1 a 5
}


struct DriversListView: View {
    var drivers: [Driver] = [
        Driver(name: "Juan Pérez", imageName: "conductor1", trips: 200, rating: 5),
        Driver(name: "Ana Gómez", imageName: "Conductora", trips: 150, rating: 4),
        Driver(name: "Luis Gonzalea", imageName: "conductor2", trips: 100, rating: 4),
        Driver(name: "Gael Solano", imageName: "conductor3", trips: 400, rating: 4),
        Driver(name: "Jose Luis Vitela", imageName: "Conductor4", trips: 1000, rating: 5),
        Driver(name: "Mario Vazquez", imageName: "Conductor6", trips: 1000, rating: 5),
        Driver(name: "Maria Jimenez", imageName: "conductor5", trips: 1000, rating: 5),
    ]

    var body: some View {
        NavigationView {
            VStack {
                List(drivers) { driver in
                    HStack {
                        Image(driver.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.trailing, 8)
                        
                        VStack(alignment: .leading) {
                            Text(driver.name)
                                .font(.headline)
                            Text("Viajes: \(driver.trips)")
                            HStack {
                                ForEach(0..<driver.rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Conductores")
            .font(.headline)

        }
    }
}

struct DriversListView_Previews: PreviewProvider {
    static var previews: some View {
        DriversListView()
    }
}

// ____________________________________________________________//
//    Aqui incia la pagina de logo del globo                 ////
// ____________________________________________________________//
struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let url: String
}

let newsItems: [NewsItem] = [
    NewsItem(title: "8 de marzo 2024", url: "https://example.com/news/8-marzo-2024"),
    NewsItem(title: "7 de marzo 2024", url: "https://example.com/news/7-marzo-2024"),
    NewsItem(title: "6 de marzo 2024", url: "https://example.com/news/6-marzo-2024"),
    NewsItem(title: "5 de marzo 2024", url: "https://example.com/news/5-marzo-2024"),
    NewsItem(title: "4 de marzo 2024", url: "https://example.com/news/4-marzo-2024"),
]

struct WorldTemplate: View {
    @State private var selectedNewsItem: NewsItem? = nil

    var body: some View {
        NavigationView {
            List(newsItems) { newsItem in
                Button(action: {
                    if self.selectedNewsItem?.id == newsItem.id {
                        self.selectedNewsItem = nil // Deselecciona si es el mismo ítem
                    } else {
                        self.selectedNewsItem = newsItem // Selecciona el nuevo ítem
                    }
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(newsItem.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Image(systemName: "bus")
                                .foregroundColor(.secondary)
                            Text("Viajes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        // Mostrar detalles si el ítem está seleccionado
                        if self.selectedNewsItem?.id == newsItem.id {
                            VStack(alignment: .leading, spacing: 10) { // Alineación a la izquierda con espaciado entre elementos
                                Divider() // Añade un divisor para separar visualmente los detalles
                                    .padding(.vertical, 4)
                                
                                HStack {
                                    Image("Conductor6")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue) // Color del icono del conductor
                                    Text("Conductor:")
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Text("Mario Vazquez") // Ajustar según los datos reales
                                        .foregroundColor(.secondary)
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    Text("Promedio de tiempo:")
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    Text("35 minutos") // Ajustar según los datos reales
                                        .foregroundColor(.secondary)
                                }
                                .padding(.bottom, 2)
                            }
                            HStack {
                                Text("Llegada a la escuela:")
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("6:45 am - Trayecto de 40 min")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.bottom, 2)
                            
                            HStack {
                                Text("Llegada a casa:")
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("4:10 pm - Trayecto de 30 min")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.bottom, 2)
                            HStack {
                            }
                            .padding(.bottom, 2)
                            .padding()
                           
                            .cornerRadius(8) // Bordes redondeados
                            .shadow(radius: 2) // Sombra ligera para dar profundidad
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarTitle("Viajes")
            .font(.headline)
        }
    }
}



struct ProfileTemplate: View {
    let totalTravelTime: Double = 350
    let averageTravelTime: Double = 0.35
    let daysTraveledToSchool: Int = 5
    let daysAbsent: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProfileHeaderView() // Vista para la imagen de perfil y el nombre
                
                Group {
                    Text("Estadísticas de Viajes")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .fontWeight(.bold)
                    
                    // Introducir un divisor aquí podría no ser necesario si quieres que el título se destaque por sí solo
                    
                    StatisticRow(label: "Tiempo total de viajes:", value: "\(totalTravelTime) min")
                    Divider() // Añade un divisor después de cada estadística
                    StatisticRow(label: "Promedio de tiempo por viaje:", value: "\(averageTravelTime) horas")
                    Divider()
                    StatisticRow(label: "Días ida y vuelta a la escuela:", value: "\(daysTraveledToSchool) días")
                    Divider()
                    StatisticRow(label: "Días ausente:", value: "\(daysAbsent) días")
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image("niño") // Sustituye con la imagen deseada
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100) // Tamaño de imagen aumentado
                .clipShape(Circle())
            
            Text("Diego Vitela Ortega")
                .font(.title)
                .foregroundColor(.black)
                .fontWeight(.bold)
        }
        .padding(.vertical)
    }
}

struct StatisticRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
