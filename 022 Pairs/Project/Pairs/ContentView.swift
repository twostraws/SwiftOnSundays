//
//  ContentView.swift
//  Pairs
//
//  Created by Paul Hudson on 15/04/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

class Deck: ObservableObject {
    let allCards: [Card] = Bundle.main.decode("capitals.json")
    var cardParts = [CardPart]()

    init() {
        let selectedCards = allCards.shuffled().prefix(12)

        for card in selectedCards {
            cardParts.append(CardPart(id: card.id, text: card.a))
            cardParts.append(CardPart(id: card.id, text: card.b))
        }

        cardParts.shuffle()
    }

    func set(_ index: Int, to state: CardState) {
        cardParts[index].state = state
        objectWillChange.send()
    }
}

struct Card: Codable {
    let id = UUID()
    let a: String
    let b: String
}

struct CardView: View {
    var cardPart: CardPart

    var body: some View {
        ZStack {
            CardBack()
                .rotation3DEffect(.degrees(cardPart.state == .unflipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .opacity(cardPart.state == .unflipped ? 1 : 0)

            CardFront(cardPart: cardPart)
                .rotation3DEffect(.degrees(cardPart.state != .unflipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(cardPart.state != .unflipped ? 1 : -1)
        }
    }
}

enum CardState {
    case unflipped, flipped, matched
}

struct CardPart {
    let id: UUID
    let text: String
    var state = CardState.unflipped
}

struct CardBack: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.blue)
            .frame(width: 140, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.white, lineWidth: 2)
            )
    }
}

struct CardFront: View {
    var cardPart: CardPart

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(cardPart.state == .matched ? Color.green : Color.white)
                .frame(width: 140, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white, lineWidth: 2)
                )

            Text(cardPart.text)
                .font(.title)
                .foregroundColor(.black)
        }
    }
}

enum GameState {
    case start, firstFlipped
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        guard let loaded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

struct ContentView: View {
    @ObservedObject var deck = Deck()

    @State private var state = GameState.start
    @State private var firstIndex: Int?
    @State private var secondIndex: Int?

    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let rowCount = 4
    let columnCount = 6

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(white: 0.3), .black]), startPoint: .top, endPoint: .bottom)

            VStack {
                Image(decorative: "pairs")

                GridStack(rows: rowCount, columns: columnCount, content: card)

                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
            }
            .padding()
        }
        .onReceive(timer, perform: updateTimer)
    }

    func card(atRow row: Int, column: Int) -> some View {
        let index = (row * columnCount) + column
        let part = deck.cardParts[index]

        return CardView(cardPart: part)
            .accessibility(addTraits: .isButton)
            .accessibility(label: Text(part.text))
            .onTapGesture {
                self.flip(index)
            }
    }

    func flip(_ index: Int) {
        guard deck.cardParts[index].state == .unflipped else { return }
        guard secondIndex == nil else { return }

        switch state {
        case .start:
            withAnimation {
                self.firstIndex = index
                self.deck.set(index, to: .flipped)
                self.state = .firstFlipped
            }
        case .firstFlipped:
            withAnimation {
                self.secondIndex = index
                self.deck.set(index, to: .flipped)
                self.checkMatches()
            }
        }
    }

    func match() {
        guard let first = firstIndex, let second = secondIndex else {
            fatalError("There must be two flipped cards before matching.")
        }

        withAnimation {
            deck.set(first, to: .matched)
            deck.set(second, to: .matched)
        }

        reset()
    }

    func noMatch() {
        guard let first = firstIndex, let second = secondIndex else {
            fatalError("There must be two flipped cards before matching.")
        }

        withAnimation {
            deck.set(first, to: .unflipped)
            deck.set(second, to: .unflipped)
        }

        reset()
    }

    func reset() {
        firstIndex = nil
        secondIndex = nil
        state = .start
    }

    func checkMatches() {
        guard let first = firstIndex, let second = secondIndex else {
            fatalError("There must be two flipped cards before matching.")
        }

        if deck.cardParts[first].id == deck.cardParts[second].id {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: match)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: noMatch)
        }
    }

    func updateTimer(_ currentTime: Date) {
        let unmatched = self.deck.cardParts.filter { $0.state != .matched }
        guard unmatched.count > 0 else { return }

        if self.timeRemaining > 0 {
            self.timeRemaining -= 1
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
