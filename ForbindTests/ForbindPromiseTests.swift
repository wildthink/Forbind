//
//  ForbindPromiseTests.swift
//  Forbind
//
//  Created by Ulrik Damm on 09/05/15.
//
//

import Foundation
import XCTest

class ForbindPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = Promise<Int>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = Promise<Int>()
		
		promise.setValue(1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise = Promise(value: 1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = Promise<Int>()
		
		var gotValue1 = false
		var gotValue2 = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue1 = true
		}
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue2 = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
//	func testEquals() {
//		let promise1 = Promise<Int>()
//		let promise2 = Promise<Int>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value == true)
//			gotValue = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(1)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testEqualsFalse() {
//		let promise1 = Promise<Int>()
//		let promise2 = Promise<Int>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value == false)
//			gotValue = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(2)
//		
//		XCTAssert(gotValue)
//	}
	
	func testDereferenceDealloc() {
		var promise : Promise? = Promise<Int>()
		weak var weakPromise : Promise<Int>? = promise
		
		var result : Promise? = promise! => { $0 + 1 }
		
		XCTAssert(weakPromise != nil)
		
		promise = nil
		XCTAssert(weakPromise != nil)
		
		result = nil
		XCTAssert(weakPromise == nil)
	}
	
	func testMultipleBindDereferenceDealloc() {
		var promise : Promise? = Promise<Int>()
		weak var weakPromise = promise
		
		var result1 : Promise? = promise! => { $0 + 1 }
		var result2 : Promise? = result1! => { "\($0)" }
		
		weak var weakResult1 = result1
		result1 = nil
		
		XCTAssert(weakPromise != nil)
		XCTAssert(weakResult1 != nil)
		
		promise = nil
		XCTAssert(weakPromise != nil)
		XCTAssert(weakResult1 != nil)
		
		result2 = nil
		XCTAssert(weakPromise == nil)
		XCTAssert(weakResult1 == nil)
	}
}

//class ForbindPromiseMapTests : XCTestCase {
//	func testMapPromise() {
//		let promise1 = Promise<Int>()
//		let promise2 = Promise<Int>()
//		let promises = [promise1, promise2]
//		
//		let results = promises => { $0 + 1 }
//		
//		var gotValue1 = false
//		var gotValue2 = false
//		
//		results[0].getValue { value in
//			XCTAssert(value == 2)
//			gotValue1 = true
//		}
//		
//		results[1].getValue { value in
//			XCTAssert(value == 3)
//			gotValue2 = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(2)
//		
//		XCTAssert(gotValue1)
//		XCTAssert(gotValue2)
//	}
//	
//	func testMapOptionalPromise() {
//		let promise1 = Promise<Int?>()
//		let promise2 = Promise<Int?>()
//		let promises = [promise1, promise2]
//		
//		let results = promises => { $0 ?? 0 }
//		
//		var gotValue1 = false
//		var gotValue2 = false
//		
//		results[0].getValue { value in
//			XCTAssert(value == 1)
//			gotValue1 = true
//		}
//		
//		results[1].getValue { value in
//			XCTAssert(value == 0)
//			gotValue2 = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(nil)
//		
//		XCTAssert(gotValue1)
//		XCTAssert(gotValue2)
//	}
//	
//	func testMapResultPromise() {
//		let promise1 = Promise<Result<Int>>()
//		let promise2 = Promise<Result<Int>>()
//		let promises = [promise1, promise2]
//		
//		let results = promises => { (v : Result<Int>) -> Int? in
//			switch v {
//			case .error(_): return nil
//			case .ok(let value): return value
//			}
//		}
//		
//		var gotValue1 = false
//		var gotValue2 = false
//		
//		results[0].getValue { value in
//			XCTAssert(value == 1)
//			gotValue1 = true
//		}
//		
//		results[1].getValue { value in
//			XCTAssert(value == nil)
//			gotValue2 = true
//		}
//		
//		promise1.setValue(.Ok(1))
//		promise2.setValue(.Error(GenericError()))
//		
//		XCTAssert(gotValue1)
//		XCTAssert(gotValue2)
//	}
//}
//
//class ForbindPromiseFilterTests : XCTestCase {
//	func testFilterPromise() {
//		let promises = [Promise<Int>(), Promise<Int>(), Promise<Int>()]
//		
//		let results = filterp(promises) { $0 > 1 }
//		
//		var gotValue = false
//		
//		results.getValue { results in
//			gotValue = true
//			XCTAssert(results == [2, 3])
//		}
//		
//		promises[0].setValue(1)
//		promises[1].setValue(2)
//		promises[2].setValue(3)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testFilterOptionalPromise() {
//		let promises = [Promise<Int?>(), Promise<Int?>(), Promise<Int?>()]
//		
//		let results = filterp(promises) { $0 != nil }
//		
//		var gotValue = false
//		
//		results.getValue { results in
//			gotValue = true
//			XCTAssert(results.count == 2)
//			XCTAssert(results[0] == 2)
//			XCTAssert(results[1] == 3)
//		}
//		
//		promises[0].setValue(2)
//		promises[1].setValue(nil)
//		promises[2].setValue(3)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testFilterResultPromise() {
//		let promises = [Promise<Result<Int>>(), Promise<Result<Int>>(), Promise<Result<Int>>()]
//		
//		let results = filterp(promises) { !($0.errorValue is GenericError) }
//		
//		var gotValue = false
//		
//		results.getValue { results in
//			gotValue = true
//			XCTAssert(results.count == 2)
//			XCTAssert(results[0].okValue == 1)
//			XCTAssert(results[1].okValue == 3)
//		}
//		
//		promises[0].setValue(.Ok(1))
//		promises[1].setValue(.Error(GenericError()))
//		promises[2].setValue(.Ok(3))
//		
//		XCTAssert(gotValue)
//	}
//}
//
//class ForbindPromiseReduceTests : XCTestCase {
//	func testReducePromise() {
//		let promises = [Promise<Int>(), Promise<Int>(), Promise<Int>()]
//		
//		let result = reducep(promises, initial: 0, combine: +)
//		
//		var gotValue = false
//		
//		result.getValue { result in
//			gotValue = true
//			XCTAssert(result == 6)
//		}
//		
//		promises[0].setValue(1)
//		promises[1].setValue(2)
//		promises[2].setValue(3)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testReduceOptionalPromise() {
//		let promises = [Promise<Int?>(), Promise<Int?>(), Promise<Int?>()]
//		
//		let result = reducep(promises, initial: 0) { $0 + ($1 ?? 0) }
//		
//		var gotValue = false
//		
//		result.getValue { result in
//			gotValue = true
//			XCTAssert(result == 4)
//		}
//		
//		promises[0].setValue(1)
//		promises[1].setValue(nil)
//		promises[2].setValue(3)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testReduceResultPromise() {
//		let promises = [Promise<Result<Int>>(), Promise<Result<Int>>(), Promise<Result<Int>>()]
//		
//		let result = reducep(promises, initial: 0) { a, v in
//			switch v {
//			case .error(_): return a
//			case .ok(let value): return a + value
//			}
//		}
//		
//		var gotValue = false
//		
//		result.getValue { result in
//			gotValue = true
//			XCTAssert(result == 4)
//		}
//		
//		promises[0].setValue(.Ok(1))
//		promises[1].setValue(.Error(GenericError()))
//		promises[2].setValue(.Ok(3))
//		
//		XCTAssert(gotValue)
//	}
//}

class ForbindOptionalPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = Promise<Int?>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = Promise<Int?>()
		
		var gotValue = false
		
		promise.setValue(1)
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise : Promise<Int?> = Promise(value: 1)
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = Promise<Int?>()
		
		var gotValue1 = false
		var gotValue2 = false
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue1 = true
		}
		
		promise.getValue { value in
			XCTAssert(value == 1)
			gotValue2 = true
		}
		
		promise.setValue(1)
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
	func testGetNil() {
		let promise = Promise<Int?>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value == nil)
			gotValue = true
		}
		
		promise.setValue(nil)
		
		XCTAssert(gotValue)
	}
	
//	func testEquals() {
//		let promise1 = Promise<Int?>()
//		let promise2 = Promise<Int?>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value == true)
//			gotValue = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(1)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testEqualsNil() {
//		let promise1 = Promise<Int?>()
//		let promise2 = Promise<Int?>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value == nil)
//			gotValue = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(nil)
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testEqualsFalse() {
//		let promise1 = Promise<Int?>()
//		let promise2 = Promise<Int?>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value == false)
//			gotValue = true
//		}
//		
//		promise1.setValue(1)
//		promise2.setValue(2)
//		
//		XCTAssert(gotValue)
//	}
}

class ForbindResultPromiseTests : XCTestCase {
	func testGetValue() {
		let promise = Promise<Result<Int>>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value.okValue == 1)
			gotValue = true
		}
		
		promise.setValue(.ok(1))
		
		XCTAssert(gotValue)
	}
	
	func testGetValueAfterCompletion() {
		let promise = Promise<Result<Int>>()
		
		var gotValue = false
		
		promise.setValue(.ok(1))
		
		promise.getValue { value in
			XCTAssert(value.okValue == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testInitialValue() {
		let promise = Promise(value: Result.ok(1))
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value.okValue == 1)
			gotValue = true
		}
		
		XCTAssert(gotValue)
	}
	
	func testMultipleListeners() {
		let promise = Promise<Result<Int>>()
		
		var gotValue1 = false
		var gotValue2 = false
		
		promise.getValue { value in
			XCTAssert(value.okValue == 1)
			gotValue1 = true
		}
		
		promise.getValue { value in
			XCTAssert(value.okValue == 1)
			gotValue2 = true
		}
		
		promise.setValue(.ok(1))
		
		XCTAssert(gotValue1)
		XCTAssert(gotValue2)
	}
	
	func testGetError() {
		let promise = Promise<Result<Int>>()
		
		var gotValue = false
		
		promise.getValue { value in
			XCTAssert(value.errorValue is GenericError)
			gotValue = true
		}
		
		promise.setValue(.error(GenericError()))
		
		XCTAssert(gotValue)
	}
	
//	func testEquals() {
//		let promise1 = Promise<Result<Int>>()
//		let promise2 = Promise<Result<Int>>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value.okValue == true)
//			gotValue = true
//		}
//		
//		promise1.setValue(.Ok(1))
//		promise2.setValue(.Ok(1))
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testEqualsError() {
//		let promise1 = Promise<Result<Int>>()
//		let promise2 = Promise<Result<Int>>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			switch value {
//			case .error(_): gotValue = true
//			case _: XCTAssert(false)
//			}
//		}
//		
//		promise1.setValue(.Ok(1))
//		promise2.setValue(.Error(GenericError()))
//		
//		XCTAssert(gotValue)
//	}
//	
//	func testEqualsFalse() {
//		let promise1 = Promise<Result<Int>>()
//		let promise2 = Promise<Result<Int>>()
//		
//		let equals = (promise1 == promise2)
//		
//		var gotValue = false
//		
//		equals.getValue { value in
//			XCTAssert(value.okValue == false)
//			gotValue = true
//		}
//		
//		promise1.setValue(.Ok(1))
//		promise2.setValue(.Ok(2))
//		
//		XCTAssert(gotValue)
//	}
}
