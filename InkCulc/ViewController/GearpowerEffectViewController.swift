import UIKit

class GearpowerEffectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        mainWeaponInfo = inkApi.mainWeaponInfo[inkApi.mainWeaponNum(of: weapon!)]
        increasedValues = inkApi.increasedValues(of: weapon!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if mainWeaponInfo!.mainPowerUpKey == "damage" {
            valueKey.text = "ダメージ"
        } else if mainWeaponInfo!.mainPowerUpKey == "range" {
            valueKey.text = "射程"
        }
        
        self.tableView.reloadData()
    }
    
    

    //--------------------IBアウトレット--------------------
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var valueKey: UILabel!
    
    var weapon:Weapon?
    var mainWeaponInfo:MainWeaponInfo?
    var increasedValues:[Int:Double]?
    

}


extension GearpowerEffectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        increasedValues!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let gearpower:Int = Int(gearpowerNums[indexPath.row])
        let increasedValue:Double = Double(Int(increasedValues![gearpower]! * 10)) / 10
        
        cell.textLabel?.text = String(gearpower) + " GP"
        cell.detailTextLabel?.text = String(increasedValue)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
}
