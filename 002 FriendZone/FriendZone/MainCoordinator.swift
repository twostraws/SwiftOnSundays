//
//  MainCoordinator.swift
//  FriendZone
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func configure(friend: Friend) {
        let vc = FriendViewController.instantiate()

        vc.coordinator = self
        vc.friend = friend
        navigationController.pushViewController(vc, animated: true)
    }

    func update(friend: Friend) {
        guard let vc = navigationController.viewControllers.first as? ViewController else {
            return
        }

        vc.update(friend: friend)
    }
}
