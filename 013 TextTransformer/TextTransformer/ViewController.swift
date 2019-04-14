//
//  ViewController.swift
//  TextTransformer
//
//  Created by Paul Hudson on 14/04/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet var input: NSTextField!
    @IBOutlet var type: NSSegmentedControl!
    @IBOutlet var output: NSTextField!
    let zalgoCharacters = ZalgoCharacters()

    override func viewDidLoad() {
        super.viewDidLoad()

        typeChanged(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func typeChanged(_ sender: Any) {
        switch type.selectedSegment {
        case 0:
            output.stringValue = rot13(input.stringValue)
        case 1:
            output.stringValue = similar(input.stringValue)
        case 2:
            output.stringValue = strike(input.stringValue)
        default:
            output.stringValue = zalgo(input.stringValue)
        }
    }

    @IBAction func copyToPasteboard(_ sender: Any) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(output.stringValue, forType: .string)
    }

    func controlTextDidChange(_ obj: Notification) {
        typeChanged(self)
    }

    func rot13(_ input: String) -> String {
        return ROT13.string(input)
    }

    func similar(_ input: String) -> String {
        var output = input

        output = output.replacingOccurrences(of: "a", with: "а")
        output = output.replacingOccurrences(of: "e", with: "е")
        output = output.replacingOccurrences(of: "i", with: "і")
        output = output.replacingOccurrences(of: "o", with: "о")

        output = output.replacingOccurrences(of: "A", with: "А")
        output = output.replacingOccurrences(of: "E", with: "Е")
        output = output.replacingOccurrences(of: "I", with: "І")
        output = output.replacingOccurrences(of: "P", with: "Р")

        return output
    }

    func strike(_ input: String) -> String {
        var output = ""

        for letter in input {
            output.append(letter)

            output.append("\u{0335}")
        }

        return output
    }

    func zalgo(_ input: String) -> String {
        var output = ""

        for letter in input {
            output.append(letter)

            for _ in 1...Int.random(in: 1...8) {
                output.append(zalgoCharacters.above.randomElement())
            }

            for _ in 1...Int.random(in: 1...3) {
                output.append(zalgoCharacters.inline.randomElement())
            }

            for _ in 1...Int.random(in: 1...8) {
                output.append(zalgoCharacters.below.randomElement())
            }
        }

        return output
    }
}

extension String {
    mutating func append(_ str: String?) {
        guard let str = str else { return }
        append(str)
    }
}
