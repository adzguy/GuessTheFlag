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
    var animationAmount: CGFloat = 0.0
    func body(content: Content) -> some View {
        ZStack {
            content
            Image(flag)
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.black, lineWidth: 1))
                .shadow(color:.black, radius: 1)
        }
    }
}

extension View {
    func flagStyle(with flag: String) -> some View {
        self.modifier(FlagImage(flag: flag))
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "Turkey", "Turkmenistan", "UK", "US", "Uzbekistan"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var attempts: Int = 0
    @State private var flip = false
    @State private var wrong = false
    
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
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        //flag was tapped
                        self.flagTapped(number)
                        withAnimation {
                            if number == self.correctAnswer {
                                self.animationAmount += 360
                            }
                            else {
                                self.attempts += 1
                            }
                        }
                    })
                    {
                        
                        Image(self.countries[number])
                            //.flagStyle(with: self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.black, lineWidth: 1)
                                    .shadow(color:.black, radius: 1)
                            )
                            .rotation3DEffect(.degrees( Double(self.animationAmount)), axis: (x: 0, y: number == self.correctAnswer ? 1 : 0, z: 0 ))
                            .modifier(Shake(animatableData: CGFloat(self.attempts)))

                    }

                }
                Text("Score: \(score)")
                    .foregroundColor(.white).fontWeight(.heavy)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")){
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 10
            flip = true
        }
        else {
            scoreTitle = "Wrong! That is the flag of \(countries[number])"
            wrong = true
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flip = false
        wrong = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
