//
//  ViewController.swift
//  CustomHUDDemo
//
//  Created by Allen_Hsu on 2025/5/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func showLoadView(_ sender: Any) {
        CustomHUD.showMessage(message: "加載中", delay: 3)
    }
    
    @IBAction func showSuccessView(_ sender: Any) {
        CustomHUD.showSuccess(completion: nil)
    }
    
    @IBAction func showErrorView(_ sender: Any) {
        CustomHUD.showFail(completion: nil)
    }

}

