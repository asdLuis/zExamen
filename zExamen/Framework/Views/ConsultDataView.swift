import SwiftUI

// View that displays historical data with search functionality
struct ConsultDataView: View {
    @StateObject private var viewModel = ConsultDataViewModel() // ViewModel to manage data and loading state
    @State private var searchText = "" // Holds the search text entered by the user
    
    // Computed property to filter items based on search text
    var filteredItems: [HistoricalItem] {
        // If search text is empty, return all data; otherwise, filter based on description or categories
        searchText.isEmpty
            ? viewModel.dataItems
            : viewModel.dataItems.filter { item in
                item.description.localizedCaseInsensitiveContains(searchText) ||
                item.category1.localizedCaseInsensitiveContains(searchText) ||
                item.category2.localizedCaseInsensitiveContains(searchText)
            }
    }
    
    var body: some View {
        // Main container for the view with navigation support
        NavigationView {
            VStack {
                // Search bar at the top
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Show progress indicator if data is loading
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    Spacer()
                } else if filteredItems.isEmpty {
                    // Show a message when no items match the search
                    Spacer()
                    Text("No results found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Button("Load again") {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    Spacer()
                } else {
                    // Display the filtered historical items in a list
                    List(filteredItems, id: \.objectId) { item in
                            HistoricalItemView(item: item)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .refreshable {
                            // Refresh the data when the user pulls down
                            await viewModel.fetchData()
                        }
                }
            }
            .navigationTitle("Historical Events") // Title for the navigation bar
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)) // Background color
        }
        .onAppear {
            // Fetch data when the view appears
            Task {
                await viewModel.fetchData()
            }
        }
        .toast()
    }
}

// Custom search bar view
struct SearchBar: View {
    @Binding var text: String // Binding to the parent view's search text
    
    var body: some View {
        HStack {
            // Magnifying glass icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            // Text field for search input
            TextField("Search historical events", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
            
            // Clear button to reset search text
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray5)) // Background color for the search bar
        .cornerRadius(12) // Rounded corners for the search bar
    }
}

// View that displays individual historical item details
struct HistoricalItemView: View {
    let item: HistoricalItem // Historical item to display
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // Display date of the event
                Text(item.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Display the categories
                Text("\(item.category1) • \(item.category2)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            // Description of the event (limited to 3 lines)
            Text(item.description)
                .font(.body)
                .lineLimit(3)
            
            // Language label
            HStack {
                Spacer()
                Text(item.lang.uppercased())
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white) // Background color for each item
        .cornerRadius(12) // Rounded corners for each item
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Shadow effect for depth
        .padding(.vertical, 4)
    }
}
