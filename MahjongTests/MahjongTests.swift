//
//  MahjongTests.swift
//  MahjongTests
//
//  Created by Adam Kuzma on 10/2/24.
//

import XCTest
@testable import Mahjong

class ScoreCalculatorTests: XCTestCase {

    var scoreCalculator: ScoreCalculator!

    override func setUp() {
        super.setUp()
        scoreCalculator = ScoreCalculator()
    }

    override func tearDown() {
        scoreCalculator = nil
        super.tearDown()
    }

    func testAllChowsHand() {
        let tiles = createAllChowsHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "You get 1 Point for All Chow Hand", "All Chows hand did not validate correctly.")
    }

    func testInvalidAllChowsHand() {
        let tiles = createInvalidAllChowsHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "Oh no! You don't have a winning combination", "Invalid All Chows hand was not caught.")
    }

    func testMixedOneSuitHand() {
        let tiles = createMixedOneSuitHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "You get 3 Points for Mixed One Suit", "Mixed one suit hand did not validate correctly.")
    }
    
    func testInvalidMixedOneSuitHand() {
        let tiles = createInvalidMixedOneSuitHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "Oh no! You don't have a winning combination", "Invalid Mixed One Suit hand was not caught.")
    }
    
    func testPureHand() {
        let tiles = createPureHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "You get 7 Points for Pure Hand", "Pure hand did not validate correctly.")
    }
    
    func testInvalidPureHand() {
        let tiles = createInvalidPureHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "Oh no! You don't have a winning combination", "Invalid Pure Hand was not caught.")
    }

    func testSevenPairsHand() {
        let tiles = createSevenPairsHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "You get 4 Points for Seven Pairs", "Seven pairs hand did not validate correctly.")
    }
    
    func testInvalidSevenPairsHand() {
        let tiles = createInvalidSevenPairsHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "Oh no! You don't have a winning combination", "Invalid Seven Pairs hand was not caught.")
    }

    func testThirteenOrphansHand() {
        let tiles = createThirteenOrphansHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "You get 13 Points for Thirteen Orphans Hand", "Thirteen Orphans hand did not validate correctly.")
    }
    
    func testInvalidThirteenOrphansHand() {
        let tiles = createInvalidThirteenOrphansHand()
        let result = scoreCalculator.validateHand(tiles: tiles)
        XCTAssertEqual(result, "Oh no! You don't have a winning combination", "Invalid Thirteen Orphans hand was not caught.")
    }

    // Helper Methods to Create Specific Hands for Testing


    // MARK: - All Chows
    // Helper function to create a hand with all chows
    func createAllChowsHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
            Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
            Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
            Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false)
        ]
    }
    
    // Helper function to create an invalid All Chows hand
    func createInvalidAllChowsHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "bamboo_4", suit: "bamboo", number: 4, isHonor: false),
            Tile(name: "bamboo_5", suit: "bamboo", number: 5, isHonor: false),
            Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
            Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
            Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false), // This makes the hand invalid as it breaks a chow
            Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false),
            Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false)
        ]
    }

    // MARK: - Mixed One Suit

    // Helper function to create a Mixed One Suit hand
    func createMixedOneSuitHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false)
        ]
    }
    
    // Helper function to create an invalid Mixed One Suit hand
    func createInvalidMixedOneSuitHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false), // Breaks the Mixed One Suit rule
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false) // Pair
        ]
    }
    
    
    // MARK: - Pure Hand
    // Helper function to create a Pure Hand
    func createPureHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false)
        ]
    }
    
    // Helper function to create an invalid Pure Hand
    func createInvalidPureHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false), // Breaks the Pure Hand rule
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false) // Pair
        ]
    }
    
    // MARK: - Seven Pairs
    // Helper function to create a hand with seven pairs
    func createSevenPairsHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
            Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
            Tile(name: "character_4", suit: "characters", number: 4, isHonor: false),
            Tile(name: "character_4", suit: "characters", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
            Tile(name: "bamboo_6", suit: "bamboo", number: 6, isHonor: false),
            Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
            Tile(name: "character_7", suit: "characters", number: 7, isHonor: false)
        ]
    }
    
    // Helper function to create an invalid Seven Pairs hand
    func createInvalidSevenPairsHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
            Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
            Tile(name: "character_3", suit: "characters", number: 3, isHonor: false),
            Tile(name: "character_3", suit: "characters", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false), // Breaks Seven Pairs with extra tile
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false)
        ]
    }

    
    // MARK: - Thirteen Orphans
    
    // Helper function to create a Thirteen Orphans hand
    func createThirteenOrphansHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false),
            Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false) // The pair
        ]
    }
    
    // Helper function to create an invalid Thirteen Orphans hand
    func createInvalidThirteenOrphansHand() -> [Tile] {
        return [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false),
            Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false) // Invalid extra tile
        ]
    }
}

