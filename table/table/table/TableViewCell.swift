//
//  TableViewCell.swift
//  table
//
//  Created by 김응진 on 2021/05/16.
//

import UIKit

class TableViewCell: UITableViewCell {
    var cellLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func cellSetting() {
        self.labelSetting()
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func labelSetting() {
        self.addSubview(self.cellLabel)
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.text = "Hello"
    }
}
