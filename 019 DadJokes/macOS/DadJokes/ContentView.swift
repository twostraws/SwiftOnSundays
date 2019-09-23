//
//  ContentView.swift
//  DadJokesRealsies
//
//  Created by Paul Hudson on 22/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Joke.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Joke.setup, ascending: true)
    ]) var jokes: FetchedResults<Joke>
    @State private var showingAddJoke = false

    var body: some View {
        NavigationView {
            List {
                ForEach(jokes, id: \.setup) { joke in
                    NavigationLink(destination: Text(joke.punchline).frame(maxWidth: .infinity, maxHeight: .infinity)) {
                        EmojiView(for: joke.rating)
                        Text(joke.setup)
                    }
                }
                .onDelete(perform: removeJokes)

                Button("Add Joke") {
                    self.showingAddJoke.toggle()
                }
            }
            .listStyle(SidebarListStyle())
            .sheet(isPresented: $showingAddJoke) {
                AddView().environment(\.managedObjectContext, self.moc)
            }
        }
    }

    func removeJokes(at offsets: IndexSet) {
        for index in offsets {
            let joke = jokes[index]
            moc.delete(joke)
        }

        try? moc.save()
    }
}

struct EmojiView: View {
    var rating: String

    var body: some View {
        switch rating {
        case "Sob":
            return Text("😭")
        case "Sigh":
            return Text("😔")
        case "Smirk":
            return Text("😏")
        default:
            return Text("😐")
        }
    }

    init(for rating: String) {
        self.rating = rating
    }
}

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var setup = ""
    @State private var punchline = ""
    @State private var rating = "Silence"
    let ratings = ["Sob", "Sigh", "Silence", "Smirk"]

    var body: some View {
        Form {
            Section {
                TextField("Setup", text: $setup)
                TextField("Punchline", text: $punchline)

                Picker("Rating", selection: $rating) {
                    ForEach(ratings, id: \.self) { rating in
                        Text(rating)
                    }
                }
            }

            Button("Add Joke") {
                let newJoke = Joke(context: self.moc)
                newJoke.setup = self.setup
                newJoke.punchline = self.punchline
                newJoke.rating = self.rating

                do {
                    try self.moc.save()
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print("Whoops! \(error.localizedDescription)")
                }
            }
        }
        .frame(minWidth: 400)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
