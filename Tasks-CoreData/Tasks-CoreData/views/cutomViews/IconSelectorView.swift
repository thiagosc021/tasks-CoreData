//
//  IconSelectorView.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/17/22.
//

import UIKit

class IconSelectorView: UIView {

    private static var icons = ["calendar.circle",
                                "book.circle",
                                "paperplane.circle",
                                "newspaper.circle" ,
                                "newspaper.circle",
                                "bookmark.circle",
                                "graduationcap.circle",
                                "personalhotspot.circle",
                                "heart.circle",
                                "bolt.circle",
                                "camera.circle",
                                "message.circle"]
    
    
    var selectIcon: ((String?) -> Void)?

    //MARK: Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    //MARK: Helpers
    func setupView() {
        for button in iconButtons {
            addSubview(button)
        }
        addSubview(colorButtonsVerticalStackView)
        addSubview(colorButtonsHorizontalStackViewRow1)
        addSubview(colorButtonsHorizontalStackViewRow2)
        
        for i in 0...5 {
            colorButtonsHorizontalStackViewRow1.addArrangedSubview(iconButtons[i])
        }
        
        for i in 6...11 {
            colorButtonsHorizontalStackViewRow2.addArrangedSubview(iconButtons[i])
        }
        
        colorButtonsVerticalStackView.addArrangedSubview(colorButtonsHorizontalStackViewRow1)
        colorButtonsVerticalStackView.addArrangedSubview(colorButtonsHorizontalStackViewRow2)
        
        colorButtonsVerticalStackView.anchor(top: self.topAnchor,
                                             bottom: self.bottomAnchor,
                                             leading: self.leadingAnchor,
                                             trailing: self.trailingAnchor,
                                             paddingTop: 0.0, paddingBottom: 0.0, paddingLeft: 0.0, paddingRight: 0.0)
        
        iconButtons.forEach({ $0.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside) })
    }
        
    @objc func selectButton(sender: UIButton) {
        toggleButtonSelection(sender)
        let icon = IconSelectorView.icons[sender.tag]
        selectIcon?(icon)
    }
    
    private func toggleButtonSelection(_ sender: UIButton) {
        iconButtons.forEach({ $0.tintColor = .gray })
        sender.tintColor = .lightGray
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
    
    var iconButtons: [UIButton] = {
        var buttons: [UIButton] = []
        
        for (index, icon) in icons.enumerated() {
            let button = UIButton()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .large)
            let iconImage = UIImage(systemName: icon, withConfiguration: largeConfig)
            button.setImage(iconImage, for: .normal)
            button.tintColor = .gray
            button.imageView?.contentMode = .scaleToFill
            button.tag = index
            buttons.append(button)
        }
        
        return buttons
    }()

}
