//
//  ViewController.swift
//  DeclarativeUI
//
//  Created by Paul Hudson on 03/03/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let navigationManager = NavigationManager()

        navigationManager.fetch { initialScreen in
            let vc = TableScreen(screen: initialScreen)
            vc.navigationManager = navigationManager
            navigationController?.viewControllers = [vc]
        }
    }
}

