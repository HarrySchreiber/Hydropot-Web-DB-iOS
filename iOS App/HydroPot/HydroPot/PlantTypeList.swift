//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct PlantTypeList: View {
    @State private var searchQuery: String = ""
    var plants = [Plant(), Plant(), Plant()]
       var body: some View {

           List {
               Section(header: SearchBar(text: self.$searchQuery)) {
                   ForEach(Array(1...100).filter {
                       self.searchQuery.isEmpty ?
                           true :
                           "\($0)".contains(self.searchQuery)
                   }, id: \.self) { item in
                       Text("\(item)")
                   }
               }
           }
       }
}
struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar,
                      context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}



struct PlantTypeList_Previews: PreviewProvider {
    static var previews: some View {
        PlantTypeList()
    }
}
