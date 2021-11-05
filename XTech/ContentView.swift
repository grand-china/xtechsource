//
//  ContentView.swift
//  XTech
//
//  Created by Grand on 2021/11/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding().onAppear {
                testEasyPromise()
            }
    }
    
    func testEasyPromise() {
        print("Demo> testEasyPromise")
        EasyPromise().then { observer, result in
            print("task 1", result)
            observer.next("result 1")
        }.then { observer, result in
            print("task 2", result)
            observer.next("result 2")
        }.then { observer, result in
            print("task 3", result)
            observer.next("result 3")
        }.catchError { error in
            print("error >>", error)
        }.finalFinish {
            print("normal finish")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
