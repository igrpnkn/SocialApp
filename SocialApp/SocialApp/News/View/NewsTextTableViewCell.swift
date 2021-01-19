//
//  NewsTextTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsTextTableViewCell: UITableViewCell {

    @IBOutlet weak var postedText: UILabel!
    
    @IBAction func expandText(_ sender: Any) {
        self.postedText.numberOfLines = 0
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(text: String?) {
        if let text = text {
            self.postedText.text = text
        }
    }
    
}
