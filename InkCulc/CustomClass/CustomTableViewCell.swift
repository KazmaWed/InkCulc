import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    func set(weapon:Weapon) {
        //ブキ番号
        let weaponIndex = inkApi.weaponNum(of: weapon)
        itemImageView.image = inkApi.weaponImages[weaponIndex]
        itemNameLabel.text = inkApi.weaponList[weaponIndex].name
        
    }
    
}
