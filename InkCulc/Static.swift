import Foundation

let inkApi = InkAPI()

let gearPartNames = ["general","headgear","clothing","shoes"]
let allGearpowerNames = ["general":["インク効率アップ(メイン)","インク効率アップ(サブ)","インク回復力アップ",
                      "メイン性能アップ","サブ性能アップ","ヒト移動速度アップ","イカダッシュ速度アップ",
                      "スペシャル増加量アップ","スペシャル減少量ダウン","スペシャル性能アップ","復活時間短縮",
                      "スーパージャンプ時間短縮","相手インク影響軽減","爆風ダメージ軽減・改"],
                      "headgear":["スタートダッシュ","ラストスパート","逆境強化","カムバック"],
                      "clothing":["イカニンジャ","リベンジ","サーマルインク","復活ペナルティアップ"],
                      "shoes":["ステルスジャンプ","受け身術","対物攻撃力アップ"]]

let gearpowerNums = [0,3,6,9,10,12,13,15,16,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,41,42,44,45,47,48,51,54,57]

class Static {
    static var gearsets:[Gearset] = []
}