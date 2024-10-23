//
//  Tiles.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/4/24.
//

import SwiftUI


// MARK: - Tile Model and Views

struct Tile: Identifiable {
    let id = UUID()
    let name: String
    var state: MahjongTileView.TileState = .unselected
    
    // New properties to support the scoring algorithm
    var suit: String  // e.g., "dots", "bamboo", "characters", "wind", "dragon"
    var number: Int?  // Number for numbered tiles (e.g., 1-9), nil for winds/dragons
    var isHonor: Bool // True if the tile is a wind or dragon, false otherwise
}

struct MahjongTileView: View {
    let tileName: String
    let state: TileState
    
    enum TileState {
        case unselected, selected, disabled
    }
    
    var body: some View {
        Image(tileName)
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 100)
            .opacity(opacityForState(state))
    }
    
    private func opacityForState(_ state: TileState) -> Double {
        switch state {
        case .unselected: return 0.3
        case .selected: return 1.0
        case .disabled: return 0.1
        }
    }
}


// MARK: - Tiles

// Define the suits
enum Suit: String, CaseIterable {
    case dots, bamboo, characters
}

// Define the honors
enum Honor: String, CaseIterable {
    case eastWind, southWind, westWind, northWind
    case redDragon, greenDragon, whiteDragon
}

// Define the bonus tiles
enum Bonus: String, CaseIterable {
    case plum, orchid, chrysanthemum, bamboo // Flowers
    case spring, summer, autumn, winter // Seasons
}

// Define a struct for a Mahjong tile
struct MahjongTile: Identifiable {
    let id = UUID()
    let value: TileValue
    
    enum TileValue {
        case suited(Suit, Int) // For numbered tiles (1-9)
        case honor(Honor)
        case bonus(Bonus)
    }
    
    var name: String {
        switch value {
        case .suited(let suit, let number):
            return "\(suit.rawValue)_\(number)"
        case .honor(let honor):
            return honor.rawValue
        case .bonus(let bonus):
            return bonus.rawValue
        }
    }
}

// Create a full set of Mahjong tiles
struct MahjongSet {
    static let allTiles: [MahjongTile] = {
        var tiles: [MahjongTile] = []
        
        // Add suited tiles (4 of each)
        for suit in Suit.allCases {
            for number in 1...9 {
                for _ in 1...4 {
                    tiles.append(MahjongTile(value: .suited(suit, number)))
                }
            }
        }
        
        // Add honor tiles (4 of each)
        for honor in Honor.allCases {
            for _ in 1...4 {
                tiles.append(MahjongTile(value: .honor(honor)))
            }
        }
        
        // Add bonus tiles (1 of each)
        for bonus in Bonus.allCases {
            tiles.append(MahjongTile(value: .bonus(bonus)))
        }
        
        return tiles
    }()
}
