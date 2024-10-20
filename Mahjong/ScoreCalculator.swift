//
//  ScoreCalculator.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI

class ScoreCalculator {
    
    // MARK: - Score Messages
    func validateHand(
        tiles: [Tile],
        selectedSeatWind: AdditionalView.SeatWind,
        selectedPrevailingWind: AdditionalView.PrevailingWind,
        selectedFlowerTiles: [Tile],
        isSelfDrawn: Bool,
        isConcealedHand: Bool
    ) -> (String, Int, Int, Int, Int, Int, Int) {
        
        print("Validating hand with \(tiles.count) tiles")
        print("Tiles: \(tiles.map { $0.name })")
        print("Seat Wind: \(selectedSeatWind), Prevailing Wind: \(selectedPrevailingWind)")
        print("Is Self Drawn: \(isSelfDrawn), Is Concealed Hand: \(isConcealedHand)")
        
        
        // Variable to hold the total score
        var handPoints = 0
        var handMessage = ""
        var windPoints = 0
        var dragonPoints = 0
        var flowerPoints = 0
        var selfDrawnPoints = 0
        var concealedHandPoints = 0
        
        // Flag to track if concealed hand bonus should be applied
        var applyConcealedBonus = isConcealedHand
        
        // Step 1: Check if there are 14 tiles
        guard tiles.count == 14 else {
            return ("Please select 14 tiles", 0, 0, 0, 0, 0, 0)
        }
        
        // Check for hand type points
        if isThirteenOrphans(tiles) {
            handMessage = "Thirteen Orphans Hand 十三么"
            handPoints += 13
            applyConcealedBonus = false  // Thirteen Orphans is always concealed
        } else if isGreatWinds(tiles) {
            handMessage = "Great Winds Hand 大四喜"
            handPoints += 13
        } else if isOrphansHand(tiles) {
            handMessage = "Orphans Hand 么九"
            handPoints += 10
        } else if isNineGatesHand(tiles, isConcealedHand: isConcealedHand) {
            handMessage = "Nine Gates Hand 九蓮寶燈"
            handPoints += 10
            applyConcealedBonus = false  // Nine Gates is always concealed
        } else if isAllHonorHand(tiles) {
            handMessage = "All Honor Tiles Hand 字一色"
            handPoints += 10
        } else if isGreatDragons(tiles) {
            handMessage = "Great Dragons Hand 大三元"
            handPoints += 8
        } else if isPureHand(tiles) {
            handMessage = "Pure Hand 清一色"
            handPoints += 7
        } else if isSmallWinds(tiles) {
            handMessage = "Small Winds Hand 小四喜"
            handPoints += 6
        } else if isSmallDragons(tiles) {
            handMessage = "Small Dragons Hand 小三元"
            handPoints += 5
        } else if isValidSevenPairs(tiles) {
            handMessage = "Seven Pair Hand 七對子"
            handPoints += 4
        } else if isMixedOneSuit(tiles) {
            handMessage = "Mixed One Suit Hand 混一色"
            handPoints += 3
        } else if isAllTriplets(tiles) {
            handMessage = "All Triplets Hand 對對糊"
            handPoints += 3
        } else if isAllChows(tiles) {
            handMessage = "All Chow Hand 平糊"
            handPoints += 1
        } else if isChickenHand(tiles) {
            handMessage = "Chicken Hand 雞糊"
            handPoints = 0
        } else {
            handMessage = "Oh no! You don't have a winning combination"
            handPoints = 0
            return (handMessage, 0, 0, 0, 0, 0, 0)
        }
        
        
        if handPoints > 0 {  // Only apply self drawn bonus if there's a valid hand
            if isSelfDrawn {
                selfDrawnPoints = 1
            }
            if applyConcealedBonus {
                concealedHandPoints = 1
            }
            
            windPoints = calculateWindPoints(tiles: tiles, seatWind: selectedSeatWind, prevailingWind: selectedPrevailingWind)
            
            flowerPoints = calculateFlowerPoints(selectedFlowerTiles: selectedFlowerTiles)
            //flowerPoints = calculateFlowerPoints(selectedFlowerTiles: selectedFlowerTiles, selectedSeatWind: selectedSeatWind)
            
            // Calculate dragon points (skip dragon bonus if it's a Dragon Hand)
            if !isSmallDragons(tiles) && !isGreatDragons(tiles) {
                dragonPoints = calculateDragonPoints(tiles: tiles)
            }
            
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
    
    
    // MARK: - Thirteen Orphans
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
    
    
    //MARK: - Nine Gates Hand
    private func isNineGatesHand(_ tiles: [Tile], isConcealedHand: Bool) -> Bool {
        // Ensure the hand is concealed
        guard isConcealedHand else {
            return false
        }

        // Ensure all tiles are from the same suit (dot, bamboo, or character) and no honors
        guard let suit = tiles.first?.suit,
              tiles.allSatisfy({ $0.suit == suit && !$0.isHonor }) else {
            return false
        }

        // Filter out number tiles only (ignore honors)
        let numberTiles = tiles.compactMap { $0.number }

        // Ensure there are exactly 14 tiles
        guard numberTiles.count == 14 else {
            return false
        }

        // Create a dictionary to count occurrences of each tile number
        var tileCounts = [Int: Int]()
        for number in numberTiles {
            tileCounts[number, default: 0] += 1
        }

        // Check for the core Nine Gates structure:
        // - At least 3 tiles of 1 and 9
        // - At least 1 tile each of 2, 3, 4, 5, 6, 7, 8
        let hasCore = tileCounts[1] ?? 0 >= 3 &&
                      tileCounts[9] ?? 0 >= 3 &&
                      (2...8).allSatisfy { tileCounts[$0] ?? 0 >= 1 }

        if !hasCore {
            return false
        }

        // Count the extra tile
        var extraCount = 0
        for number in 1...9 {
            let count = tileCounts[number] ?? 0
            let expectedCount = number == 1 || number == 9 ? 3 : 1
            extraCount += max(0, count - expectedCount)
        }

        print("Tile counts: \(tileCounts)")
        print("Has core structure: \(hasCore)")
        print("Extra count: \(extraCount)")
        
        // There should be exactly one extra tile
        return extraCount == 1
    }
    
    
    // MARK: - All Honor Hand
    private func isAllHonorHand(_ tiles: [Tile]) -> Bool {
        // Filter honor tiles (Winds and Dragons only)
        let honorTiles = tiles.filter { $0.suit == "wind" || $0.suit == "dragon" }
        
        // Ensure all 14 tiles are honor tiles
        guard honorTiles.count == 14 else {
            return false
        }
        
        // Group the honor tiles by their name
        let groupedTiles = Dictionary(grouping: honorTiles, by: { $0.name })
        
        var pungsCount = 0
        var pairCount = 0
        
        for (_, group) in groupedTiles {
            if group.count == 3 {
                pungsCount += 1
            } else if group.count == 4 {
                pungsCount += 1
            } else if group.count == 2 {
                pairCount += 1
            } else {
                return false  // Invalid tile count for Pungs, Kongs, or Pairs
            }
        }
        
        return pungsCount == 4 && pairCount == 1
    }
    
    
    // MARK: - Small Dragons
    private func isSmallDragons(_ tiles: [Tile]) -> Bool {
        // Filter for dragon tiles
        let dragonTiles = tiles.filter { $0.suit == "dragon" }

        // There must be exactly 8 dragon tiles (2 pungs and 1 pair of dragons)
        guard dragonTiles.count == 8 else {
            return false
        }

        // Group the dragon tiles by their name (Red, Green, White Dragons)
        let dragonsGrouped = Dictionary(grouping: dragonTiles, by: { $0.name })

        // Check for exactly 2 pungs and 1 pair
        let pungs = dragonsGrouped.filter { $0.value.count == 3 }.count
        let pairs = dragonsGrouped.filter { $0.value.count == 2 }.count

        // Must have 2 pungs and 1 pair among the dragon tiles
        guard pungs == 2 && pairs == 1 else {
            return false
        }

        // Check if the remaining non-dragon tiles form valid sets (e.g., two chows)
        let nonDragonTiles = tiles.filter { $0.suit != "dragon" }
        return isValidNonDragonSets(nonDragonTiles, isSmallDragons: true)
    }

    
    // MARK: - Great Dragons
    private func isGreatDragons(_ tiles: [Tile]) -> Bool {
        // Filter for dragon tiles
        let dragonTiles = tiles.filter { $0.suit == "dragon" }
        
        // There must be exactly 9 dragon tiles (3 pungs of dragons)
        guard dragonTiles.count == 9 else {
            return false
        }
        
        // Group the dragon tiles by their name (Red, Green, White Dragons)
        let dragonsGrouped = Dictionary(grouping: dragonTiles, by: { $0.name })
        
        // Check for exactly 3 pungs of dragons
        let pungs = dragonsGrouped.filter { $0.value.count == 3 }.count
        
        // Must have 3 pungs of all three dragon types
        guard pungs == 3 else {
            return false
        }
        
        // Ensure the remaining tiles form a valid pair and one set (pung or chow)
        let nonDragonTiles = tiles.filter { $0.suit != "dragon" }
        return isValidNonDragonSets(nonDragonTiles)
    }

    // Helper function to check if remaining tiles consist of two pungs, two chows, or one of each
    private func isTwoPungsOrTwoChowsOrPungAndChow(_ tiles: [Tile]) -> Bool {
        var remainingTiles = tiles
        var pungsCount = 0
        var chowsCount = 0
        
        // Try to find two sets (either pungs or chows)
        for _ in 0..<2 {
            if let pung = findPung(in: remainingTiles) {
                pungsCount += 1
                remainingTiles = removeTiles(pung, from: remainingTiles)
            } else if let chow = findChow(in: remainingTiles) {
                chowsCount += 1
                remainingTiles = removeTiles(chow, from: remainingTiles)
            } else {
                return false
            }
        }
        
        // Valid if we have two pungs, two chows, or one of each
        return (pungsCount == 2 || chowsCount == 2 || (pungsCount == 1 && chowsCount == 1))
    }

    // Helper function to check if remaining tiles consist of a pair and a pung or chow
    private func isPairAndPungOrChow(_ tiles: [Tile]) -> Bool {
        var remainingTiles = tiles

        // Try to extract the pung or chow
        if let pung = findPung(in: remainingTiles) {
            remainingTiles = removeTiles(pung, from: remainingTiles)
        } else if let chow = findChow(in: remainingTiles) {
            remainingTiles = removeTiles(chow, from: remainingTiles)
        } else {
            return false
        }

        // After removing the pung or chow, check if the remaining two tiles form a pair
        return isPair(remainingTiles)
    }
    
    // Adjusted to handle chow + pair scenario (e.g., 1 dot, 2 dot, 3 dot + 1 dot, 1 dot)
    private func isValidNonDragonSets(_ tiles: [Tile], isSmallDragons: Bool = false) -> Bool {
       var remainingTiles = tiles
       var setsFound = 0

       while !remainingTiles.isEmpty {
           if let chow = findChow(in: remainingTiles) {
               setsFound += 1
               remainingTiles = removeTiles(chow, from: remainingTiles)
           } else if let pung = findPung(in: remainingTiles) {
               setsFound += 1
               remainingTiles = removeTiles(pung, from: remainingTiles)
           } else {
               break
           }
       }

       if isSmallDragons {
           return setsFound == 2 && remainingTiles.isEmpty
       } else {
           return (setsFound == 2 && isPair(remainingTiles)) || (setsFound == 1 && isPair(remainingTiles))
       }
    }
    
    
    // MARK: - Orphans Hand
    private func isOrphansHand(_ tiles: [Tile]) -> Bool {
        // Filter for Ones and Nines only (from any suit)
        let onesAndNines = tiles.filter {
            ($0.number == 1 || $0.number == 9) && !$0.isHonor
        }
        
        // Check if we have exactly 14 tiles (4 sets and 1 pair)
        guard onesAndNines.count == 14 else {
            return false
        }
        
        // Group the tiles by their name (to check for sets of Pungs/Kongs)
        let groupedTiles = Dictionary(grouping: onesAndNines, by: { $0.name })

        var pungsCount = 0
        var pairCount = 0

        // Check each group of tiles for valid sets (Pungs or Kongs)
        for (_, group) in groupedTiles {
            if group.count == 3 {
                pungsCount += 1  // It's a Pung
            } else if group.count == 4 {
                pungsCount += 1  // It's a Kong
            } else if group.count == 2 {
                pairCount += 1   // It's a Pair
            } else {
                // If we encounter any set that isn't a valid Pung, Kong, or Pair, return false
                return false
            }
        }

        // Return true if we have exactly 4 Pungs/Kongs and 1 Pair
        return pungsCount == 4 && pairCount == 1
    }
    
    
    // MARK: - Small Winds
    private func isSmallWinds(_ tiles: [Tile]) -> Bool {
        // Filter for wind tiles only
        let windTiles = tiles.filter { $0.suit == "wind" }

        // There must be exactly 11 wind tiles (3 pungs and 1 pair of wind tiles)
        guard windTiles.count == 11 else {
            return false
        }

        // Group the wind tiles by their name
        let windsGrouped = Dictionary(grouping: windTiles, by: { $0.name })
        
        // Check for exactly 3 pungs of wind tiles and 1 pair of the fourth wind tile
        let pungs = windsGrouped.filter { $0.value.count == 3 }.count
        let pairs = windsGrouped.filter { $0.value.count == 2 }.count

        // Must have exactly 3 pungs and 1 pair among the wind tiles
        guard pungs == 3 && pairs == 1 else {
            return false
        }

        // Check if the remaining non-wind tiles form a valid set (either a pung or chow)
        let nonWindTiles = tiles.filter { $0.suit != "wind" }
        return isValidNonWindSet(nonWindTiles)
    }

    // Helper function to check if remaining non-wind tiles form a valid set (pung or chow)
    private func isValidNonWindSet(_ tiles: [Tile]) -> Bool {
        // There must be exactly 3 tiles for the remaining set
        guard tiles.count == 3 else {
            return false
        }
        
        // Try to form a pung or chow with the remaining tiles
        return findPung(in: tiles) != nil || findChow(in: tiles) != nil
    }

    
    // MARK: - Great Winds
    private func isGreatWinds(_ tiles: [Tile]) -> Bool {
        // Filter out the wind tiles
        let windTiles = tiles.filter { $0.suit == "wind" }
        
        // There must be exactly 12 wind tiles (4 pungs of wind)
        guard windTiles.count == 12 else {
            return false
        }

        // Group the wind tiles by their name
        let windsGrouped = Dictionary(grouping: windTiles, by: { $0.name })

        // Check for exactly 4 pungs of wind tiles
        let pungs = windsGrouped.filter { $0.value.count == 3 }.count
        guard pungs == 4 else {
            return false
        }

        // Ensure the remaining two tiles form a valid pair
        let nonWindTiles = tiles.filter { $0.suit != "wind" }
        return isPair(nonWindTiles)
    }
    
    
    
    //MARK: - Pure Hand
    private func isPureHand(_ tiles: [Tile]) -> Bool {
        // Ensure we have exactly 14 tiles
        guard tiles.count == 14 else { return false }

        // Filter out any honor tiles
        let suitTiles = tiles.filter { !$0.isHonor }
        
        // Get unique suits in the hand
        let suits = Set(suitTiles.map { $0.suit })

        // Ensure only one suit is present and no honor tiles
        let hasOnlyOneSuit = suits.count == 1
        let containsHonors = tiles.contains { $0.isHonor }

        // Check for a valid pair
        let hasPair = checkForPair(tiles)

        // A Pure Hand should have tiles only from one suit, no honors, and include a pair
        return hasOnlyOneSuit && !containsHonors && hasPair
    }

    private func checkForPair(_ tiles: [Tile]) -> Bool {
        // Group tiles by their name
        let groupedTiles = Dictionary(grouping: tiles, by: { $0.name })
        
        // Check if any group has exactly 2 tiles
        return groupedTiles.values.contains { $0.count == 2 }
    }
    
    
    //MARK: - Seven Pairs
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
    
    
    //MARK: - Mixed One Suit
    private func isMixedOneSuit(_ tiles: [Tile]) -> Bool {
        let suitedTiles = tiles.filter { !$0.isHonor }
        let honorTiles = tiles.filter { $0.isHonor }

        // Ensure we have both suited tiles and honor tiles
        guard !suitedTiles.isEmpty && !honorTiles.isEmpty else { return false }

        // Check if all suited tiles are of the same suit
        let suits = Set(suitedTiles.map { $0.suit })
        guard suits.count == 1 else { return false }

        // Ensure honor tiles are of the same type (either all dragons or all of one wind)
        let dragonTypes = Set(honorTiles.filter { $0.suit == "dragon" }.map { $0.name })
        let windTypes = Set(honorTiles.filter { $0.suit == "wind" }.map { $0.name })
        let hasSingleHonorType = (dragonTypes.count <= 1) && (windTypes.count <= 1) && (dragonTypes.count + windTypes.count == 1)

        if !hasSingleHonorType {
            return false
        }

        // Try to find valid combinations
        return findValidCombination(suitedTiles: suitedTiles, honorTiles: honorTiles)
    }

    private func findValidCombination(suitedTiles: [Tile], honorTiles: [Tile]) -> Bool {
        var remainingSuited = suitedTiles
        var remainingHonor = honorTiles
        var setsFound = 0
        var pairFound = false

        // Function to find sets in any order
        func findSets() {
            while setsFound < 4 && (!remainingSuited.isEmpty || !remainingHonor.isEmpty) {
                if let chow = findChow(in: remainingSuited) {
                    setsFound += 1
                    remainingSuited = removeTiles(chow, from: remainingSuited)
                } else if let pung = findPung(in: remainingSuited) {
                    setsFound += 1
                    remainingSuited = removeTiles(pung, from: remainingSuited)
                } else if let honorPung = findPung(in: remainingHonor) {
                    setsFound += 1
                    remainingHonor = removeTiles(honorPung, from: remainingHonor)
                } else {
                    break
                }
            }
        }

        // Find sets
        findSets()

        // Check for a pair in the remaining tiles
        if remainingSuited.count >= 2 && remainingSuited[0].name == remainingSuited[1].name {
            pairFound = true
            remainingSuited = removeTiles([remainingSuited[0], remainingSuited[1]], from: remainingSuited)
        } else if remainingHonor.count == 2 && remainingHonor[0].name == remainingHonor[1].name {
            pairFound = true
            remainingHonor = []
        }

        print("Sets found: \(setsFound)")
        print("Pair found: \(pairFound)")
        print("Remaining suited tiles: \(remainingSuited.map { $0.name })")
        print("Remaining honor tiles: \(remainingHonor.map { $0.name })")

        return setsFound == 4 && pairFound && remainingSuited.isEmpty && remainingHonor.isEmpty
    }
    
    
    // MARK: - All Pungs
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
    
    
    // MARK: - All Chows
    private func isAllChows(_ tiles: [Tile]) -> Bool {
        var remainingTiles = tiles
        var chowsFound = 0

        // Try to extract chows
        while chowsFound < 4 && remainingTiles.count >= 3 {
            if let chow = findChow(in: remainingTiles) {
                chowsFound += 1
                remainingTiles = removeTiles(chow, from: remainingTiles)
            } else {
                break
            }
        }

        let isPairRemaining = isPair(remainingTiles)

        return chowsFound == 4 && isPairRemaining
    }
    
    
    // MARK: - Chicken Hand
    private func isChickenHand(_ tiles: [Tile]) -> Bool {
        print("Starting Chicken Hand check with tiles: \(tiles.map { $0.name })")
        
        let (sets, remainingTiles) = findBestCombination(tiles)
        
        let pungsCount = sets.filter { $0.count == 3 && $0[0].name == $0[1].name && $0[1].name == $0[2].name }.count
        let chowsCount = sets.count - pungsCount
        let isPairRemaining = isPair(remainingTiles)
        
        print("Chicken Hand check: Sets found: \(sets.count) (Pungs: \(pungsCount), Chows: \(chowsCount))")
        print("Remaining tiles: \(remainingTiles.map { $0.name })")
        print("Is pair remaining: \(isPairRemaining)")
        
        return sets.count == 4 && isPairRemaining
    }
    
    
    
    //MARK: - Basic Logic
    
    private func findBestCombination(_ tiles: [Tile]) -> ([[Tile]], [Tile]) {
        let sortedTiles = tiles.sorted { ($0.suit, $0.number ?? 0) < ($1.suit, $1.number ?? 0) }
        var bestCombination: ([[Tile]], [Tile]) = ([], sortedTiles)
        var bestScore = 0
        
        func backtrack(_ currentTiles: [Tile], _ currentSets: [[Tile]], _ remainingTiles: [Tile], _ depth: Int) {
            // Base case: if we've found 4 sets or exhausted all tiles
            if currentSets.count == 4 || remainingTiles.isEmpty {
                let score = currentSets.count * 3 + (isPair(remainingTiles) ? 2 : 0)
                if score > bestScore {
                    bestScore = score
                    bestCombination = (currentSets, remainingTiles)
                }
                return
            }
            
            // Try to form a pung
            if let pung = findPung(in: remainingTiles) {
                var newRemaining = removeTiles(pung, from: remainingTiles)
                backtrack(currentTiles, currentSets + [pung], newRemaining, depth + 1)
            }
            
            // Try to form a chow
            if let chow = findChow(in: remainingTiles) {
                var newRemaining = removeTiles(chow, from: remainingTiles)
                backtrack(currentTiles, currentSets + [chow], newRemaining, depth + 1)
            }
            
            // If we can't form a set, try to form a pair if we don't have 4 sets yet
            if currentSets.count < 4 && isPair(Array(remainingTiles.prefix(2))) {
                let pair = Array(remainingTiles.prefix(2))
                var newRemaining = removeTiles(pair, from: remainingTiles)
                backtrack(currentTiles, currentSets, pair + newRemaining, depth + 1)
            }
            
            // If we can't form a set or pair, move on to the next tile
            if !remainingTiles.isEmpty {
                backtrack(currentTiles + [remainingTiles[0]], currentSets, Array(remainingTiles.dropFirst()), depth + 1)
            }
        }
        
        backtrack([], [], sortedTiles, 0)
        return bestCombination
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
    
    
    // Finds a chow (three consecutive tiles of the same suit), ensuring not to consume pair tiles
    private func findChow(in tiles: [Tile]) -> [Tile]? {
        let groupedBySuit = Dictionary(grouping: tiles.filter { !$0.isHonor }) { $0.suit }

        for (_, suitTiles) in groupedBySuit {
            let sortedTiles = suitTiles.compactMap { $0.number }.sorted()
            
            guard sortedTiles.count >= 3 else { continue }
            
            for i in 0...(sortedTiles.count - 3) {
                if sortedTiles[i] + 1 == sortedTiles[i + 1] && sortedTiles[i] + 2 == sortedTiles[i + 2] {
                    let chowNumbers = Set(sortedTiles[i...(i+2)])
                    let chowTiles = suitTiles.filter { tile in
                        guard let number = tile.number else { return false }
                        return chowNumbers.contains(number)
                    }
                    
                    if chowTiles.count == 3 {
                        return Array(chowTiles)
                    }
                }
            }
        }

        return nil
    }

    private func wouldBreakPair(_ set: [Tile], in tiles: [Tile]) -> Bool {
        let remainingTiles = tiles.filter { tile in !set.contains { $0.id == tile.id } }
        
        // Create a dictionary to count occurrences of each tile
        let pairCounts = Dictionary(grouping: remainingTiles) { $0.name }.mapValues { $0.count }
        
        // Return true if there is any tile left that cannot form a pair
        return pairCounts.values.contains { $0 == 1 }
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
    
    
    // Finds a pair
    private func isPair(_ tiles: [Tile]) -> Bool {
        guard tiles.count == 2 else { return false }
        return tiles[0].name == tiles[1].name
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
