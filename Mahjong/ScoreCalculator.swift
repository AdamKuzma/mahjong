//
//  ScoreCalculator.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI

class ScoreCalculator {
    
    // Validates if the hand has a valid structure
    func validateHand(tiles: [Tile]) -> String {
        // Step 1: Check if there are 14 tiles
        guard tiles.count == 14 else {
            return "Please select 14 tiles"
        }
        
        // Step 2: Check for valid structure
        if isValidFourSetsOnePair(tiles) {
            return "Yay! You have a winning combination"
        } else if isValidSevenPairs(tiles) {
            return "Yay! You have a winning combination"
        } else {
            return "Oh no! You don't have a winning combination"
        }
    }
    
    // Checks if the hand has 4 valid sets and 1 pair
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
    
    // Checks if the hand has 7 valid pairs
    private func isValidSevenPairs(_ tiles: [Tile]) -> Bool {
        // Count the occurrences of each tile
        let tileCounts = Dictionary(grouping: tiles) { $0.name }.mapValues { $0.count }
        
        // Check if there are exactly 7 pairs (each tile appears twice)
        return tileCounts.values.filter { $0 == 2 }.count == 7
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
        // Group tiles by suit (ignore dragons and winds for chows)
        let groupedBySuit = Dictionary(grouping: tiles.filter { !$0.isHonor }) { $0.suit }
        
        for (_, suitTiles) in groupedBySuit {
            // Sort tiles by their number, unwrapping safely
            let sortedTiles = suitTiles.sorted {
                if let num1 = $0.number, let num2 = $1.number {
                    return num1 < num2
                }
                return false // Return false if any of the numbers are nil
            }
            
            // Find three consecutive tiles in the sorted array
            for i in 0..<sortedTiles.count - 2 {
                if let num1 = sortedTiles[i].number,
                   let num2 = sortedTiles[i + 1].number,
                   let num3 = sortedTiles[i + 2].number,
                   num1 + 1 == num2 && num2 + 1 == num3 {
                    return [sortedTiles[i], sortedTiles[i + 1], sortedTiles[i + 2]]
                }
            }
        }
        
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
        return tiles.count == 2 && tiles[0].name == tiles[1].name
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
