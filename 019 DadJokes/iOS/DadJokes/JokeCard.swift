//
//  JokeCard.swift
//  DadJokes
//
//  Created by Paul Hudson on 22/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import CoreData
import SwiftUI

// The photos used in this view come from Unsplash. Thanks to
// Brooke Cagle, Charles Etoroma, Anubhav Shekhar, Ben White
// for making them available! https://unsplash.com

struct JokeCard: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showingPunchline = false
    @State private var randomNumber = Int.random(in: 1...4)
    @State private var dragAmount = CGSize.zero
    var joke: Joke

    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack {
                    Image("Dad\(self.randomNumber)")
                        .resizable()
                        .frame(width: 300, height: 100)

                    Text(self.joke.setup)
                        .font(.largeTitle)
                        .lineLimit(10)
                        .padding([.horizontal])

                    Text(self.joke.punchline)
                        .font(.headline)
                        .lineLimit(10)
                        .padding([.horizontal, .bottom])
                        .blur(radius: self.showingPunchline ? 0 : 6)
                        .opacity(self.showingPunchline ? 1 : 0.25)
                }
                .multilineTextAlignment(.center)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: .black, radius: 5, x: 0, y: 0)
                )
                .onTapGesture {
                    withAnimation {
                        self.showingPunchline.toggle()
                    }
                }
                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).minX) / 10), axis: (x: 0, y: 1, z: 0))
            }

            EmojiView(for: joke.rating)
                .font(.system(size: 72))
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .frame(width: 300)
        .offset(y: dragAmount.height)
        .gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation }
                .onEnded { value in
                    if self.dragAmount.height < -200 {
                        withAnimation {
                            self.dragAmount = CGSize(width: 0, height: -1000)

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.moc.delete(self.joke)
                                // try? self.moc.save()
                            }
                        }
                    } else {
                        self.dragAmount = .zero
                    }
                }
        )
        .animation(.spring())
    }
}

struct JokeCard_Previews: PreviewProvider {
    static var previews: some View {
        let joke = Joke(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        joke.setup = "What do you call a hen who counts her eggs?"
        joke.punchline = "A mathemachicken"
        joke.rating = "Sigh"

        return JokeCard(joke: joke)
    }
}
