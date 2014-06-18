//
//  Future.swift
//  Future
//
//  Created by Maxim Zaks on 16.06.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

import Foundation

enum FutureHandler<T>{
    case FulFilled((T)->())
    case Failed((NSError)->())
}

enum FutureResult<T>{
    case Result(@auto_closure ()->T)
    case Error(@auto_closure ()->NSError)
}

func future<T>(execution : ()->FutureResult<T>)(handler: FutureHandler<T>){
    var result : FutureResult<T>?
    dispatch_async(dispatch_get_global_queue(0, 0)) {
        result = execution()
        dispatch_async(dispatch_get_main_queue()) {
            switch handler {
            case .FulFilled(let fulfilled):
                switch result! {
                case .Result(let value):
                    fulfilled(value())
                case .Error : println("can't process error")
                }
            case .Failed(let failed):
                switch result! {
                case .Result: println("can't process result")
                case .Error(let error) : failed(error())
                }
            }
        }
    }
}