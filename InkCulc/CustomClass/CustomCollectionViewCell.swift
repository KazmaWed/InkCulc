import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var specialImageView: UIImageView!
    @IBOutlet weak var weaponNameLabel: UILabel!
    
    func set(weapon:Weapon) {
        
        cardView.layer.shadowOpacity = shadowOpacity
        cardView.layer.shadowRadius = shadowRadius
        cardView.layer.shadowOffset = shadowOffset
        cardView.layer.shadowColor = shadowColor
        cardView.layer.cornerRadius = cornerRadius
        
        let weaponIndex = inkApi.weaponNum(of: weapon)
        var weaponNameString = weapon.name
        if weapon.collectionName! != "" {
            weaponNameString = weapon.collectionName!
        }
        let subFileName = weapon.sub + ".png"
        let specialFilelName = weapon.special + ".png"
        mainImageView.image = inkApi.weaponImages[weaponIndex]
        subImageView.image = UIImage(named: subFileName)
        specialImageView.image = UIImage(named: specialFilelName)
        weaponNameLabel.text = weaponNameString

    }
    
}
