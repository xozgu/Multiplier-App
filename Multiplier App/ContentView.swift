//
//  ContentView.swift
//  Multiplier App
//
//  Created by Ozgu Ozden on 2022/02/19.
//

import SwiftUI

struct ContentView: View {
    
    
    let columns = [GridItem(.adaptive(minimum: 70))]
    let brightPurple = Color(red: 0.479, green: 0.531, blue: 1.0)
    
    @State private var disabled = true
    
    @FocusState private var inputIsFocused: Bool


    @State private var multiplicand = 0
    @State private var remainingRounds = 2
    @State private var showingAlert = false
    @State private var userAnswer: Int?
    @State private var multiplier = 0
    @State private var score = 0
    @State private var scoreTitle = ""


    var body: some View {
        NavigationView {
            ZStack{
                brightPurple
                .ignoresSafeArea()

            if multiplier > 0 {
            //We will show the answering screen
                
                ZStack {
                    Color.white
                    .ignoresSafeArea()
                }
                VStack {
                    Section() {
                        Text("\(multiplicand) x \(multiplier)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(brightPurple)
                    }
                    Spacer()
                    Form {
                        Section {
                            TextField("Enter your answer", value: $userAnswer, format: .number)
                                .keyboardType(.numberPad)
                                .focused($inputIsFocused)
                                .font(.title)
                                .foregroundColor(brightPurple)
                                .padding()
                        }
                    }
                }
                .toolbar {
                    Button("Cancel" , role: .cancel, action: reset)
                        .foregroundColor(.black)
                }
                .alert(scoreTitle, isPresented: $showingAlert) {
                    if remainingRounds == 1 {
                        Button("Restart", action: reset)
                    }
                    else {
                        Button("Continue", action: tapNext)
                    }
                } message: {
                    Text("Your score is \(score)")
                }
            }
            else {
            //We will show the Game Start screen
                VStack {
                    Section(header: Text("The multiplication table I want to practise is:") .foregroundColor(.white)){
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach((1...10), id: \.self) { item in
                                Button("\(item)") {
                                    multiplicand = item
                                }
                                .frame(width:44)
                                .padding()
                                .background(item == multiplicand ? Color.white.opacity(1) : Color.white.opacity(0.2))
                                .foregroundColor(item == multiplicand ? brightPurple : Color.white)
                                .font(.title)
                            }
                        }
                    }
                    Spacer()
                    Section(header: Text("Question number I want is: \(remainingRounds)") .foregroundColor(.white)){
                        Stepper("", value: $remainingRounds, in: 2...12)
                            .frame(width: 100, height: 50)
                    }
                    Spacer()
                    
                    Button("Start the Challenge" , action: gameStart)
                        .padding()
                        .foregroundColor(brightPurple)
                        .background(multiplicand == 0 ? Color.white.opacity(0.4) : Color.white)
                        .disabled(multiplicand == 0 ? disabled == true : disabled == false)
                        .cornerRadius(12)
                    Spacer()
                }
            }
        }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        enterAnswer()
                        inputIsFocused = false
                    }
                }
            }
    }
}
    
    // Trigger: when the start button is tapped
    // What it does: it randomizes the multiplier
    func gameStart() {
        multiplier = Int.random(in: 1..<11)
    }
    
    // Trigger: when the DONE button in the keyboard is tapped
    // What it does: 1) it makes the showingAlert true
    // What it does: 2) it calculates the score
    func enterAnswer() {
        showingAlert = true
        if multiplicand * multiplier == userAnswer {
            scoreTitle = "Correct!"
            score += 1
        }
        else {
            scoreTitle = "Wrong!"
            score -= 1
        }
        if remainingRounds == 1 {
            scoreTitle += " End of the Game"
        }
    }
    
    // Trigger: when the CONTINUE button in the alert is tapped
    // What it does: 1) it decreases the remaining rounds (-1)
    // What it does: 2) it makes showingAlert false
    // What it does: 3) it changes the userAnswer value to nil
    // What it does: 4) it randomizes the multiplier
    func tapNext() {
        remainingRounds -= 1
        showingAlert = false
        userAnswer = nil
        multiplier = Int.random(in: 1..<11)
    }
    
    // Trigger: when OK button in the alert is tapped
    // What it does: it changes every variable to their default values
    func reset() {
        multiplicand = 0
        remainingRounds = 2
        showingAlert = false
        multiplier = 0
        score = 0
        userAnswer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
