//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Davron on 11/18/19.
//  Copyright © 2019 Davron. All rights reserved.
//

import SwiftUI

struct FlagImage: ViewModifier {
    var flag : String
    func body(content: Content) -> some View {
        ZStack {
            content
            Image(flag)
                .renderingMode(.original)
                //.clipShape(Capsule())
                .shadow(color:.black, radius: 2)
                .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
        }

    }
}

extension View {
    func flagStyle(with flag: String) -> some View {
        self.modifier(FlagImage(flag: flag))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "Turkey", "Turkmenistan", "UK", "US", "Uzbekistan"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 40){
                VStack (spacing: 20) {
                    Text("Tap the flag of..")
                    .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        //flag was tapped
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .flagStyle(with: self.countries[number])

                    }
                    
                }
                Text("Score: \(score)")
                    .foregroundColor(.white).fontWeight(.heavy)
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")){
                    self.askQuestion()
                    })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 10
        }
        else {
            scoreTitle = "Wrong! That is the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
