//
//  GearsetCardView.swift
//  InkCulc
//
//  Created by KazMacBook Pro on 2020/09/18.
//  Copyright © 2020 KAZMA WED. All rights reserved.
//

import UIKit

class GearsetCardView: UIView {

    //横縦比2:1
    override var frame: CGRect {
        didSet {
                setSize()
        }
    }
    
    var gearset:Gearset? {
        didSet {
            let weapon = gearset!.weapon
            let gearpowerNames = gearset!.gearpowerNames!
            
            weaponSetImageView.set(weapon: weapon)
            gearpowerFrameView.gearpowerNames = gearpowerNames
            gearpowerFrameView.isUserInteractionEnabled = false
        }
    }
    
    var withShadow:Bool = false {
        didSet {
            self.layer.shadowColor = shadowColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    var weaponSetImageView = WeaponSetImageView()
    var gearpowerFrameView = GearpowerFrameView()

    func setSize() {
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = cornerRadius
        
        let contentInset = frame.size.width / 30
        let bottomInset = frame.size.width / 42
        let weaponSetImageWidthProportion:CGFloat = 5
        let gearpowerFrameWidthProportion:CGFloat = 6
        let proportionSum = weaponSetImageWidthProportion + gearpowerFrameWidthProportion
        
        let weaponSetImageWidth = (frame.size.width - contentInset * 3) * weaponSetImageWidthProportion / proportionSum
        let weaponSetImageHeight = weaponSetImageWidth * 4 / 5
        let weaponSetImageY = (frame.size.height - weaponSetImageHeight - bottomInset) / 2
        let gearpowerFrameWidth = (frame.size.width - contentInset * 3) * gearpowerFrameWidthProportion / proportionSum
        let gearpowerFrameHeight = gearpowerFrameWidth * 4 / 5
        let gearpowerFrameY = (frame.size.height - gearpowerFrameHeight - bottomInset) / 2
        
        weaponSetImageView.frame = CGRect(x: contentInset, y: weaponSetImageY,
                                          width: weaponSetImageWidth, height: weaponSetImageHeight)
        gearpowerFrameView.frame = CGRect(x: contentInset * 2 + weaponSetImageWidth, y: gearpowerFrameY,
                                          width: gearpowerFrameWidth, height: gearpowerFrameHeight)
            
        self.addSubview(weaponSetImageView)
        self.addSubview(gearpowerFrameView)
    }
    
}
