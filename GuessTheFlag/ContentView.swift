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
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "Turkey", "Turkmenistan", "UK", "US", "Uzbekistan"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var attempts: Int = 0
    @State private var didSelectCorrectAnswer = false
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 40){
                Spacer()
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
                        self.opacity = 0.25
                        self.flagTapped(number)
                        withAnimation {
                            if number == self.correctAnswer {
                                self.animationAmount = 360
                            }
                            else {
                                self.animationAmount = 0
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
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                    }
                    .opacity(number == self.correctAnswer ? 1 : self.opacity)
                    .animation(.default)
                    .rotation3DEffect(.degrees( Double(number == self.correctAnswer ?  self.animationAmount : 0.0)), axis: (x: 0, y: 1, z: 0 ))
                    .modifier(Shake(animatableData: CGFloat(self.attempts)))

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
            didSelectCorrectAnswer = true
        }
        else {
            scoreTitle = "Wrong! That is the flag of \(countries[number])"
            didSelectCorrectAnswer = false
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmount = 0.0
        opacity = 1.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
