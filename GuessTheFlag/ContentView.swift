//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Davron on 11/18/19.
//  Copyright © 2019 Davron. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "Turkey", "Turkmenistan", "UK", "US", "Uzbekistan"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Tap the flag of..")
                .foregroundColor(.white)
                Text("Country")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
