//
//  GameNode.swift
//  Learn2SpriteKit
//
//  Created by Matteo Morena on 11/02/22.
//

import Foundation
import GameplayKit

class GameNode: GKGridGraphNode {
    var name: String
    
    init (name: String, gridPosition: vector_int2) {
        self.name = name
        super.init(gridPosition: gridPosition)
    }
    override var description: String {
        return self.name
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
