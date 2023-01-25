//
//  ContentView.swift
//  TomaAgua
//
//  Created by Gabriel Marquez on 2023-01-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.blue, .cyan, .blue, ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Image(systemName: "drop")
                    .resizable()
                    .font(.title.weight(.ultraLight))
                    .scaledToFit()
            }
            .foregroundColor(.white)
        }
        // .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
