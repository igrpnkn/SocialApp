//
//  FriendProfileDetailsTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 24.10.2020.
//

import UIKit

class FriendProfileDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var idProfile: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var work: UILabel!
    @IBOutlet weak var marriage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(status: String?, id: Int?, birthday: String?, city: String?, country: String?, occupation: String?, relation: Int?) {
        self.idProfile.text = "id" + String(id ?? 0)
        self.status.text = status ?? ""
        self.birthday.text = birthday ?? "no info"
        if city != nil && city != "" && country != nil && country != "" {
            self.city.text = "\(city!), \(country!)"
        } else {
            self.city.text = "\(city ?? "")"
            self.city.text = self.city.text ?? "" + "\(country ?? "")"
        }
        self.work.text = occupation ?? "no info"
        switch relation {
        case 0:
            self.marriage.text = "no info"
        case 1:
            self.marriage.text = "Not married"
        case 2:
            self.marriage.text = "Has a friend"
        case 3:
            self.marriage.text = "Engaged"
        case 4:
            self.marriage.text = "Married"
        case 5:
            self.marriage.text = "Complicated"
        case 6:
            self.marriage.text = "In active search"
        case 7:
            self.marriage.text = "Fallen in love"
        case 8:
            self.marriage.text = "In civil marriage"
        default:
            print("\nERROR - FriendProfileDetailsTableViewCell: Incorrect self.marriage in self.configureCell() method. Got relation: \(relation)\n")
        }
    }
}
