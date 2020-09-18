import UIKit

class AddItemViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイトル
        title = "ブキ選択"
        
        //ブキリスト
        weaponsGrouped = inkApi.weaponsGroupedByMain()
        
        //コレクションビュー・カスタムセル登録
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: .main),
                                forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
        collextionViewSetting()
        collectionView.delaysContentTouches = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //セルのサイズ
        let cellSize = view.frame.size.width / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        //セル間隔
        layout.minimumInteritemSpacing = 0
        
        //適応
        collectionView.collectionViewLayout = layout
        
    }
    
    
    //--------------------
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var weaponsGrouped:[[Weapon]]?
    var selectedItem:Weapon?
    
    
    //--------------------メソッド--------------------
    
    
    func collextionViewSetting() {
        
        let layout = UICollectionViewFlowLayout()
        
        let cellSize:CGFloat = view.frame.size.width / 3 - 8
        let margin = (view.frame.size.width - cellSize * 3) / 4
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin * 2, left: margin, bottom: 0, right: margin)
        
        collectionView.collectionViewLayout = layout
        
    }
    
    
}


//----------------コレクションビュー--------------------


extension AddItemViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    //セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionNum = weaponsGrouped!.count
        return sectionNum
    }
    
    //セクションないアイテム数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemNum = weaponsGrouped![section].count
        return itemNum
    }
    
    //セル設定
    func collectionView(_ collectionView: UICollectionView,  cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let weapon = weaponsGrouped![indexPath.section][indexPath.row]
        let cell: CustomCollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                                                 for: indexPath) as! CustomCollectionViewCell
        cell.set(weapon:weapon)
        return cell
        
    }
    
    //インセット
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //ハイライト
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)!.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
        
    }
    
    //デハイライト
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)!.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
    
    //--------------------画面遷移--------------------
    
    
    //セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItem = weaponsGrouped![indexPath.section][indexPath.row]
        self.performSegue(withIdentifier: "setGearpower", sender: self)
        
    }
    
    
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "setGearpower" {
            let next = segue.destination as! SetGearpowerViewController
            next.fromAddItemViewController = true
            next.weapon = selectedItem
        }
        
    }
    
}

