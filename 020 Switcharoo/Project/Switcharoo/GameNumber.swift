//
//  GameNumber.swift
//  Switcharoo
//
//  Created by Paul Hudson on 27/10/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct GameNumber: View {
    var text: String
    var value: Int

    var body: some View {
        VStack {
            Text(text)

            Text("\(value)")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity)
    }
}

struct GameNumber_Previews: PreviewProvider {
    static var previews: some View {
        GameNumber(text: "Score", value: 0)
    }
}
