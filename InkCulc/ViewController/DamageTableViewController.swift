import UIKit

class DamageTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGray5

        makeDamageTaples()
        sortByDamage(of: threshold!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    //--------------------IBアウトレット--------------------
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var threshold:Double?
    var damageTaples:[[(String,String,Double)]] = []
    var sortedTaples:[(String,String,Double)] = []
    
    
    //--------------------メソッド--------------------
    
    
    func makeDamageTaples() {
        
        let bomb = inkApi.bombDamageRaw
        let special = inkApi.specialDamageRaw
        
        let bombTaples:[[(String,String,Double)]] = inkApi.damageArray(damageArrayRaw: bomb)
        let specialTaples:[[(String,String,Double)]] = inkApi.damageArray(damageArrayRaw: special)
        
        for taple in bombTaples {
            damageTaples.append(taple)
        }
        for taple in specialTaples {
            damageTaples.append(taple)
        }
        
    }
    
    func sortByDamage(of:Double) {
        
        for eachWeaponTaples in damageTaples {
            for n in 0...eachWeaponTaples.count - 1 {
                
                let taple = eachWeaponTaples[n]
                let damage:Double = taple.2
                var ifFound = false
                
                if damage >= of || n == eachWeaponTaples.count - 1 {
                    if n > 0 {
                        let prevTaple = eachWeaponTaples[n - 1]
                        sortedTaples.append(prevTaple)
                    }
                    sortedTaples.append(taple)
                    ifFound = true
                }
                if ifFound { break }
                
            }
        }
        
        let resorted = sortedTaples.sorted(by: { a, b -> Bool in
            return a.2 < b.2
        })
        sortedTaples = resorted
        
    }
    
    
}


//--------------------テーブルビュー--------------------


extension DamageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedTaples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let ifDecisive:Bool = self.threshold! <= sortedTaples[indexPath.row].2
        
        cell.imageView?.image = UIImage(named: sortedTaples[indexPath.row].0)
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        cell.textLabel?.text = "\(sortedTaples[indexPath.row].1)"
        cell.detailTextLabel?.text = String(sortedTaples[indexPath.row].2)
        
        if ifDecisive {
            cell.detailTextLabel?.textColor = InkColor.textBlue
        } else {
            cell.detailTextLabel?.textColor = UIColor.darkText
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
}
