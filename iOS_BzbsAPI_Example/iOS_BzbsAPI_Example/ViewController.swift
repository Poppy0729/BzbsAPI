//
//  ViewController.swift
//  iOS_BzbsAPI_Example
//
//  Created by Saowalak Rungrat on 27/6/2566 BE.
//

import UIKit
import BzbsAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        BzbsAuthAPIs.shared.login(username: "test@a.com", password: "11111111") { result in
            print(result.userLogin)
        }
    }
}

