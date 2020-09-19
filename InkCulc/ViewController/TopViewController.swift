import UIKit
class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //----------ナビゲーションバー----------
        
        title = "ギアセット"
        
        //ブキ情報・画像ロード
        if UserDefaults.standard.object(forKey: "weaponImages") != nil {
            
            let data = UserDefaults.standard.object(forKey: "weaponInfo")  as! Data
            inkApi.weaponInfo = try! JSONDecoder().decode(WeaponInfo.self, from: data)
            
            inkApi.weaponImageData = UserDefaults.standard.array(forKey: "weaponImages") as! [Data]
            inkApi.decodeWeaponInfo()
            inkApi.dataToUIImage()
            
            //API通信
            inkApi.getWeapons(closure: { () -> Void in
                //ブキ情報保存
                let data = try! JSONEncoder().encode(inkApi.weaponInfo)
                UserDefaults.standard.set(data, forKey: "weaponInfo")
                print("Data redownloaded...")
            })
            
        }
        
        //初回のみ画像ダウンロード
        if UserDefaults.standard.object(forKey: "weaponInfo") == nil {
            
            //API通信
            inkApi.getWeapons(closure: { () -> Void in
                
                //ブキ情報保存
                let data = try! JSONEncoder().encode(inkApi.weaponInfo)
                UserDefaults.standard.set(data, forKey: "weaponInfo")
                print("Data downloaded...")
                
                //画像取得
                inkApi.getWeaponImages(closure: { () -> Void in
                    let data = inkApi.weaponImageData
                    UserDefaults.standard.set(data, forKey: "weaponImages")
                    print("Image downloaded")
                })
                
            })
            
        }
        
        
        
        if Static.gearsets.count == 0 {
            
        } else {
            
        }
        
        
        //追加ボタン
        var addBarButtonItem: UIBarButtonItem!
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        
        //ナビゲーションバーに追加
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.navigationController?.navigationBar.tintColor = .white
        
        //----------テーブルビュー----------
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
        tableView.delaysContentTouches = false
        
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
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                                      for: indexPath) as! CustomTableViewCell
        
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = cellSelectedBgView
        
        cell.gearsetCardView.frame.size.width = view.frame.size.width - 16
        cell.gearsetCardView.setSize()
        cell.gearset = gearset
        
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
    
    //ハイライト
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if !isEditing {
            UIView.animate(withDuration: 0.3) {
                tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            }
        }
    }
    
    //アンハイライト
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 先にデータを削除しないと、エラーが発生します。
        Static.gearsets.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //選択解除時のデリゲートメソッド
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        print(indexPath.row)
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.size.width - 16) * 2 / 3 + 8
    }
 
    
    //----------編集モード----------

}
