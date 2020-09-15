import UIKit

class DamageTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        makeDamageTaples()
        sortByDamage(of: 30.0)
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
                
                if damage >= of {
                    if n > 0 {
                        let prevTaple = eachWeaponTaples[n - 1]
                        sortedTaples.append(prevTaple)
                    }
                    sortedTaples.append(taple)
                }
                
            }
        }
        
    }
    
    
}


//--------------------テーブルビュー--------------------


extension DamageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedTaples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(sortedTaples[indexPath.row].0) \(sortedTaples[indexPath.row].1)"
        cell.detailTextLabel?.text = String(sortedTaples[indexPath.row].2)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
}
