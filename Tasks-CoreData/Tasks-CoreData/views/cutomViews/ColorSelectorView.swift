//
//  ColorSelectorView.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/15/22.
//

import UIKit

class ColorSelectorView: UIView {

    private static let colors = [UIColor.systemBlue,
                 UIColor.systemRed,
                 UIColor.systemCyan,
                 UIColor.systemGray,
                 UIColor.systemMint,
                 UIColor.systemPink,
                 UIColor.systemTeal,
                 UIColor.systemBrown,
                 UIColor.systemGreen,
                 UIColor.systemOrange,
                 UIColor.systemPurple,
                 UIColor.systemIndigo]
    
    var selectColor: ((UIColor?) -> Void)?

    //MARK: Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    //MARK: Helpers
    func setupView() {
        for button in colorButtons {
            addSubview(button)
        }
        addSubview(colorButtonsVerticalStackView)
        addSubview(colorButtonsHorizontalStackViewRow1)
        addSubview(colorButtonsHorizontalStackViewRow2)
        
        for i in 0...5 {
            colorButtonsHorizontalStackViewRow1.addArrangedSubview(colorButtons[i])
        }
        
        for i in 6...11 {
            colorButtonsHorizontalStackViewRow2.addArrangedSubview(colorButtons[i])
        }
        
        colorButtonsVerticalStackView.addArrangedSubview(colorButtonsHorizontalStackViewRow1)
        colorButtonsVerticalStackView.addArrangedSubview(colorButtonsHorizontalStackViewRow2)
        
        colorButtonsVerticalStackView.anchor(top: self.topAnchor,
                                             bottom: self.bottomAnchor,
                                             leading: self.leadingAnchor,
                                             trailing: self.trailingAnchor,
                                             paddingTop: 0.0, paddingBottom: 0.0, paddingLeft: 0.0, paddingRight: 0.0)
        
        colorButtons.forEach({ $0.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside) })
    }
        
    @objc func selectButton(sender: UIButton) {
        toggleButtonSelection(sender)
        let color = ColorSelectorView.colors[sender.tag]
        selectColor?(color)
        print(color.accessibilityName)
    }
    
    private func toggleButtonSelection(_ sender: UIButton) {
        colorButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
    }
    
    //MARK: Views
    var colorButtonsVerticalStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    var colorButtonsHorizontalStackViewRow1: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    var colorButtonsHorizontalStackViewRow2: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    var colorButtons: [UIButton] = {
        var buttons: [UIButton] = []
        
        for (index,color) in colors.enumerated() {
            let button = UIButton()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .large)
            let largeBoldCircleFill = UIImage(systemName: StringConstants.colorSelectorButtonImageNameNormal , withConfiguration: largeConfig)
            let largeBoldCircle = UIImage(systemName: StringConstants.colorSelectorButtonImageNameSelected, withConfiguration: largeConfig)
            button.setImage(largeBoldCircleFill, for: .normal)
            button.setImage(largeBoldCircle, for: .selected)
            button.tintColor = color
            button.imageView?.contentMode = .scaleToFill
            button.tag = index
            buttons.append(button)
        }
        
        return buttons
    }()
}
