//
//  AdequateRandom.swift
//  FinesPayment
//
//  Created by Daniil on 26.04.18.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

extension FloatingPoint {
    public static var random: Self { return Self(arc4random()) / Self(UInt32.max) }
    public static func random(_ upperBound: Self = 1, accuracy: Self = 0) -> Self {
        guard accuracy != 0 else { return .random * upperBound }
        let ac: Self = abs(accuracy)
        return floor(.random * upperBound / ac) * ac
    }
    
    public static func random(_ range: Range<Self>, accuracy: Self = 0) -> Self {
        return Self.random(range.upperBound - range.lowerBound, accuracy: accuracy) + range.lowerBound
    }
}

extension FixedWidthInteger {
    public static var random: Self {
        let max = Self.max
        if max >= UInt32.max {
            return Self(arc4random())
        } else {
            return Self(arc4random_uniform(UInt32(max)))
        }
    }
    
    public static func random(_ upperBound: Self, accuracy: Self = 1) -> Self {
        guard accuracy.magnitude > 1 else { return Self(arc4random_uniform(UInt32(upperBound))) }
        let ac = Self(accuracy.magnitude)
        let rand = Self(arc4random_uniform(UInt32(upperBound / ac)))
        return ac * rand
    }
    
    public static func random(_ range: Range<Self>, accuracy: Self = 1) -> Self {
        return Self.random(range.upperBound - range.lowerBound, accuracy: accuracy) + range.lowerBound
    }
    
    public static func random(_ range: ClosedRange<Self>, accuracy: Self = 1) -> Self {
        return Self.random(1 + range.upperBound - range.lowerBound, accuracy: accuracy) + range.lowerBound
    }
}

extension Array {
    
    public init(count: Int, each: (Int) -> Element) {
        self.init()
        for i in 0..<count { self.append(each(i)) }
    }
    
    public init(count: Int, each: @autoclosure () -> Element) {
        self.init()
        for _ in 0..<count { self.append(each()) }
    }
    
    public var random: Element? {
        guard !isEmpty else { return nil }
        return self[Int.random(self.count)]
    }
    
    public func shuffled() -> [Element] {
        var indexes = [Int](count: count) { $0 }
        var result: [Element] = []
        while !indexes.isEmpty {
            let element = indexes.remove(at: Int.random(indexes.count))
            result.append(self[element])
        }
        return result
    }
    
    public mutating func shuffle() {
        self = self.shuffled()
    }
}
