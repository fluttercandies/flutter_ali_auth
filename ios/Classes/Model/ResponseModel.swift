//
//  ResponseModel.swift
//  ali_auth
//
//  Created by kangkang on 2022/9/30.
//

import ATAuthSDK
import Foundation

struct ResponseModel: Codable {
    var resultCode: String?
    var msg: String?
    var requestId: String?
    var token: String?
    var innerMsg: String?
    var innerCode: String?

    // {msg: AppID、Appkey解析成功, resultCode: 600000, requestId: 481a2c9b50264cf3}
    init(_ data: [String: Any]) {
        self.resultCode = data["resultCode"] as? String
        self.msg = data["msg"] as? String
        self.requestId = data["requestId"] as? String
        self.token = data["token"] as? String
        self.innerMsg = data["innerMsg"] as? String
        self.innerCode = data["innerCode"] as? String
//        if let carrierFailedResultData = data["carrierFailedResultData"] {
//            self.carrierFailedResultData = carrierFailedResultData
//        }
    }

    init(_ data: [AnyHashable: Any]?) {
        self.resultCode = data?["resultCode"] as? String
        self.msg = data?["msg"] as? String
        self.requestId = data?["requestId"] as? String
        self.token = data?["token"] as? String
        self.innerMsg = data?["innerMsg"] as? String
        self.innerCode = data?["innerCode"] as? String
    }

    init(id: String?, code: String?, msg: String) {
        self.requestId = id ?? Date().timeStamp
        self.resultCode = code ?? PNSCodeSuccess
        self.msg = msg
    }

    init(code: String?, msg: String) {
        self.requestId = Date().timeStamp
        self.resultCode = code ?? PNSCodeSuccess
        self.msg = msg
    }

    init(msg: String) {
        self.requestId = Date().timeStamp
        self.resultCode = "600000"
        self.msg = msg
    }

    var json: [String: Any] {
        
        let jsonObject = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))
        return jsonObject as? [String: Any] ?? [:]
    }
}

extension Date {
    var timeStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return String(timeInterval).replacingOccurrences(of: ".", with: "")
    }
}
