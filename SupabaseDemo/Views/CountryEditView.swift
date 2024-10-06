//
//  CountryEditView.swift
//  CountrysDemo
//
//  Created by Christoph Rohrer on 14.09.24.
//

import SwiftUI


struct CountryEditView: View {
    
    var country: Country? = nil
    
    @ObservedResults<Country> var countries

    @State private var inputCountry = Country(name: "")
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Country") {
                    TextField("Name", text: $inputCountry.name)
                }
                
                Section("Autoren") {
                    ForEach(country?.authors ?? []) { author in
                        Text(author.name)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle(country == nil ? "New Country" : "Edit Country")
        }
        .toolbar {
            if country == nil {
                ToolbarItem(placement: .cancellationAction ) {
                    Button("Abbrechen", role: .cancel) {
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction ) {
                Button("Speichern") {
                    if country == nil {
                        inputCountry.create()
                        dismiss()
                    } else {
                        inputCountry.update()
                    }
                }
                .disabled(inputCountry.name.isEmpty)
            }
        }
        .onAppear {
            if let country {
                inputCountry = country
            }
        }
        .onChange(of: country) {
            if let country {
                inputCountry = country
            }
        }
    }
}

#Preview {
    CountryEditView() 
}
