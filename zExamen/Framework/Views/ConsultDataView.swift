import SwiftUI

/// ConsultDataView: A reusable component for listing, searching, and filtering data entries.
///
/// This SwiftUI View is designed to handle any generic data model, providing features like search,
/// filtering, and a structured layout for data display.
struct ConsultDataView: View {
    
    @Environment(\.colorScheme) var colorScheme
    // Adjust color scheme for light/dark mode compatibility.
    
    @State private var searchText = ""
    @State private var isRegistering = false
    
    @StateObject private var viewModel = ConsultDataViewModel()
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        ZStack {
            VStack {
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .ignoresSafeArea()
            
            GeometryReader { mainGeometry in
                VStack {
                    VStack {
                        Image(systemName: "list.bullet.rectangle")
                            .font(Font.custom("Marcellus", size: 50))
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        
                        Text("Data Entries")
                            .font(Font.custom("Times New Roman", size: 50))
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    }
                    .padding(.top, mainGeometry.size.height * 0.03)
                    
                    GeometryReader { geometry in
                        VStack {
                            VStack {
                                if viewModel.dataItems.isEmpty {
                                    List {
                                        ZStack {
                                            Text("No data available.")
                                                .font(Font.custom("Times New Roman", size: geometry.size.height * 0.03))
                                                .multilineTextAlignment(.center)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 1, y: 2)
                                                .opacity(0.7)
                                                .padding(.vertical, geometry.size.width * 0.4)
                                                .frame(width: geometry.size.width * 0.9)
                                        }
                                        .listRowBackground(Color.clear)
                                    }
                                    .refreshable {
                                        Task {
                                            await viewModel.fetchData()
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    .background(Color.clear)
                                } else {
                                    List(viewModel.dataItems, id: \.id) { dataItem in
                                        ConsultDataListElement(
                                            name: dataItem.name,
                                            description: dataItem.description,
                                            id: dataItem.id
                                        )
                                            .listRowInsets(EdgeInsets())
                                            .listRowBackground(Color.clear)
                                            .padding(.vertical, 5)
                                    }
                                    .refreshable {
                                        Task {
                                            await viewModel.fetchData()
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    .background(Color.clear)
                                }
                            }
                            .frame(height: mainGeometry.size.height * 0.55)
                        }
                        .frame(width: geometry.size.width, alignment: .center)
                    }
                    .padding(.vertical, mainGeometry.size.height * 0.02)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
        .toast()
    }
}

struct ConsultDataView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock ViewModel with sample data for the preview
        let mockViewModel = ConsultDataViewModel()
        mockViewModel.dataItems = [
            Data(id: 1, name: "Sample Entry 1", description: "This is a sample description."),
            Data(id: 2, name: "Sample Entry 2", description: "Another example entry for testing.")
        ]
        
        return ConsultDataView()
    }
}
