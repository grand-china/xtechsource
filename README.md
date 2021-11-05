
# EasyPromise
## how use

```swift
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
```

```swift
Demo> testEasyPromise
task 1 nil
task 2 Optional("result 1")
task 3 Optional("result 2")
normal finish
```