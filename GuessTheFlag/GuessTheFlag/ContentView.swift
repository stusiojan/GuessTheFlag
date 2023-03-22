//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jan Stusio on 19/02/2023.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 3)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var finalScore = ""
    @State private var usersScore = 0
    @State private var questionNumber = 0
    @State private var gameEnd = false
    @State private var selectedButton = -1
    @State private var isAnimated = false
    @State private var animationLevel = 0.0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: .yellow, location: 0.01),
                .init(color: .mint, location: 0.5)
            ], center: .bottom, startRadius: 700, endRadius: 100)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text("GuessTheFlag")
                        .foregroundStyle(.secondary)
                        .font(.title)
                    Spacer()
                    Text("Score: \(usersScore)")
                        .foregroundStyle(.secondary)
                        .font(.title)
                }
                .padding(.all, 20)
                
                Spacer()
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isAnimated.toggle()
                                animationLevel += 360
                            }
                           
                        } label: {
                            FlagImage(country: countries[number])
                                .scaleEffect((selectedButton == number || selectedButton == -1) ? 1 : 0.85)
                                .animation(.linear, value: selectedButton == number || selectedButton == -1)
                                .opacity((selectedButton == number || selectedButton == -1) ? 1 : 0.25)
                                .rotation3DEffect(.degrees(selectedButton == number ? animationLevel : 0) , axis: (x: 0, y: 1, z: 0))
                        }
                    }
                    .rotation3DEffect(.degrees(360), axis: (x: 0, y: 1, z: 0))
                }
                .padding(.all, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(usersScore)")
        }
        .alert(finalScore, isPresented: $gameEnd) {
            Button("Play again", action: restart)
        } message: {
            Text("Your finale score is \(usersScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            usersScore += 1
        } else {
            scoreTitle = "Wrong That's the flag of \(countries[number])"
            usersScore -= 1
        }
        
        showingScore = true
        
        if questionNumber == 7{
            gameEnd = true
        }
        
        selectedButton = number
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNumber += 1
        selectedButton = -1
    }
    
    func restart() {
        questionNumber = 0
        usersScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
