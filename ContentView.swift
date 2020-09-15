//  ContentView.swift
//  Flag Guessing App
//
//  Created by Luis Alvarez on 8/26/20.
//  Copyright © 2020 Luis Alvarez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria",
        "Poland", "Russia", "Spain", "UK", "US"].shuffled() // Makes it random everytime
                                                            // we run the code
    @State private var correctAns = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var choice = ""
    @State private var angle = 0.0
    @State private var transparency = 1.0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top,
                           endPoint: .bottom).edgesIgnoringSafeArea(.all) // Creates background
            VStack(spacing: 30){
                VStack{ // Creates texts
                    Text("Tap the flag of ")
                    Text("\(countries[correctAns]) ")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    Text("Score: \(score)")
                }.foregroundColor(.white) // Changed color of font to white
                
                ForEach(0 ..< 3, id: \.self) { number in  // Creates flag buttons
                    Button(action: {
                        self.flagTapped(number)
                        withAnimation{
                            self.angle += 360
                        }
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .flagFrame()
                            .rotation3DEffect(.degrees(self.correctAns == number ? self.angle : 0), axis: (x:0,y:1,z:0))
                            .opacity(self.correctAns != number ? self.transparency : 1.0)

                    }
                }
                Spacer()
            }
        }.alert(isPresented: $showingScore){
            Alert(title: Text("\(scoreTitle)"), message: Text("That's the flag of \(self.choice)!"), dismissButton: .default(Text("Continue")) {
                self.reset()
            })
        }
    }
    
    func flagTapped(_ number:Int){
        if number == correctAns{
            scoreTitle = "Correct"
            score += 1
            transparency = 0.25
        } else{
            scoreTitle = "Wrong"
        }
        showingScore = true // show score after every tap
        choice = countries[number]
    }
    
    func reset(){
        countries.shuffle()
        correctAns = Int.random(in: 0...2)
        angle = 0.0
        transparency = 1.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

extension View{
    func  flagFrame() -> some View{
        self.modifier(FlagModifier())
    }
}
