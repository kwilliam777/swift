//
//  MyViewController.swift
//  study3
//
//  Created by 김응진 on 2021/05/15.
//

import UIKit

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navigationItemSetting()
    }
    
    func navigationItemSetting() {
        self.navigationItem.title = "FirstViewController"
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(pressButton(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @IBAction func pressButton(_ sender: UIBarButtonItem) {
        let secondView = SecondViewController()
        self.navigationController?.pushViewController(secondView, animated: true)
        
    }
}
