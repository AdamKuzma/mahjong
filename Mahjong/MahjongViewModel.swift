//
//  MahjongViewModel.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/21/24.
//

import SwiftUI
import UIKit


// MARK: - ViewModel
class MahjongViewModel: ObservableObject {
    
    @Published var handMessage: String = ""
    @Published var handPoints: Int = 0
    @Published var flowerPoints: Int = 0
    @Published var dragonPoints: Int = 0
    @Published var windPoints: Int = 0
    @Published var selfDrawnPoints: Int = 0
    @Published var concealedHandPoints: Int = 0
    
    private let scoreCalculator = ScoreCalculator()
    
    enum TileCategory {
        case dots, bamboo, characters, winds, dragons, flowers
    }
    
    // Function to handle dragging state changes
    func handleDragSelection(index: Int, for category: TileCategory) {
        toggleTileState(index: index, for: category)
    }
    
    func calculateScore() {
        // Trigger haptic feedback when the button is pressed
        HapticFeedbackManager.triggerLightFeedback()
        
        // Validate the selected tiles and update the message
        let selectedTiles = allSelectedTiles()  // Use self.allSelectedTiles() if you prefer to be explicit
        let selectedFlowerTiles = flowerTiles.filter { $0.state == .selected }
        
        // Unpack the tuple into three variables
        let (message, handPts, flowerPts, dragonPts, windPts, selfDrawnPts, concealedHandPts) = scoreCalculator.validateHand(
            tiles: selectedTiles,
            selectedSeatWind: selectedSeatWind,
            selectedPrevailingWind: selectedPrevailingWind,
            selectedFlowerTiles: selectedFlowerTiles,
            isSelfDrawn: isSelfDrawn,
            isConcealedHand: isConcealedHand
        )
                        
        handMessage = message
        handPoints = handPts
        flowerPoints = flowerPts
        dragonPoints = dragonPts
        windPoints = windPts
        selfDrawnPoints = selfDrawnPts
        concealedHandPoints = concealedHandPts
    }
    
    
    @Published var dotTiles: [Tile] = [
        Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
        Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
        Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
        Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
        
        Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
        Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
        Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
        Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
        
        Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
        Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
        Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
        Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
        
        Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
        Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
        Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
        Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
        
        Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
        Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
        Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
        Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
        
        Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
        Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
        Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
        Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
        
        Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
        Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
        Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
        Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
        
        Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
        Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
        Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
        Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
        
        Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
        Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
        Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
        Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
    ]
    
    @Published var bambooTiles: [Tile] = [
        Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
        Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
        Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
        Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
        
        Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
        Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
        Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
        Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
        
        Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
        Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
        Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
        Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
        
        Tile(name: "bamboo_4", suit: "bamboo", number: 4, isHonor: false),
        Tile(name: "bamboo_4", suit: "bamboo", number: 4, isHonor: false),
        Tile(name: "bamboo_4", suit: "bamboo", number: 4, isHonor: false),
        Tile(name: "bamboo_4", suit: "bamboo", number: 4, isHonor: false),
        
        Tile(name: "bamboo_5", suit: "bamboo", number: 5, isHonor: false),
        Tile(name: "bamboo_5", suit: "bamboo", number: 5, isHonor: false),
        Tile(name: "bamboo_5", suit: "bamboo", number: 5, isHonor: false),
        Tile(name: "bamboo_5", suit: "bamboo", number: 5, isHonor: false),
        
        Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
        Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
        Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
        Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
        
        Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false),
        Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false),
        Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false),
        Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false),
        
        Tile(name: "bamboo_8", suit: "bamboo", number: 8, isHonor: false),
        Tile(name: "bamboo_8", suit: "bamboo", number: 8, isHonor: false),
        Tile(name: "bamboo_8", suit: "bamboo", number: 8, isHonor: false),
        Tile(name: "bamboo_8", suit: "bamboo", number: 8, isHonor: false),
        
        Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false),
        Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false),
        Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false),
        Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false)
    ]
    
    @Published var characterTiles: [Tile] = [
        Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
        Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
        Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
        Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
        
        Tile(name: "character_2", suit: "characters", number: 2, isHonor: false),
        Tile(name: "character_2", suit: "characters", number: 2, isHonor: false),
        Tile(name: "character_2", suit: "characters", number: 2, isHonor: false),
        Tile(name: "character_2", suit: "characters", number: 2, isHonor: false),
        
        Tile(name: "character_3", suit: "characters", number: 3, isHonor: false),
        Tile(name: "character_3", suit: "characters", number: 3, isHonor: false),
        Tile(name: "character_3", suit: "characters", number: 3, isHonor: false),
        Tile(name: "character_3", suit: "characters", number: 3, isHonor: false),
        
        Tile(name: "character_4", suit: "characters", number: 4, isHonor: false),
        Tile(name: "character_4", suit: "characters", number: 4, isHonor: false),
        Tile(name: "character_4", suit: "characters", number: 4, isHonor: false),
        Tile(name: "character_4", suit: "characters", number: 4, isHonor: false),
        
        Tile(name: "character_5", suit: "characters", number: 5, isHonor: false),
        Tile(name: "character_5", suit: "characters", number: 5, isHonor: false),
        Tile(name: "character_5", suit: "characters", number: 5, isHonor: false),
        Tile(name: "character_5", suit: "characters", number: 5, isHonor: false),
        
        Tile(name: "character_6", suit: "characters", number: 6, isHonor: false),
        Tile(name: "character_6", suit: "characters", number: 6, isHonor: false),
        Tile(name: "character_6", suit: "characters", number: 6, isHonor: false),
        Tile(name: "character_6", suit: "characters", number: 6, isHonor: false),
        
        Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
        Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
        Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
        Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
        
        Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
        Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
        Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
        Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
        
        Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
        Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
        Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
        Tile(name: "character_9", suit: "characters", number: 9, isHonor: false)
    ]
    
    @Published var windTiles: [Tile] = [
        Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
        
        Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
        
        Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
        
        Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
        Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true)
    ]
    
    @Published var dragonTiles: [Tile] = [
        Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
        
        Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
        
        Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
        Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true)
    ]
    
    @Published var flowerTiles: [Tile] = [
        Tile(name: "plum_flower", suit: "flower", number: nil, isHonor: false),
        Tile(name: "orchid_flower", suit: "flower", number: nil, isHonor: false),
        Tile(name: "chrysanthemum_flower", suit: "flower", number: nil, isHonor: false),
        Tile(name: "bamboo_flower", suit: "flower", number: nil, isHonor: false),
        Tile(name: "spring_season", suit: "flower", number: nil, isHonor: false),
        Tile(name: "summer_season", suit: "flower", number: nil, isHonor: false),
        Tile(name: "autumn_season", suit: "flower", number: nil, isHonor: false),
        Tile(name: "winter_season", suit: "flower", number: nil, isHonor: false)
    ]
    
    @Published var selectedSeatWind: AdditionalView.SeatWind = .east
    @Published var selectedPrevailingWind: AdditionalView.PrevailingWind = .east
    
    @Published var isSelfDrawn: Bool = false
    @Published var isConcealedHand: Bool = false
    
    @Published var selectedTilesCount = 0
    
    // Function to fetch all selected tiles
    func allSelectedTiles() -> [Tile] {
        return dotTiles.filter { $0.state == .selected } +
               bambooTiles.filter { $0.state == .selected } +
               characterTiles.filter { $0.state == .selected } +
               windTiles.filter { $0.state == .selected } +
               dragonTiles.filter { $0.state == .selected }
    }
    
    // This function handles tile selection for non-flower tiles
    func toggleTileState(index: Int, for category: TileCategory) {
        var tiles: [Tile]

        switch category {
        case .dots:
            tiles = dotTiles
        case .bamboo:
            tiles = bambooTiles
        case .characters:
            tiles = characterTiles
        case .winds:
            tiles = windTiles
        case .dragons:
            tiles = dragonTiles
        case .flowers:
            tiles = flowerTiles // Handle flower tiles separately
        }
        
        // Check if the tile is in the disabled state, and if so, return early
        if tiles[index].state == .disabled {
            return // Do nothing if the tile is disabled
        }


        // Only count non-flower tiles in the hand
        if category != .flowers {
            if tiles[index].state == .unselected && selectedTilesCount < 14 {
                tiles[index].state = .selected
                selectedTilesCount += 1
            } else if tiles[index].state == .selected {
                tiles[index].state = .unselected
                selectedTilesCount -= 1
            }
            // ... rest of your toggle logic
        } else {
            // Flower tiles do not contribute to the hand count, but change state
            if tiles[index].state == .unselected {
                tiles[index].state = .selected
            } else if tiles[index].state == .selected {
                tiles[index].state = .unselected
            }
        }
        
        if category == .winds {
            print("Wind tile toggled: \(tiles[index].name)")
        }

        // Trigger haptic feedback when tile state changes
        HapticFeedbackManager.triggerLightFeedback()

        // Assign the updated array back to the right property
        switch category {
        case .dots:
            dotTiles = tiles
        case .bamboo:
            bambooTiles = tiles
        case .characters:
            characterTiles = tiles
        case .winds:
            windTiles = tiles
        case .dragons:
            dragonTiles = tiles
        case .flowers:
            flowerTiles = tiles
        }

        // Update all tile states to reflect changes in selection
        updateAllTileStates()
    }

    private func updateAllTileStates() {
        updateTileStates(for: .dots)
        updateTileStates(for: .bamboo)
        updateTileStates(for: .characters)
        updateTileStates(for: .winds)
        updateTileStates(for: .dragons)
        updateTileStates(for: .flowers)
    }

    private func updateTileStates(for category: TileCategory) {
        var tiles: [Tile]

        switch category {
        case .dots:
            tiles = dotTiles
        case .bamboo:
            tiles = bambooTiles
        case .characters:
            tiles = characterTiles
        case .winds:
            tiles = windTiles
        case .dragons:
            tiles = dragonTiles
        case .flowers:
            return // No need to disable flower tiles
        }

        // Disable tiles if the hand count is full (but only for non-flower tiles)
        for i in tiles.indices where tiles[i].state != .selected {
            tiles[i].state = selectedTilesCount < 14 ? .unselected : .disabled
        }

        // Update the tiles back to the right array
        switch category {
        case .dots:
            dotTiles = tiles
        case .bamboo:
            bambooTiles = tiles
        case .characters:
            characterTiles = tiles
        case .winds:
            windTiles = tiles
        case .dragons:
            dragonTiles = tiles
        case .flowers:
            return
        }
    }
    
    func resetTiles() {
        dotTiles = dotTiles.map { Tile(name: $0.name, state: .unselected, suit: $0.suit, number: $0.number, isHonor: $0.isHonor) }
        bambooTiles = bambooTiles.map { Tile(name: $0.name, state: .unselected, suit: $0.suit, number: $0.number, isHonor: $0.isHonor) }
        characterTiles = characterTiles.map { Tile(name: $0.name, state: .unselected, suit: $0.suit, number: $0.number, isHonor: $0.isHonor) }
        windTiles = windTiles.map { Tile(name: $0.name, state: .unselected, suit: $0.suit, number: $0.number, isHonor: $0.isHonor) }
        dragonTiles = dragonTiles.map { Tile(name: $0.name, state: .unselected, suit: $0.suit, number: $0.number, isHonor: $0.isHonor) }
        flowerTiles = flowerTiles.map { Tile(name: $0.name, state: .unselected, suit: $0.suit, number: $0.number, isHonor: $0.isHonor) }
        
        selectedTilesCount = 0 // Reset the selected tile count
    }
}
