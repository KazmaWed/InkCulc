import UIKit
class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         
        //バックグラウンド
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_dark.png")!)
        
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
        self.navigationController?.navigationBar.tintColor = .white
        
        //----------テーブルビュー----------
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
        
        //----------その他----------
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //編集設定
        if Static.gearsets.count > 0 {
            navigationItem.leftBarButtonItem = editButtonItem
            tableView.allowsMultipleSelectionDuringEditing = true
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        
        print(editing)
    }
    

    //--------------------IBアウトレット・インスタンス--------------------
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedGearSet:Gearset?
    var viewWidth:CGFloat?
    
    
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

    //セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Static.gearsets.count
    }
    
    //セル設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let gearset = Static.gearsets[indexPath.row]
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        cell.selectedBackgroundView = cellSelectedBgView
        
        cell.set(gearset: gearset)
        
        return cell
        
    }
    
    //セルタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } else {
            selectedGearSet = Static.gearsets[indexPath.row]
            self.performSegue(withIdentifier: "editGearset", sender: self)
        }
        
    }
    
    //選択解除時のデリゲートメソッド
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 1, y: 1)
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width / 2
    }
 
    
    //----------編集モード----------

}
