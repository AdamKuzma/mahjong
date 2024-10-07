//
//  ScoreCalculator.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI

class ScoreCalculator {
    
    // MARK: - Score Messages
    
    // Validates if the hand has a valid structure and determines its type
    
    func validateHand(tiles: [Tile]) -> String {
        // Step 1: Check if there are 14 tiles
        guard tiles.count == 14 else {
            print("Invalid hand size. Current tile count: \(tiles.count)")
            return "Please select 14 tiles"
        }
        
        print("Validating hand with tiles: \(tiles)")
        
        // Step 2: Check for Thirteen Orphans (highest priority)
        if isThirteenOrphans(tiles) {
            print("Hand qualifies as Thirteen Orphans")
            return "You get 13 Points for Thirteen Orphans Hand"
        }
        
        // Step 3: Check for Seven Pairs
        if isValidSevenPairs(tiles) {
            print("Hand qualifies as Seven Pairs")
            return "You get 4 Points for Seven Pairs"
        }
        
        // Step 4: Check for Pure Hand (all tiles in a single suit)
        if isPureHand(tiles) {
            print("Hand qualifies as Pure Hand")
            return "You get 7 Points for Pure Hand"
        }
        
        // Step 5: Check for Mixed One Suit (single suit plus honors)
        if isMixedOneSuit(tiles) {
            print("Hand qualifies as Mixed One Suit")
            return "You get 3 Points for Mixed One Suit"
        }
        
        // Step 6: Check for All Chows (valid chows with one pair)
        if isValidFourSetsOnePair(tiles) && isAllChows(tiles) {
            print("Hand qualifies as All Chows")
            return "You get 1 Point for All Chow Hand"
        }
        
        // Step 7: Default response if no valid hand is found
        print("No winning hand found for tiles: \(tiles)")
        return "Oh no! You don't have a winning combination"
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

        print("Tile counts: \(tileCounts)")
        print("Has all unique tiles: \(hasAllUniqueTiles)")
        print("Pair count is valid: \(hasOnePair)")

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
        let suitTiles = tiles.filter { !$0.isHonor }
        let honorTiles = tiles.filter { $0.isHonor }

        // Mixed One Suit should have only one type of suited tile and must include honor tiles
        let suitCount = Set(suitTiles.map { $0.suit }).count
        let hasHonors = !honorTiles.isEmpty
        
        // Ensure all honor tiles are of the same specific type (either only red dragons, green dragons, white dragons, or a specific wind)
        let dragonTypes = Set(honorTiles.filter { $0.suit == "dragon" }.map { $0.name })
        let windTypes = Set(honorTiles.filter { $0.suit == "wind" }.map { $0.name })
        let hasSingleHonorType = (dragonTypes.count <= 1) && (windTypes.count <= 1)

        // Ensure it doesn't match Thirteen Orphans or other special cases
        return suitCount == 1 && hasHonors && hasSingleHonorType && !isThirteenOrphans(tiles) && !isValidSevenPairs(tiles)
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
        print("Checking for pair in tiles: \(tiles), Result: \(result)")
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
