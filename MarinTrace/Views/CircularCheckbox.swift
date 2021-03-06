//
//  CircularCheckbox.swift
//  MarinTrace
//
//  Created by Beck Lorsch on 6/7/20.
//  Copyright © 2020 Marin Trace. All rights reserved.
//

import UIKit

@IBDesignable class CircularCheckbox: UIButton {
    let uncheckedImage = UIImage(named: "circular_checkbox_empty")! as UIImage
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                if User.school == .MA {
                    self.setImage(UIImage(named: "circular_checkbox_filled_ma")! as UIImage, for: .normal)
                } else {
                    self.setImage(UIImage(named: "circular_checkbox_filled_branson")! as UIImage, for: .normal)
                }
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
