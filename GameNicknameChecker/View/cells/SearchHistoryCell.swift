//
//  SearchHistoryCell.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/30.
//

import UIKit

class SearchHistoryCell: UITableViewCell {
    @IBOutlet weak var searchKeywordLabel: UILabel!
    static var identifier: String = "SearchHistoryCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
