//
//  ScoreCalculator.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI

class ScoreCalculator {
    
    // MARK: - Score Messages
    
    func validateHand(tiles: [Tile], selectedSeatWind: AdditionalView.SeatWind, selectedPrevailingWind: AdditionalView.PrevailingWind, selectedFlowerTiles: [Tile], isSelfDrawn: Bool, isConcealedHand: Bool) -> (String, Int, Int, Int, Int, Int, Int) {
        
        // Variable to hold the total score
        var handPoints = 0
        var handMessage = ""
        var windPoints = 0
        var dragonPoints = 0
        var flowerPoints = 0
        var selfDrawnPoints = 0
        var concealedHandPoints = 0
        
        
        // Step 1: Check if there are 14 tiles
        guard tiles.count == 14 else {
            return ("Please select 14 tiles", 0, 0, 0, 0, 0, 0)
        }
        
        // Check for hand type points
        if isThirteenOrphans(tiles) {
            handMessage = "Thirteen Orphans Hand 十三么"
            handPoints += 13
        } else if isPureHand(tiles) {
            handMessage = "Pure Hand 清一色"
            handPoints += 7
        } else if isValidSevenPairs(tiles) {
            handMessage = "Seven Pair Hand 七對子"
            handPoints += 4
        } else if isMixedOneSuit(tiles) {
            handMessage = "Mixed One Suit Hand 混一色"
            handPoints += 3
        } else if isAllTriplets(tiles) {
            handMessage = "All Triplets Hand"
            handPoints += 3
        } else if isAllChows(tiles) {
            handMessage = "All Chow Hand"
            handPoints += 1
        } else {
            handMessage = "Oh no! You don't have a winning combination"
            handPoints = 0
            return (handMessage, 0, 0, 0, 0, 0, 0)
        }
        
        
        if handPoints > 0 {  // Only apply self drawn bonus if there's a valid hand
            if isSelfDrawn {
                selfDrawnPoints = 1
            }
            if isConcealedHand {
                concealedHandPoints = 1
            }
            
            // Only calculate additional points if there's a winning hand
            windPoints = calculateWindPoints(tiles: tiles, seatWind: selectedSeatWind, prevailingWind: selectedPrevailingWind)
            flowerPoints = calculateFlowerPoints(selectedFlowerTiles: selectedFlowerTiles)
            //flowerPoints = calculateFlowerPoints(selectedFlowerTiles: selectedFlowerTiles, selectedSeatWind: selectedSeatWind)
            dragonPoints = calculateDragonPoints(tiles: tiles)
            
        } else {
            // If no valid hand, set all points to 0
            return (handMessage, 0, 0, 0, 0, 0, 0)
        }

        print("Hand points: \(handPoints), Wind points: \(windPoints), Dragon points: \(dragonPoints), Flower points: \(flowerPoints), Self Drawn points: \(selfDrawnPoints), Concealed Hand points: \(concealedHandPoints)")

        // Return the hand message, hand points, flower points, and wind points
        return (handMessage, handPoints, flowerPoints, dragonPoints, windPoints, selfDrawnPoints, concealedHandPoints)
    }
    
    
    //MARK: - Dragon Points
    private func calculateDragonPoints(tiles: [Tile]) -> Int {
        let dragonTiles = tiles.filter { $0.suit == "dragon" }
        var dragonPoints = 0

        // Check for Red Dragon pung or kong
        if dragonTiles.filter({ $0.name == "red_dragon" }).count >= 3 {
            dragonPoints += 1
        }

        // Check for Green Dragon pung or kong
        if dragonTiles.filter({ $0.name == "green_dragon" }).count >= 3 {
            dragonPoints += 1
        }

        // Check for White Dragon pung or kong
        if dragonTiles.filter({ $0.name == "white_dragon" }).count >= 3 {
            dragonPoints += 1
        }

        return dragonPoints
    }
    
    
    //MARK: - Wind Points
    
    func calculateWindPoints(tiles: [Tile], seatWind: AdditionalView.SeatWind, prevailingWind: AdditionalView.PrevailingWind) -> Int {
        print("Calculating wind points...")
        print("Seat Wind: \(seatWind.rawValue), Prevailing Wind: \(prevailingWind.rawValue)")
        
        var windPoints = 0
        
        // Check for wind tiles in the selected tiles
        let windTiles = tiles.filter { $0.suit == "wind" }
        print("Wind tiles: \(windTiles.map { $0.name })")
        
        // Check for seat wind pung
        let seatWindName = seatWind.rawValue.replacingOccurrences(of: " Wind", with: "").lowercased() + "_wind"
        let seatWindTiles = windTiles.filter { $0.name == seatWindName }
        print("Seat wind name to match: \(seatWindName)")
        print("Seat wind tiles: \(seatWindTiles.map { $0.name })")
        if seatWindTiles.count >= 3 {
            windPoints += 1
            print("Seat wind pung found")
        }
        
        // Check for prevailing wind pung
        let prevailingWindName = prevailingWind.rawValue.replacingOccurrences(of: " Wind", with: "").lowercased() + "_wind"
        let prevailingWindTiles = windTiles.filter { $0.name == prevailingWindName }
        print("Prevailing wind name to match: \(prevailingWindName)")
        print("Prevailing wind tiles: \(prevailingWindTiles.map { $0.name })")
        if prevailingWindTiles.count >= 3 {
            windPoints += 1
            print("Prevailing wind pung found")
        }
        
        print("Total wind points: \(windPoints)")
        return windPoints
    }
    
    
    //MARK: - Flower Counter
    
    func calculateFlowerPoints(selectedFlowerTiles: [Tile]) -> Int {
        return selectedFlowerTiles.count
    }
    
//    func calculateFlowerPoints(selectedFlowerTiles: [Tile], selectedSeatWind: AdditionalView.SeatWind) -> Int {
//        var flowerPoints = 0
//        
//        // Check if selected flowers correspond to the seat wind
//        let seatWindFlowerTiles = getFlowerTilesForSeatWind(selectedSeatWind)
//        
//        for tile in selectedFlowerTiles {
//            if seatWindFlowerTiles.contains(tile.name) {
//                flowerPoints += 1
//            }
//        }
//        
//        return flowerPoints
//
//    }
//    
//    // Return the corresponding flower tiles for a given seat wind
//    private func getFlowerTilesForSeatWind(_ seatWind: AdditionalView.SeatWind) -> [String] {
//        switch seatWind {
//        case .east:
//            return ["plum_flower", "spring_season"]
//        case .south:
//            return ["orchid_flower", "summer_season"]
//        case .west:
//            return ["chrysanthemum_flower", "autumn_season"]
//        case .north:
//            return ["bamboo_flower", "winter_season"]
//        }
//    }
    
    
    // MARK: - All Pungs
        
    // Check if the hand consists of four pungs and a pair
    private func isAllTriplets(_ tiles: [Tile]) -> Bool {
        var remainingTiles = tiles
        var pungsCount = 0

        // Try to extract 4 pung sets
        for _ in 0..<4 {
            if let pung = findPung(in: remainingTiles) {
                pungsCount += 1
                remainingTiles = removeTiles(pung, from: remainingTiles)
            } else {
                return false // If we can't find 4 pungs, it's not an All Triplets hand
            }
        }

        // After extracting 4 pungs, check if the remaining tiles form a pair
        let result = isPair(remainingTiles)
        return result
    }
    
    
    // MARK: - Thirteen Orphans
    
    // Check if the hand is a Thirteen Orphans hand
    private func isThirteenOrphans(_ tiles: [Tile]) -> Bool {
        // List of the required 13 unique tiles for a Thirteen Orphans hand using your naming convention
        let requiredTiles = ["dot_1", "dot_9", "bamboo_1", "bamboo_9", "character_1", "character_9",
                             "east_wind", "south_wind", "west_wind", "north_wind",
                             "red_dragon", "green_dragon", "white_dragon"]

        // Count occurrences of each tile in the hand
        var tileCounts = [String: Int]()
        for tile in tiles {
            tileCounts[tile.name, default: 0] += 1
        }

        // Check if exactly one tile appears twice (i.e., the pair)
        let hasOnePair = tileCounts.values.contains(2)

        // Ensure all the required unique tiles appear at least once
        let hasAllUniqueTiles = requiredTiles.allSatisfy { tileCounts[$0] ?? 0 >= 1 }

        // Return true if the hand has the correct unique tiles plus a pair and the total count is 14
        return hasAllUniqueTiles && hasOnePair && tiles.count == 14
    }
    
    
    // MARK: - All Chows
    
    // Check if the hand consists of only chows and a pair
    private func isAllChows(_ tiles: [Tile]) -> Bool {
        var remainingTiles = tiles
        var setsCount = 0

        // Try to extract 4 chow sets
        for _ in 0..<4 {
            if let chow = findChow(in: remainingTiles) {
                setsCount += 1
                print("Chow set found: \(chow)")
                remainingTiles = removeTiles(chow, from: remainingTiles)
            } else {
                print("Failed to find a chow in remaining tiles: \(remainingTiles)")
                return false // If we can't find a chow, it's not an All Chow hand
            }
        }

        // After extracting 4 sets, check if the remaining tiles form a pair
        let result = isPair(remainingTiles)
        print("Final remaining tiles: \(remainingTiles), Is pair: \(result)")
        return result
    }
    
    
    //MARK: - Pure Hand
    
    // Check if the hand is a Pure Hand (all tiles in a single suit without any honors)
    private func isPureHand(_ tiles: [Tile]) -> Bool {
        let suitTiles = tiles.filter { !$0.isHonor } // Filter out any honor tiles
        let suits = Set(suitTiles.map { $0.suit })  // Get unique suits in the hand

        let hasOnlyOneSuit = suits.count == 1       // Ensure only one suit is present
        let containsHonors = tiles.contains { $0.isHonor } // Check if there are any honor tiles

        // A Pure Hand should have tiles only from one suit and no honors
        return hasOnlyOneSuit && !containsHonors
    }
    
    
    //MARK: - Mixed One Suit
    
    // Check if the hand is Mixed One Suit (single suit plus honors)
    private func isMixedOneSuit(_ tiles: [Tile]) -> Bool {
        let suitedTiles = tiles.filter { !$0.isHonor }
        let honorTiles = tiles.filter { $0.isHonor }
        
        // Ensure we have both suited tiles and honor tiles
        guard !suitedTiles.isEmpty && !honorTiles.isEmpty else { return false }
        
        // Check if all suited tiles are of the same suit
        let suits = Set(suitedTiles.map { $0.suit })
        guard suits.count == 1 else { return false }
        
        // Check for valid sets (pungs and chows) within the suited tiles
        var remainingSuitedTiles = suitedTiles
        var validSetsFound = 0
        
        while !remainingSuitedTiles.isEmpty {
            if let pung = findPung(in: remainingSuitedTiles) {
                validSetsFound += 1
                remainingSuitedTiles = removeTiles(pung, from: remainingSuitedTiles)
            } else if let chow = findChow(in: remainingSuitedTiles) {
                validSetsFound += 1
                remainingSuitedTiles = removeTiles(chow, from: remainingSuitedTiles)
            } else {
                // If we can't find a valid set, break the loop
                break
            }
        }
        
        // Check if we found at least one valid set and the remaining tiles form a pair
        let hasValidSets = validSetsFound > 0
        let remainingTilesFormPair = remainingSuitedTiles.count == 2 && remainingSuitedTiles[0].name == remainingSuitedTiles[1].name
        
        // Ensure honor tiles are of the same type (either all dragons or all of one wind)
        let dragonTypes = Set(honorTiles.filter { $0.suit == "dragon" }.map { $0.name })
        let windTypes = Set(honorTiles.filter { $0.suit == "wind" }.map { $0.name })
        let hasSingleHonorType = (dragonTypes.count <= 1) && (windTypes.count <= 1) && (dragonTypes.count + windTypes.count == 1)
        
        return hasValidSets && remainingTilesFormPair && hasSingleHonorType
    }
    
    
    //MARK: - Seven Pairs
    
    // Check if the hand has 7 valid pairs
    private func isValidSevenPairs(_ tiles: [Tile]) -> Bool {
        let tileCounts = Dictionary(grouping: tiles) { $0.name }.mapValues { $0.count }
        return tileCounts.values.filter { $0 == 2 }.count == 7
    }
    
    
    // Check if the hand has 4 valid sets and 1 pair
    private func isValidFourSetsOnePair(_ tiles: [Tile]) -> Bool {
        var remainingTiles = tiles
        var setsCount = 0
        
        // Try to extract 4 valid sets (chow, pung, kong)
        for _ in 0..<4 {
            if let set = extractValidSet(from: remainingTiles) {
                setsCount += 1
                remainingTiles = set.remainingTiles
            } else {
                return false
            }
        }
        
        // After extracting 4 sets, check if the remaining tiles form a pair
        return isPair(remainingTiles)
    }
    
    
    // Tries to extract a valid set (chow, pung, kong) from the tiles
    private func extractValidSet(from tiles: [Tile]) -> (set: [Tile], remainingTiles: [Tile])? {
        if let chow = findChow(in: tiles) {
            return (chow, removeTiles(chow, from: tiles))
        } else if let pung = findPung(in: tiles) {
            return (pung, removeTiles(pung, from: tiles))
        } else if let kong = findKong(in: tiles) {
            return (kong, removeTiles(kong, from: tiles))
        } else {
            return nil
        }
    }
    
    
    // Finds a chow (three consecutive tiles of the same suit)
    private func findChow(in tiles: [Tile]) -> [Tile]? {
        let groupedBySuit = Dictionary(grouping: tiles.filter { !$0.isHonor }) { $0.suit }

        for (_, suitTiles) in groupedBySuit {
            let sortedTiles = suitTiles.sorted {
                if let num1 = $0.number, let num2 = $1.number {
                    return num1 < num2
                }
                return false
            }

            // Ensure there are at least 3 tiles to form a chow
            guard sortedTiles.count >= 3 else {
                continue
            }

            for i in 0..<(sortedTiles.count - 2) {
                if let num1 = sortedTiles[i].number,
                   let num2 = sortedTiles[i + 1].number,
                   let num3 = sortedTiles[i + 2].number,
                   num1 + 1 == num2 && num2 + 1 == num3 {
                    print("Chow found: [\(sortedTiles[i].name), \(sortedTiles[i + 1].name), \(sortedTiles[i + 2].name)]")
                    return [sortedTiles[i], sortedTiles[i + 1], sortedTiles[i + 2]]
                }
            }
        }

        print("No chow found in tiles: \(tiles)")
        return nil
    }
    
    
    // Finds a pung (three identical tiles)
    private func findPung(in tiles: [Tile]) -> [Tile]? {
        let tileCounts = Dictionary(grouping: tiles) { $0.name }.mapValues { $0.count }
        for (name, count) in tileCounts {
            if count >= 3 {
                return tiles.filter { $0.name == name }.prefix(3).map { $0 }
            }
        }
        return nil
    }
    
    
    // Finds a kong (four identical tiles)
    private func findKong(in tiles: [Tile]) -> [Tile]? {
        let tileCounts = Dictionary(grouping: tiles) { $0.name }.mapValues { $0.count }
        for (name, count) in tileCounts {
            if count == 4 {
                return tiles.filter { $0.name == name }
            }
        }
        return nil
    }
    
    
    // Checks if the remaining tiles form a pair
    private func isPair(_ tiles: [Tile]) -> Bool {
        let result = tiles.count == 2 && tiles[0].name == tiles[1].name
        return result
    }
    
    
    // Helper to remove specific tiles from the list
    private func removeTiles(_ tilesToRemove: [Tile], from tiles: [Tile]) -> [Tile] {
        var remainingTiles = tiles
        for tile in tilesToRemove {
            if let index = remainingTiles.firstIndex(where: { $0.id == tile.id }) {
                remainingTiles.remove(at: index)
            }
        }
        return remainingTiles
    }
}
