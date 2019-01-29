//
//  MemoryViewController.swift
//  Memorize
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    var memoryItem: MemoryItem!
    var blankCounter = 0

    let visibleText: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Georgia", size: 28)!,
        .foregroundColor: UIColor.black,
    ]

    let invisibleText: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Georgia", size: 28)!,
        .foregroundColor: UIColor.clear,
        .strikethroughStyle: 1,
        .strikethroughColor: UIColor.black
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        assert(memoryItem != nil, "You must provide an item before trying to show this view controller.")

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wordsTapped))
        textView.addGestureRecognizer(tapRecognizer)

        textView.attributedText = showText(for: memoryItem)
    }

    func showText(for memoryItem: MemoryItem) -> NSAttributedString {
        let words = memoryItem.text.components(separatedBy: " ")
        let output = NSMutableAttributedString()

        let space = NSAttributedString(string: " ", attributes: visibleText)

        for (index, word) in words.enumerated() {
            if index < blankCounter {
                let attributedWord = NSAttributedString(string: "\(word)", attributes: visibleText)
                output.append(attributedWord)
            } else {
                var strippedWord = word
                var punctuation: String?

                if ".,".contains(word.last!) {
                    punctuation = String(strippedWord.removeLast())
                }

                let attributedWord = NSAttributedString(string: "\(strippedWord)", attributes: invisibleText)
                output.append(attributedWord)

                if let symbol = punctuation {
                    let attributedPunctuation = NSAttributedString(string: symbol, attributes: visibleText)
                    output.append(attributedPunctuation)
                }
            }

            output.append(space)
        }

        return output
    }


    @objc func wordsTapped() {
        blankCounter += 1
        textView.attributedText = showText(for: memoryItem)
    }
}
