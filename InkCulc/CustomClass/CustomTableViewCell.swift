import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var gearsetCardView: GearsetCardView!
    @IBOutlet weak var topLabel: UILabel!
    
    override var frame: CGRect {
        didSet {
            print("didSet")
            if frame.size.height > 0 {
                print("height > 0")
            }
        }
    }
    
    var gearset: Gearset? {
        didSet {
            
            frameView.layer.cornerRadius = cornerRadius
            frameView.clipsToBounds = true
            
            topLabel.backgroundColor = InkColor.yellow
            
            self.layer.shadowColor = shadowColor
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            
            gearsetCardView.gearset = self.gearset
        }
    }
    
}
