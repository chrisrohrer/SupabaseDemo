//
//  ContentView.swift
//  AuthorsDemo
//
//  Created by Christoph Rohrer on 14.09.24.
//

import SwiftUI
import HelpersLibrary

struct CountriesListView: View {
    
    @ObservedResults<Country> var countries

    @State private var selectedCountry: Country.ID?
    @State private var addSheet = false

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedCountry) {
                ForEach(countries) { country in
                    VStack(alignment: .leading) {
                        Text(country.name)
                            .font(.headline)
                            .contextMenu {
                                Button("Delete") {
                                    country.delete()
                                }
                            }
                    }
                }
            }

        } detail: {
            if let country = countries[selectedCountry] {
                CountryEditView(country: country)
            }
        }
        .navigationTitle("Countries")
        .toolbar {
            ToolbarItem(placement: .primaryAction ) {
                Button("Add Country", systemImage: "plus") { addSheet = true }
            }
        }
        .sheet(isPresented: $addSheet, content: {
            CountryEditView()
        })
        
    }
}






#Preview {
    ContentView()
}
