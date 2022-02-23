//
//  SupportCode.swift
//  Learn2SpriteKit
//
//  Created by Luigi Minniti on 16/02/22.
//

import Foundation
import CoreGraphics
import SpriteKit

public func delay(seconds: TimeInterval,
                  completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds,
                                  execute: completion)
}

public func random(min: CGFloat, max: CGFloat) -> CGFloat {
  return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    * (max - min) + min
}
