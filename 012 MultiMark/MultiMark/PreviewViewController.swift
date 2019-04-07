//
//  PreviewViewController.swift
//  MultiMark
//
//  Created by Paul Hudson on 07/04/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Down
import UIKit

class PreviewViewController: UIViewController {
    @IBOutlet var outputView: UITextView!

    var text: String = "" {
        didSet {
            let down = Down(markdownString: text)
            let style = "body { font: 200% sans-serif; }"
            let attributedString = try? down.toAttributedString(stylesheet: style)
            outputView.attributedText = attributedString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
