//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by 林晓中 on 2024/11/27.
//  Copyright © 2024 Fanfu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    //类似ViewDidLoad
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //将消息气泡设计成圆弧形
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
