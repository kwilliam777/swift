//
//  MyViewController.swift
//  study1
//
//  Created by 김응진 on 2021/05/09.
//

import UIKit

class MyViewController: UIViewController {
    var button: UIButton!
    var label: UILabel!
    var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button = makeButton()
        self.imageView = makeImageView()
        self.label = makeLabel()
        
        button.addTarget(self, action: #selector(self.tapButton(_:)), for: UIControl.Event.touchDown)
        
        self.view.backgroundColor = .white
    }
    
    func makeButton() -> UIButton {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.setTitle("change", for: UIControl.State.normal)
        
        let centerX: NSLayoutConstraint
        centerX = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerX.isActive = true
        
        let centerY: NSLayoutConstraint
        centerY = button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -230)
        centerY.isActive = true
        return button
    }
    
    func makeLabel() -> UILabel {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        label.text = "let it purple"
        
        let centerX: NSLayoutConstraint
        centerX = label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerX.isActive = true
        
        let centerY: NSLayoutConstraint
        centerY = label.centerYAnchor.constraint(equalTo: self.button.centerYAnchor, constant: 100)
        centerY.isActive = true
        
        return label
    }
    
    func makeImageView() -> UIImageView {
        let imageView: UIImageView = UIImageView(image: UIImage(named: "다운로드.jpeg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        let centerX: NSLayoutConstraint
        centerX = imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        centerX.isActive = true
        
        let centerY: NSLayoutConstraint
        centerY = imageView.centerYAnchor.constraint(equalTo: self.button.centerYAnchor, constant: 350)
        centerY.isActive = true
        
        let width: NSLayoutConstraint
        width = imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        width.isActive = true
        
        let ratio: NSLayoutConstraint
        ratio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 2)
        ratio.isActive = true
        
        return imageView
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.imageView.image = UIImage(named: "다운로드2.jpeg")
            self.label.textColor = .purple
        } else {
            sender.isSelected = false
            self.imageView.image = UIImage(named: "다운로드.jpeg")
            self.label.textColor = .black
        }
    }
}
