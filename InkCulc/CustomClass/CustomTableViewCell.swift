import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var weaponSetImageView: WeaponSetImageView!
    @IBOutlet weak var gearpowerFrameView: GearpowerFrameView!
    
    func set(gearset:Gearset) {
        
        weaponSetImageView.setSize()
        weaponSetImageView.set(weapon: gearset.weapon)
        
        gearpowerFrameView.isUserInteractionEnabled = false
        gearpowerFrameView.setSize()
        gearpowerFrameView.gearpowerNames = gearset.gearpowerNames!
        gearpowerFrameView.reloadIcon()
        
    }
    
}
