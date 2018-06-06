//
//  ViewController.swift
//  MengTestGCMSwift
//
//  Created by mengJing on 2018/6/1.
//  Copyright © 2018年 mengJing. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
    
    func test1() {
        
        
//        let test:Array<UInt8> = "12345".bytes
//        print(test)
//
//        let result:String = String(bytes: test, encoding: String.Encoding.utf8)!
//        print(result)
        
        
//        let jsonData : NSData! = try! JSONSerialization.jsonObject(with: kkdata, options: []) as NSData?
//        let stringDic = try JSONSerialization.jsonObject(with: kkdata, options: []) as? [String : Any]
//        let stringDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
        
        // pwd:dc483e80a7a0bd9ef71d8cf973673924
        var dict:[String:Any] = ["user_mobile":"18700000054","password":"a12345dd6".md5()]
        let jsonData:NSData = try! JSONSerialization.data(withJSONObject: dict, options: []) as NSData
        let JSONString = String(data:jsonData as Data,encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let JSONString2 = String(data: jsonData as Data, encoding: String.Encoding.utf8)
    
        let key = Array<UInt8>(hex: "key 字符串")
        let nonce = Array<UInt8>(hex: "nonce 字符串")
        let plaintext:Array<UInt8> = (JSONString2?.bytes)!
    
        let gcm = GCM(iv: nonce, mode: .combined) // detached
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        print("GCM加密:\(encrypted.toHexString())");
        
        let encrypted2:Array<UInt8> = Array<UInt8>(hex: "a4aeba35b005b07bacb7119cb4e9f74d8cb1c96eea1830d6cd67b7cf2625a57f82930e4fe35ff06c447634d055d75aaeaa768db1b3dde84398fc3b6fdfdfce57884224c362fe4c681e764b1277ecc087fd119fb7a06826b5a9a660cc440e")
        
        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: nonce, mode: .combined)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }
        
        
        let decrypted = decrypt(encrypted2)
//        print("GCM解密"+decrypted.toHexString());
        
//        let result:String = String(bytes: decrypted, encoding: String.Encoding.utf8)!
//        let jsonData2:Data = result.data(using: .utf8)!
        
        let jsonData2:Data = Data(bytes: decrypted, count: decrypted.count)
        let dict2:[String:Any] = try! JSONSerialization.jsonObject(with: jsonData2, options: []) as! [String : Any]
        
        let mobile:String = dict2["user_mobile"] as! String
        let pwd:String = dict2["password"] as! String
        
        Digest.md5(pwd.bytes)
        print("GCM解密:\(mobile)=\(pwd)")

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("-----------------")
        test1()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

