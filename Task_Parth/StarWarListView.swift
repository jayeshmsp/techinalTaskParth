//
//  ContentView.swift
//  Task_Parth
//
//  Created by MSP on 02/11/23.
//

import SwiftUI
import Apollo


struct StarWarListView: View {
    @State private var searchText = ""
    @State var filmsArr = [QueryQuery.Data.AllFilm.Film?]()
    
    @State var apollo: ApolloClient = {
        let url = URL(string: "https://swapi-graphql.netlify.app/.netlify/functions/index")!
        return ApolloClient(url: url)
    }()
    var body: some View {
        NavigationStack {
            List(searchResults, id: \.?.title) { dataType in
                NavigationLink {
                    StarWarDetailView(objData: dataType)
                } label: {
                    Text(dataType?.title ?? "")
                }
            }
            .navigationTitle("Star Wars Films")
        }
        .searchable(text: $searchText)
        .onAppear {
            apollo.fetch(query: QueryQuery()) {result in
                switch result {
                case .success(let graphQLResult):
                    print("Success! Result: \(graphQLResult)")
                    if let arr = graphQLResult.data?.allFilms?.films {
                        filmsArr = arr
                    }
                case .failure(let error):
                    print("Failure! Error: \(error)")
                }
            }
        }
    }
    
    var searchResults: [QueryQuery.Data.AllFilm.Film?] {
        if searchText.isEmpty {
            return filmsArr
        } else {
            return filmsArr.filter { $0?.title?.contains(searchText) ?? false}
        }
    }
    
}

#Preview {
    StarWarListView()
}
