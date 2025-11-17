//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Student on 10/3/25.
//
import SwiftUI

struct ContentView: View {

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0

    // Animation states
    @State private var selectedFlag: Int? = nil
    @State private var animationAmount = 0.0

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.7)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()

            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 100)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? animationAmount : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                        .animation(.easeInOut(duration: 1), value: animationAmount)
                        .animation(.easeInOut, value: selectedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
    }

    func flagTapped(_ number: Int) {
        selectedFlag = number

        withAnimation {
            animationAmount += 360
        }

        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showingScore = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil     // Reset opacity animation
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
