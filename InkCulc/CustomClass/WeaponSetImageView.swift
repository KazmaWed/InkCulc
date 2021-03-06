import UIKit

class WeaponSetImageView: UIView {
    
    var mainImageView  = UIImageView()
    var subImageView = UIImageView()
    var specialImageView = UIImageView()
    var weaponNameLabel = UILabel()
    
    override var frame: CGRect {
        didSet {
            setSize()
        }
    }
    
    var weapon:Weapon? {
        didSet {
            let weaponIndex = inkApi.weaponNum(of: weapon!)
            var weaponNameString = weapon!.name
            if weapon!.collectionName! != "" {
                weaponNameString = weapon!.collectionName!
            }
            
            let subFileName = weapon!.sub + ".png"
            let specialFilelName = weapon!.special + ".png"
            mainImageView.image = inkApi.weaponImages[weaponIndex]
            subImageView.image = UIImage(named: subFileName)
            specialImageView.image = UIImage(named: specialFilelName)
            weaponNameLabel.text = weaponNameString
        }
    }
    
    func setSize() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let weaponImageSize = width * 0.72
        let subSpecialImageSize = width * 0.2
        let subSpecialImageGap = (weaponImageSize - subSpecialImageSize * 2) / 3
        let buttonInset = height / 16
        let labelHeight = height - weaponImageSize - buttonInset
        
        mainImageView.frame = CGRect(x: 0, y: 0, width: weaponImageSize, height: weaponImageSize)
        
        subImageView.frame = CGRect(x: width - subSpecialImageSize, y: subSpecialImageGap,
                                    width: subSpecialImageSize, height: subSpecialImageSize)
        specialImageView.frame = CGRect(x: width - subSpecialImageSize,
                                        y: subSpecialImageSize + subSpecialImageGap * 2,
                                        width: subSpecialImageSize, height: subSpecialImageSize)
        
        let fontSize = width / 8
        weaponNameLabel.font = UIFont(name: "bananaslipplus", size: fontSize)
        if weaponNameLabel.text == "" { weaponNameLabel.text = "ブキ名" }
        weaponNameLabel.frame.origin = CGPoint(x: 0, y: weaponImageSize)
        weaponNameLabel.frame.size.width = width
        weaponNameLabel.frame.size.height = labelHeight
        weaponNameLabel.textAlignment = .center
        
        self.addSubview(mainImageView)
        self.addSubview(subImageView)
        self.addSubview(specialImageView)
        self.addSubview(weaponNameLabel)
        
        self.backgroundColor = UIColor.clear
        
//        self.backgroundColor = UIColor.green
//        weaponNameLabel.backgroundColor = UIColor.blue
        
    }
    
}
