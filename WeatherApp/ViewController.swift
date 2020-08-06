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
    //空の配列
    var RainfallArray: [String] = []
    var Enclosure: [String] = []
    //空の変数
    var check_element: String!
    var Rainfall: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TapButton(_ sender: Any) {
        getData()
    }
    func getData(){
        let url = URL(string: "https://map.yahooapis.jp/weather/V1/place?coordinates=139.732293,35.663613&appid=dj00aiZpPXNpWmFJMG5LOTJ3aSZzPWNvbnN1bWVyc2VjcmV0Jng9YzM-")!  //URLを生成
        let request = URLRequest(url: url)               //Requestを生成
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in  //非同期で通信を行う
            guard let data = data else { return }
                let parser: XMLParser? = XMLParser(data: data)
                parser!.delegate = self
                parser!.parse()
                print(parser!)
        }
        task.resume()
    }
    //解析　開始時
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    //解析 要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName:String?, attributes attributesDict: [String : String]) {
        check_element = elementName
    }
    //解析　要素内の値を取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if  string != "\n" {
            if check_element == "Rainfall" {
                //要素がRainfallの場合、値を取得する
                RainfallArray.append(string)
//                           print(RainfallArray)
            }
        }
    }
    //解析　要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI : String?, qualifiedName qName:String?)
    {
        if check_element == "Rainfall" {
            Rainfall = ""
//         print(Rainfall!)
            for i in 0..<RainfallArray.count {
                //Rainfallの値が複数取得された場合一つにまとめる
                Rainfall = Rainfall + RainfallArray[i]
            }
          print(Rainfall!)
        RainfallArray = [String]()
    }
    }
    //解析　終了時
    func parserDidEndDocument(_ parser: XMLParser) {
    }
    //解析_エラー発生時
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
}
