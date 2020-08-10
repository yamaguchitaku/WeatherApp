//
//  ViewController.swift
//  WeatherApp
//
//  Created by 山口拓 on 2020/07/18.
//  Copyright © 2020 山口拓. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Label: UILabel!
    // 空の配列
    var rainfallArray = [String]()
    // 空の変数
    var check_element: String!
    var rainfallZero: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TapButton(_ sender: Any) {
        //関数getDataの実行処理
        getData()
        Label.text = rainfallZero
        print(rainfallZero)
    }
    //関数 getData を作成
    func getData() {
        let url = URL(string: "https://map.yahooapis.jp/weather/V1/place?coordinates=139.732293,35.663613&appid=dj00aiZpPXNpWmFJMG5LOTJ3aSZzPWNvbnN1bWVyc2VjcmV0Jng9YzM-")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request,
        completionHandler: { (data, response, error) in
        let parser: XMLParser? = XMLParser(data: data!)
        parser!.delegate = self
        parser!.parse()
        print(parser!)
        })
        //タスク開始
        task.resume()
    }
    //解析開始
    func parserDidStartDocument(_ parser: XMLParser) {
    }
    //解析　要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        check_element = elementName
    }
    //解析　要素内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string != "\n" {
            if check_element == "Rainfall" {
                //要素がRainfallの場合値を取得する
                rainfallArray.append(string)
                print(rainfallArray)
            }
        }
    }
    //解析　要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if check_element == "Rainfall" {
            var rainfallTotal = rainfallArray[0]
            //                print(rainfallTotal)
            for i in 1..<rainfallArray.count {
                //rainfallの値が複数取得された場合一つにまとめる
                rainfallTotal = rainfallTotal + rainfallArray[i]
            }
            //               print(rainfallTotal)
        }
    }
    //    解析　終了時
    func parserDidEndDocument(_ parser: XMLParser) {
    }
    //解析_エラー発生時
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
}
