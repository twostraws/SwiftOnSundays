//
//  ViewController.swift
//  InnerPeace
//
//  Created by Paul Hudson on 03/02/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet var background: UIImageView!
    @IBOutlet var quote: UIImageView!

    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")

    // Images are taken from Unsplash – I've named them according to their photographer so you can add UI credit if you want.
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    var shareQuote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            if allowed {
                self.configureAlerts()
            }
        }
    }

    func updateQuote() {
        guard let backgroundImageName = images.randomElement() else {
            fatalError("Unable to read an image.")
        }

        background.image = UIImage(named: backgroundImageName)


        guard let selectedQuote = quotes.randomElement() else {
            fatalError("Unable to read a quote.")
        }

        shareQuote = selectedQuote
        quote.image = render(selectedQuote: selectedQuote)
    }

    func render(selectedQuote: Quote) -> UIImage {
        let insetAmount: CGFloat = 250
        let drawBounds = quote.bounds.inset(by: UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount))

        var quoteRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        var fontSize: CGFloat = 120
        var font: UIFont!

        var attrs: [NSAttributedString.Key: Any]!
        var str: NSAttributedString!

        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)!
            attrs = [.font: font, .foregroundColor: UIColor.white]

            str = NSAttributedString(string: selectedQuote.text, attributes: attrs)
            quoteRect = str.boundingRect(with: CGSize(width: drawBounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
        }

        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: format)

        return renderer.image { ctx in
            for i in 1...5 {
                ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i) * 2, color: UIColor.black.cgColor)
                str.draw(in: quoteRect)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateQuote()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuote()
    }

    @IBAction func shareTapped(_ sender: UIButton) {
        guard let quote = shareQuote else {
            fatalError("Attempting to share a non-existent quote.")
        }

        let ac = UIActivityViewController(activityItems: [quote.shareMessage], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = sender

        present(ac, animated: true)
    }

    func configureAlerts() {
        let center = UNUserNotificationCenter.current()

        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        let shuffled = quotes.shuffled()

        for i in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Inner Peace"
            content.body = shuffled[i].text

            let alertDate = Date().byAdding(days: i)
            var alertComponents = Calendar.current.dateComponents([.day, .month, .year], from: alertDate)
            alertComponents.hour = 10

//          let trigger = UNCalendarNotificationTrigger(dateMatching: alertComponents, repeats: false)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i) * 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

