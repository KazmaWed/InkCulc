import UIKit

class AddItemViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイトル
        title = "ブキ選択"
        
        //ブキリスト
        weaponsGrouped = inkApi.weaponsGroupedByMain()
        
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if firstAppear {
            collectionViewSetting()
            firstAppear = false
        }
        
        collectionView.reloadData()
        
        //セルサイズ再計算
        for path in collectionView.indexPathsForVisibleItems {
            let cell = collectionView.cellForItem(at: path)
            let weaponsetImageView = cell!.contentView.viewWithTag(1) as! WeaponSetImageView
            weaponsetImageView.setSize()
        }
        
    }
    
    
    //--------------------IB
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var weaponsGrouped:[[Weapon]]?
    var selectedItem:Weapon?
    var firstAppear = true
    
    var imageFrame:CGRect?
    var cardFrame:CGRect?
    
    
    //--------------------メソッド--------------------
    
    
    func collectionViewSetting() {
        
        collectionView.delaysContentTouches = false
        
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 12
        let cellSize:CGFloat = (view.frame.size.width - margin * 4 - 1 ) / 3
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        
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
    
    //セクション内アイテム数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemNum = weaponsGrouped![section].count
        return itemNum
    }
    
    //セル設定
    func collectionView(_ collectionView: UICollectionView,  cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let weapon = weaponsGrouped![indexPath.section][indexPath.row]
        
        let cell:UICollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.isUserInteractionEnabled = true
        
        let card = cell.contentView.viewWithTag(1)!
        card.layer.cornerRadius = cornerRadius
        card.shadow()
        
        let weaponsetImageView = cell.contentView.viewWithTag(2) as! WeaponSetImageView
        weaponsetImageView.weapon = weapon
        weaponsetImageView.setSize()
        
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
        
        //セルないビュー
        let cell = collectionView.cellForItem(at: indexPath)!
        let card = cell.contentView.viewWithTag(1)!
        let image = cell.contentView.viewWithTag(2)!
        //スクロール量
        let contentOffset = collectionView.contentOffset.y
        
        let cardX = card.frame.origin.x + cell.frame.origin.x
        let cardY = card.frame.origin.y + cell.frame.origin.y - contentOffset
        let cardSize = card.frame.size
        let cardOrigin = CGPoint(x: cardX, y: cardY)
        
        let imageX = image.frame.origin.x
        let imageY = image.frame.origin.y
        let imageSize = image.frame.size
        let imageOrigin = CGPoint(x: imageX, y: imageY)
        
        cardFrame = CGRect(origin: cardOrigin, size: cardSize)
        imageFrame = CGRect(origin: imageOrigin, size: imageSize)
        
        selectedItem = weaponsGrouped![indexPath.section][indexPath.row]
        self.performSegue(withIdentifier: "setGearpower", sender: self)
        
    }
    
    
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "setGearpower" {
            let next = segue.destination as! SetGearpowerViewController
            next.fromAddItemViewController = true
            next.weapon = selectedItem
            next.imageFrame = imageFrame
            next.cardFrame = cardFrame
        }
        
    }
    
}

