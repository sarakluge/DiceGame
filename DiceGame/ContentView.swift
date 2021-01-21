//
//  ContentView.swift
//  DiceGame
//
//  Created by Sara Kluge on 2021-01-21.
//

import SwiftUI

struct ContentView: View {
    //@State = swiftUI tar över ansvaret och den går att ändra på i en struct och det laddas om när vi ändrar på vyerna
    @State var diceNumber1 = 1
    @State var diceNumber2 = 1
    @State var sum = 0
    @State var points = 0
    @State var rounds = 0
    @State var showingWinningSheet = false
    @State var showingBustAlert = false
    
    var body: some View {
        ZStack {
            Color(red: 11.0/256, green: 96.0/256, blue: 60.0/256)
                .ignoresSafeArea()
            
            
            VStack {
                VStack(alignment: .leading){
                    Text("Points: \(points)/100")
                        .font(.title)
                        .foregroundColor(Color.white)
                    Text("Rounds: \(rounds)")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                HStack {
                    DiceView(num: diceNumber1)
                    DiceView(num: diceNumber2)
                }.onAppear() { //när tärningarna visas upp körs funktionen roll()
                    roll()
                }
                Text("Current sum: \(sum)")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack {
                    Button(action: {roll()}) {
                        Text(" Roll ")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                    }
                    .background(Color.green)
                    .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                    .padding()
                    
                    Button(action: {stop()}) {
                        Text("Stop")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                    }
                    .background(Color.red)
                    .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                    .padding()
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingWinningSheet, onDismiss: {sum = 0; points = 0; rounds = 0}) {
            WinningSheet(rounds: rounds)
        }
        .alert(isPresented: $showingBustAlert, content: {
            Alert(title: Text("Bust"), message: Text("You've got more than 21"))
        })
    }
    
    func roll() {
        diceNumber1 = Int.random(in: 1...6)
        diceNumber2 = Int.random(in: 1...6)
        sum += diceNumber1 + diceNumber2
        
        if sum > 21 {
            rounds += 1
            sum = 0
            showingBustAlert = true
        }
    }
    
    func stop() {
        points += sum
        sum = 0
        rounds += 1
        
        if points >= 100 {
            showingWinningSheet = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WinningSheet: View {
    let rounds: Int
    
    var body: some View{
        ZStack{
            Color(red: 11.0/256, green: 96.0/256, blue: 60.0/256)
                .ignoresSafeArea()
            
            VStack {
                Text("You've got 100 points in \(rounds) rounds")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            
        }
        
    }
}

struct DiceView: View {
    let num: Int
    
    var body: some View {
        Image(systemName: "die.face.\(num).fill")
            .resizable() // förstorar och fyller skärmen
            .aspectRatio(contentMode: .fit) // anpassar
            .padding() // ram runt
    }
}
