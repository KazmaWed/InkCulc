import UIKit

class WeaponSetImageView: UIView {
    
    var mainImageView  = UIImageView()
    var subImageView = UIImageView()
    var specialImageView = UIImageView()
    var weaponNameLabel = UILabel()
    
    func setSize(width:CGFloat, height:CGFloat) {
        
        let weaponImageSize = width * 0.72
        let subSpecialImageSize = width * 0.2
        let subSpecialImageGap = (weaponImageSize - subSpecialImageSize * 2) / 3
        let labelHeight = height - weaponImageSize
        
        self.frame.size = CGSize(width: width, height: height)
        mainImageView.frame = CGRect(x: 0, y: 0, width: weaponImageSize, height: weaponImageSize)
        subImageView.frame = CGRect(x: width - subSpecialImageSize, y: subSpecialImageGap,
                                    width: subSpecialImageSize, height: subSpecialImageSize)
        specialImageView.frame = CGRect(x: width - subSpecialImageSize,
                                        y: subSpecialImageSize + subSpecialImageGap * 2,
                                        width: subSpecialImageSize, height: subSpecialImageSize)
        weaponNameLabel.frame = CGRect(x: 0, y: weaponImageSize, width: width, height: labelHeight)
        weaponNameLabel.font = UIFont(name: "bananaslipplus", size: 20)
        weaponNameLabel.textAlignment = .center
        
        self.addSubview(mainImageView)
        self.addSubview(subImageView)
        self.addSubview(specialImageView)
        self.addSubview(weaponNameLabel)
        
    }
    
    func set(weapon:Weapon) {
        
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
