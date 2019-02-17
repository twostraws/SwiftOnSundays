//
//  WordSearch.swift
//  Wordsearch
//
//  Created by Paul Hudson on 17/02/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

enum PlacementType: CaseIterable {
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft

    var movement: (x: Int, y: Int) {
        switch self {
        case .leftRight:
            return (1, 0)
        case .rightLeft:
            return (-1, 0)
        case .upDown:
            return (0, 1)
        case .downUp:
            return (0, -1)
        case .topLeftBottomRight:
            return (1, 1)
        case .topRightBottomLeft:
            return (-1, 1)
        case .bottomLeftTopRight:
            return (1, -1)
        case .bottomRightTopLeft:
            return (-1, -1)
        }
    }
}


enum Difficulty {
    case easy
    case medium
    case hard

    var placementTypes: [PlacementType] {
        switch self {
        case .easy:
            return [.leftRight, .upDown].shuffled()

        case .medium:
            return [.leftRight, .rightLeft, .upDown, .downUp].shuffled()

        case .hard:
            return PlacementType.allCases.shuffled()
        }
    }
}


struct Word: Codable {
    var text: String
    var clue: String
}


class Label {
    var letter: Character = " "
}


class WordSearch {
    var words = [Word]()
    var gridSize = 10

    var labels = [[Label]]()
    var difficulty = Difficulty.hard
    var numberOfPages = 10

    let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }

    func makeGrid() {
        labels = (0 ..< gridSize).map { _ in
            (0 ..< gridSize).map { _ in Label() }
        }

        _ = placeWords()
        fillGaps()
        printGrid()
    }

    private func fillGaps() {
        for column in labels {
            for label in column {
                if label.letter == " " {
                    label.letter = allLetters.randomElement()!
                }
            }
        }
    }

    func printGrid() {
        for column in labels {
            for row in column {
                print(row.letter, terminator: "")
            }

            print("")
        }
    }

    private func labels(fromX x: Int, y: Int, word: String, movement: (x: Int, y: Int)) -> [Label]? {
        var returnValue = [Label]()

        var xPosition = x
        var yPosition = y

        for letter in word {
            let label = labels[xPosition][yPosition]

            if label.letter == " " || label.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }

        return returnValue
    }

    private func tryPlacing(_ word: String, movement: (x: Int, y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))

        let rows = (0 ..< gridSize).shuffled()
        let cols = (0 ..< gridSize).shuffled()

        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength

                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: col, y: row, word: word, movement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnValue[index].letter = letter
                        }

                        return true
                    }
                }
            }
        }

        return false
    }

    private func place(_ word: Word) -> Bool {
        let formattedWord = word.text.replacingOccurrences(of: " ", with: "").uppercased()

        return difficulty.placementTypes.contains {
            tryPlacing(formattedWord, movement: $0.movement)
        }
    }

    private func placeWords() -> [Word] {
        return words.shuffled().filter(place)
    }

    func render() -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let margin = pageRect.width / 10

        let availableSpace = pageRect.width - (margin * 2)
        let gridCellSize = availableSpace / CGFloat(gridSize)

        let gridLetterFont = UIFont.systemFont(ofSize: 16)
        let gridLetterStyle = NSMutableParagraphStyle()
        gridLetterStyle.alignment = .center

        let gridLetterAttributes: [NSAttributedString.Key: Any] = [
            .font: gridLetterFont,
            .paragraphStyle: gridLetterStyle
        ]

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        return renderer.pdfData { ctx in
            for _ in 0 ..< numberOfPages {
                ctx.beginPage()

                _ = makeGrid()

                // WRITE GRID
                for i in 0 ... gridSize {
                    let linePosition = CGFloat(i) * gridCellSize

                    ctx.cgContext.move(to: CGPoint(x: margin, y: margin + linePosition))
                    ctx.cgContext.addLine(to: CGPoint(x: margin + (CGFloat(gridSize) * gridCellSize), y: margin + linePosition))

                    ctx.cgContext.move(to: CGPoint(x: margin + linePosition, y: margin))
                    ctx.cgContext.addLine(to: CGPoint(x: margin + linePosition, y: margin + (CGFloat(gridSize) * gridCellSize)))
                }

                ctx.cgContext.setLineCap(.square)
                ctx.cgContext.strokePath()

                // DRAW LETTERS
                var xOffset = margin
                var yOffset = margin

                for column in labels {
                    for label in column {
                        let size = String(label.letter).size(withAttributes: gridLetterAttributes)
                        let yPosition = (gridCellSize - size.height) / 2
                        let cellRect = CGRect(x: xOffset, y: yOffset + yPosition, width: gridCellSize, height: gridCellSize)
                        String(label.letter).draw(in: cellRect, withAttributes: gridLetterAttributes)
                        xOffset += gridCellSize
                    }

                    xOffset = margin
                    yOffset += gridCellSize
                }
            }
        }
    }
}
