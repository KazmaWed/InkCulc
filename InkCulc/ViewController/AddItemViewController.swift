import UIKit

class AddItemViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ブキ選択"
        
        //ブキリスト
        weaponsGrouped = inkApi.weaponsGroupedByMain()
        
        //コレクションビュー・カスタムセル登録
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
        collextionViewSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        layout.itemSize = CGSize(width: cellSize, height: cellSize * 0.9)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin * 2, left: margin, bottom: 0, right: margin)
        
        collectionView.collectionViewLayout = layout
        
    }
    
    
}

extension AddItemViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    //セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionNum = weaponsGrouped!.count
        return sectionNum
    }
    
    //セクションないアイテム数
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let itemNum = weaponsGrouped![section].count
        return itemNum
    }
    
    //セル設定
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let weapon = weaponsGrouped![indexPath.section][indexPath.row]
        let cell: CustomCollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                                                 for: indexPath) as! CustomCollectionViewCell
        cell.set(weapon:weapon)
        return cell
        
    }
    
    
    //--------------------画面遷移--------------------
    
    
    //セルタップ時
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
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

