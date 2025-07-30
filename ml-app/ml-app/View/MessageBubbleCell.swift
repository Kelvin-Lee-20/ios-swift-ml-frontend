//
//  MessageBubbleCell.swift
//  ml-app
//
//  Created by Kelvin on 30/7/2025.
//

import UIKit

class MessageBubbleCell: UITableViewCell {
    
    static let identifier = "MessageBubbleCell"
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
    }
    
    func updateCell(with message: Message) {
        messageLabel.text = message.text
        if message.isFromServer {
            
            bubbleView.backgroundColor = .systemYellow
            messageLabel.textColor = .black
            bubbleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.leading.equalToSuperview().offset(16)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            }
            
        } else {

            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            bubbleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.trailing.equalToSuperview().offset(-16)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
