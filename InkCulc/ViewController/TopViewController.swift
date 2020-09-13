import UIKit
class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //----------ナビゲーションバー----------
        
        title = "ギアセット"
        
        //ギアセット仮登録
        Static.gearsets = []
        inkApi.getWeapons(closure: { () -> Void in
            inkApi.getWeaponImages(closure: { () -> Void in
                print("Downloaded...")
            })
        })
        
        //追加ボタン
        var addBarButtonItem: UIBarButtonItem!
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        
        //ナビゲーションバーに追加
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        
        //----------テーブルビュー----------
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
        
        //----------その他----------
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }


    //--------------------IBアウトレット・インスタンス--------------------
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedGearSet:Gearset?
    
    
    //--------------------メソッド--------------------
    
    
    //右上追加ボタン
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        tableView.reloadData()
        self.performSegue(withIdentifier: "addItem", sender: self)
    }
    
    
    //--------------------画面遷移--------------------
    
    
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addItem" {
            
            let next = segue.destination as! AddItemViewController
            
        } else if segue.identifier == "editGearset" {
            
            let next = segue.destination as! GearsetDetailViewController
            next.gearset = selectedGearSet!
            next.fromTopViewController = true
        }
        
    }
    
    
}


//--------------------テーブルビュー・セル--------------------


extension TopViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Static.gearsets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let gearset = Static.gearsets[indexPath.row]
        let weapon = gearset.weapon
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.set(weapon: weapon)
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedGearSet = Static.gearsets[indexPath.row]
        self.performSegue(withIdentifier: "editGearset", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}
