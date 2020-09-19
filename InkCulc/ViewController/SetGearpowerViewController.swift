import UIKit

class SetGearpowerViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "ギアパワー選択"

        //ギアパワービュー設定
        gearpowerView.setSize()
        if fromGearsetDetailViewController {
            gearpowerView.gearpowerNames = self.gearpowerNames!
        }
        setGearpowerViewAction()
        
        //キーボード設定
        gearpowerKeyboard.setSize(view: view)
        gearpowerKeyboard.enableLimitedKeys()
        setKeyboardAction()
        
        //決定ボタン
        doneButtonOutlet.layer.cornerRadius = doneButtonOutlet.frame.size.height / 4
        doneButtonOutlet.titleEdgeInsets.bottom += doneButtonOutlet.titleLabel!.font.pointSize / 8
        doneButtonEnable()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        //ギアパワービュー表示
        gearpowerView.highlightened = gearpowerView.blankIcon()
        gearpowerKeyboard.appear(view: view)
        
        //パート限定キーの有効化・無効化
        let part = gearpowerView.selectedMainGearpowerIcon()
        gearpowerKeyboard.enableLimitedKeys(part: part)
        
    }
    
    //--------------------IBアウトレットなど--------------------
    
    
    @IBOutlet weak var gearpowerView: GearpowerFrameView!
    @IBOutlet weak var gearpowerKeyboard: GearpowerKeyboardView!
    @IBAction func doneButton(_ sender: Any) { doneTapped() }
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    
    
    var weapon:Weapon?
    var gearpowerNames:[[String]]?
    
    var fromAddItemViewController = false
    var fromGearsetDetailViewController = false
    
    var closure = {(changedNames: [[String]]) -> Void in }
    
    
    //--------------------ギアパワービュー--------------------
    
    
    //ギアパワービュー初期設定
    func setGearpowerViewAction() {
        for n in 0...2 {
            for m in 0...3 {
                gearpowerView.icons[n][m].addTarget(self, action: #selector(iconTapped(sender:)), for: .touchUpInside)
            }
        }
    }
    
    //アイコンタップ
    @objc func iconTapped(sender: UIButton) {
        let coordinate = gearpowerView.coordinate(tag: sender.tag)
        gearpowerView.highlightened = coordinate
        
    }
    
    //--------------------キーボード--------------------
    
    
    //キーボード初期設定
    func setKeyboardAction() {
        //ギアパワーキー
        for n in 0...gearpowerKeyboard.keys.count - 1 {
            for m in 0...gearpowerKeyboard.keys[n].count - 1 {
                gearpowerKeyboard.keys[n][m].addTarget(self, action: #selector(keyTapped(sender:)), for: .touchUpInside)
            }
        }
        
        //デリートキー
        gearpowerKeyboard.deleteKey.addTarget(self, action: #selector(deleteTapped(sender:)), for: .touchUpInside)
    }
    
    //キータップ
    @objc func keyTapped(sender: UIButton) {
        let highlightened = gearpowerView.highlightened
        if highlightened != nil {
            let keyName = gearpowerKeyboard.getKeyName(tag: sender.tag)
            gearpowerView.setPower(keyName, to: highlightened!)
        }
        
        let part = gearpowerView.selectedMainGearpowerIcon()
        gearpowerKeyboard.enableLimitedKeys(part: part)
        
        doneButtonEnable()
    }
    
    //デリートキータップ
    @objc func deleteTapped(sender: UIButton) {
        
        var prevKey:[Int]?
        
        if let highlightened = gearpowerView.highlightened {
            
            if gearpowerView.gearpowerNames[highlightened[0]][highlightened[1]] != "未設定" {
                prevKey = highlightened
            } else if highlightened[1] > 0 {
                prevKey = [highlightened[0], highlightened[1] - 1]
            } else if highlightened[0] > 0 {
                prevKey = [highlightened[0] - 1, 3]
            } else {
                prevKey = [0, 0]
            }
            
        } else {
            
            prevKey = [2,3]
            
        }
        
        if gearpowerView.gearpowerNames[prevKey![0]][prevKey![1]] == "未設定" {
            prevKey = gearpowerView.blankIcon()
        }
        
        gearpowerView.setPower("未設定", to: prevKey!, highlightNext: false)
        
        let part = gearpowerView.selectedMainGearpowerIcon()
        gearpowerKeyboard.enableLimitedKeys(part: part)
        
        doneButtonEnable()
        
    }
    
    
    //--------------------画面遷移--------------------
    
    
    //
    func doneTapped() {
        
        if fromAddItemViewController {
            performSegue(withIdentifier: "gearsetDetail", sender: self)
        } else if fromGearsetDetailViewController {
            
            self.navigationController?.popViewController(animated: true)
            gearpowerNames = gearpowerView.gearpowerNames
            closure(gearpowerNames!)
        
        }
        
    }
    
    func doneButtonEnable(bool:Bool) {
        
        if bool {
            //ボタン有効時
            UIView.animate(withDuration: 0.1, delay: 0,
                           options: .curveEaseInOut, animations: { () -> Void in
                            self.doneButtonOutlet.alpha = 1
                            self.doneButtonOutlet.layer.shadowColor = shadowColor
                            self.doneButtonOutlet.layer.shadowOffset = shadowOffset
                            self.doneButtonOutlet.layer.shadowRadius = shadowRadius
                            self.doneButtonOutlet.layer.shadowOpacity = shadowOpacity
            })
            
        } else {
            //ボタン無効時
            UIView.animate(withDuration: 0.1, delay: 0,
                           options: .curveEaseInOut, animations: { () -> Void in
                            self.doneButtonOutlet.alpha = 0.5
                            self.doneButtonOutlet.layer.shadowColor = UIColor.clear.cgColor
                            self.doneButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 0)
                            self.doneButtonOutlet.layer.shadowRadius = 0
                            self.doneButtonOutlet.layer.shadowOpacity = 0
            })
        }
        
    }
    
    func doneButtonEnable() {
        
        let finishEditing:Bool = gearpowerView.blankIcon() == nil
        doneButtonEnable(bool: finishEditing)
        
    }
    
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gearsetDetail" {
            let next = segue.destination as! GearsetDetailViewController
            let gearset = Gearset(weapon:weapon!)
            gearset.gearpowerNames = gearpowerView.gearpowerNames
            next.gearset = gearset
            next.fromSetGearpowerViewController = true
        }
        
    }
    
}
