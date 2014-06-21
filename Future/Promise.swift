//
//  Promise.swift
//  Future
//
//  Created by Maxim Zaks on 20.06.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

import Foundation

enum Result<T>{
    case Value(@auto_closure ()->T)
    case Error(@auto_closure ()->NSError)
}

struct Promise<T> {
    let result : ()->Result<T>
    
    init(task : ()->Result<T>){
        result = task
    }
    
    mutating func fulfill(handler : (T)->()){
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            switch self.result() {
                case .Value(let value):
                    dispatch_async(dispatch_get_main_queue()) {
                        let v = value()
                        handler(v)
                        self = Promise({.Value(v)})
                    }
                case .Error(let error):
                    dispatch_async(dispatch_get_main_queue()) {
                        let e = error()
                        self = Promise({.Error(e)})
                    }
                }
        }
    }
}