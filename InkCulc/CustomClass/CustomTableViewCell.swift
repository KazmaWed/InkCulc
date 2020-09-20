import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var gearsetCardView: GearsetCardView!
    @IBOutlet weak var topLabel: UILabel!
    
    override var frame: CGRect {
        didSet {
            print("didSet")
            if frame.size.height > 0 {
                guard gearset != nil else { return }
                gearsetCardView.setSize()
            }
        }
    }
    
    var gearset: Gearset? {
        didSet {
            
            frameView.layer.cornerRadius = cornerRadius
            frameView.clipsToBounds = true
            
            topLabel.backgroundColor = InkColor.yellow
            
            self.shadow()
            
            gearsetCardView.gearset = self.gearset
			gearsetCardView.gearpowerFrameView.gearpowerNames = gearset!.gearpowerNames!
        }
    }
    
}
