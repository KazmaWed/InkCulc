import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var gearsetCardView: GearsetCardView!
    
    override var frame: CGRect {
        didSet {
            print("didSet")
        }
    }
    
    var gearset: Gearset? {
        didSet {
            self.layer.shadowColor = shadowColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            
            gearsetCardView.layer.cornerRadius = cornerRadius
            gearsetCardView.clipsToBounds = true
            gearsetCardView.gearset = self.gearset
        }
    }
    
}
