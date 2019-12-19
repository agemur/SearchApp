//
//  RequestQueueService.swift
//  FrogogoTestApp
//
//  Created by User on 11/24/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class RequestRepository {
    static let imageDownload = RequestQueueService<URL>()
}

//Class for storing and canceling requests
class RequestQueueService<T: Hashable> {
    
    private var requestDic = [T: URLSessionTask]()
 
    func cancelRequest(by key: T) {
        guard requestDic.keys.contains(where: { $0 == key }) else {
            return
        }
        if requestDic[key]?.state == URLSessionTask.State.running {
            requestDic[key]?.cancel()
        }
        requestDic.removeValue(forKey: key)
    }
    
    func addRequest (_ request: URLSessionTask, for key: T) {
        cancelRequest(by: key)
        requestDic[key] = request
    }
}
