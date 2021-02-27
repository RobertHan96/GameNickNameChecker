//
//  SearchResultCell.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLaebl: UILabel!
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.isHidden = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        levelLabel.adjustsFontSizeToFitWidth = true
        serverNameLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
