//
//  ViewController.swift
//  MultiMark
//
//  Created by Paul Hudson on 07/04/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    var additionalWindows = [UIWindow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }

            guard let newScreen = notification.object as? UIScreen else { return }
            let screenDimensions = newScreen.bounds

            let newWindow = UIWindow(frame: screenDimensions)
            newWindow.screen = newScreen

            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController else {
                fatalError("Unable to find PreviewViewController")
            }

            newWindow.rootViewController = vc
            newWindow.isHidden = false
            self.additionalWindows.append(newWindow)

            self.textViewDidChange(self.textView)
        }

        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }

            guard let oldScreen = notification.object as? UIScreen else { return }

            if let window = self.additionalWindows.firstIndex(where: {
                $0.screen == oldScreen
            }) {
                self.additionalWindows.remove(at: window)
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if let preview = additionalWindows.first?.rootViewController as? PreviewViewController {
            preview.text = textView.text
        }

        if let navController = splitViewController?.viewControllers.last as? UINavigationController {
            if let preview = navController.topViewController as? PreviewViewController {
                preview.text = textView.text
            }
        }
    }
}

