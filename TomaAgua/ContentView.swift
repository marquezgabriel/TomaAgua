//
//  ContentView.swift
//  TomaAgua
//
//  Created by Gabriel Marquez on 2023-01-25.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("waterConsumed") private var waterConsumed = 0.0
    @AppStorage("waterRequired") private var waterRequired = 2000.0
    @AppStorage("useMetricUnits") private var useMetricUnits = true

    @AppStorage("lastDrink") private var lastDrink = Date.now.timeIntervalSinceReferenceDate

    @State private var showingAdjustments = false
    @State private var showingDrinksMenu = false

    let mlToOz = 0.0351951
    let ozToMl = 29.5735
    
    var goalProgress: Double {
        waterConsumed / waterRequired
    }

    var statusText: Text {
        if useMetricUnits {
            return Text("\(Int(waterConsumed))ml / \(Int(waterRequired))ml")
        } else {
            let adjustedConsumed = waterConsumed * mlToOz
            let adjustedRequired = waterRequired * mlToOz
            return Text("\(Int(adjustedConsumed))oz / \(Int(adjustedRequired))oz")
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.blue, .cyan, .blue, ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing:0) {
                    statusText
                        .font(.largeTitle)
                        .padding(.top)
                        .onTapGesture {
                            withAnimation{
                                showingAdjustments.toggle()
                            }
                        }
                    
                    if showingAdjustments {
                        VStack {
                            Text("Adjust Goal")
                                .font(.headline)
                            
                            Slider(value: $waterRequired, in: 500...4000)
                                .tint(.white)
                        }
                        .padding()
                        .transition(.scale(scale: 0, anchor: .top))
                    }

                    Image(systemName: "drop.fill")
                        .resizable()
                        .font(.title.weight(.ultraLight))
                        .scaledToFit()
                        .foregroundStyle(
                            .linearGradient(stops: [.init(color: .clear, location: 0), .init(color: .clear, location: 1 - goalProgress), .init(color: .white, location: 1 - goalProgress), .init(color: .white, location: 1)], startPoint: .top,    endPoint: .bottom)
                        )
                        .overlay (
                            Image(systemName: "drop")
                                .resizable()
                                .font(.title.weight(.ultraLight))
                                .scaledToFit()
                        )
                        .padding()
                        .onTapGesture {
                            showingDrinksMenu.toggle()
                            
                        }
                    
                    Toggle("Use Metric units", isOn: $useMetricUnits)
                        .padding()
                    
                }
            }
        }
        .foregroundColor(.white)
        .alert("Add Drink", isPresented: $showingDrinksMenu) {
            if useMetricUnits {
                ForEach([100, 200, 300, 400, 500], id: \.self) { number in
                    Button("\(number)ml") { add(Double(number)) }
                }
            } else {
                ForEach([8, 12, 16, 20, 24, 28], id: \.self) { number in
                    Button("\(number)oz") { add(Double(number) * ozToMl) }
                }
            }
            
            Button("Cancel", role: .cancel) {  }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: checkForReset)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: checkForReset)
        .onChange(of: waterConsumed) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: waterRequired) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func add(_ amount : Double) {
        lastDrink = Date.now.timeIntervalSinceReferenceDate
        waterConsumed += amount
    }
    
    func checkForReset(_ notification: Notification){
        let lastChecked = Date(timeIntervalSinceReferenceDate: lastDrink)
        
        if Calendar.current.isDateInToday(lastChecked) == false {
            waterConsumed = 0
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
