//
//  ContentView.swift
//  TomaAgua
//
//  Created by Gabriel Marquez on 2023-01-25.
//

import SwiftUI

struct ContentView: View {
    var goalProgress: Double { 0.5 }
    
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.blue, .cyan, .blue, ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Image(systemName: "drop.fill")
                    .resizable()
                    .font(.title.weight(.ultraLight))
                    .scaledToFit()
                    .foregroundStyle(
                        .linearGradient(stops: [.init(color: .clear, location: 0), .init(color: .clear, location: 1 - goalProgress), .init(color: .white, location: 1 - goalProgress), .init(color: .white, location: 1)], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay (
                        Image(systemName: "drop")
                            .resizable()
                            .font(.title.weight(.ultraLight))
                            .scaledToFit()
                    )
            }
            .foregroundColor(.white)
        }
        //.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
