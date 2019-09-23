//
//  ContentView.swift
//  DadJokes
//
//  Created by Paul Hudson on 22/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

// This was our original ContentView, using List and NavigationView
struct OldContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Joke.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Joke.setup, ascending: true)
    ]) var jokes: FetchedResults<Joke>
    @State var showingAddJoke = false

    var body: some View {
        NavigationView {
            List {
                ForEach(jokes, id: \.setup) { joke in
                    NavigationLink(destination: Text(joke.punchline)) {
                        EmojiView(for: joke.rating)
                        Text(joke.setup)
                    }
                }.onDelete(perform: removeJokes)
            }
            .navigationBarTitle("All Groan Up")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
                self.showingAddJoke.toggle()
            })
        }
        .sheet(isPresented: $showingAddJoke) {
            AddView().environment(\.managedObjectContext, self.moc)
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

// This is the newer ContentView, using a scroll view, gestures, and rotating cards
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Joke.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Joke.setup, ascending: true)
    ]) var jokes: FetchedResults<Joke>
    @State private var showingAddJoke = false

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color("Start"), Color("Middle"), Color("End")]), startPoint: .top, endPoint: .bottom)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(jokes, id: \.setup) { joke in
                        JokeCard(joke: joke)
                    }
                }.padding()
            }

            Button("Add Joke") {
                self.showingAddJoke.toggle()
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .offset(y: 50)
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showingAddJoke) {
            AddView().environment(\.managedObjectContext, self.moc)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
