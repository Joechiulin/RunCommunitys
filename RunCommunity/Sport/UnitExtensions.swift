//
//  UnitExtensions.swift
//  RunCommunity
//
//  Created by Joe on 2019/4/12.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation

class UnitConverterPace: UnitConverter {
    private let coefficient: Double
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        return reciprocal(value * coefficient)
    }
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    private func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
}

extension UnitSpeed {
    class var secondsPerMeter: UnitSpeed {
        return UnitSpeed(symbol: "秒/公尺", converter: UnitConverterPace(coefficient: 1))
    }
    
    class var minutesPerKilometer: UnitSpeed {
        return UnitSpeed(symbol: "小時/公里", converter: UnitConverterPace(coefficient: 360.0 / 1000.0))
    }
    
    class var minutesPerMile: UnitSpeed {
        return UnitSpeed(symbol: "分/米", converter: UnitConverterPace(coefficient: 60.0 / 1609.34))
    }
}
