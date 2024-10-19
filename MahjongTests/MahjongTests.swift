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
    
    
    // MARK: - Thirteen Orphans Hand 十三么 - 13 points
    func testThirteenOrphansHand() {
        let tiles = [
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
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Thirteen Orphans Hand 十三么", "Thirteen Orphans hand did not validate correctly.")
    }
    func testInvalidThirteenOrphansHand() {
        let tiles = [
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
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Thirteen Orphans hand was not caught.")
    }
    
    
    // MARK: - Great Winds Hand 大四喜 - 13 points
    func testGreatWindsHand() {
        let tiles = [
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false), // Pair
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false)
        ]
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Great Winds Hand 大四喜", "Valid Great Winds hand did not validate correctly.")
    }
    func testInvalidGreatWindsHand_MissingWindSet() {
        let tiles = [
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false), // Incomplete wind set
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false), // Pair
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false)
        ]
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Great Winds hand was not caught.")
    }
    
    
    // MARK: - Orphans Hand 么九 - 10 points
    func testValidOrphansHand() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),  // Pung of 1 dots
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),  // Pung of 1 bamboo
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),  // Pung of 9 characters
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),  // Pung of 9 dots
            Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false),
            Tile(name: "bamboo_9", suit: "bamboo", number: 9, isHonor: false)  // Pair of 9 bamboo
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Orphans Hand 么九", "Valid Orphans Hand was not recognized correctly.")
        XCTAssertEqual(result.1, 10, "Orphans Hand points were not calculated correctly.")
    }
    func testInvalidOrphansHandWithPairs() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Orphans Hand with other numbers was not caught.")
    }
    func testValidAllTripletsButNotOrphans() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "All Triplets Hand 對對糊", "Valid All Triplets hand was not recognized correctly.")
        XCTAssertEqual(result.1, 3, "All Triplets Hand points were not calculated correctly.")
    }
    
    
    // MARK: - Nine Gates Hand 九蓮寶燈 - 10 points
    func testValidNineGatesHand() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),  // 3 x 1 dot
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),  // 3 x 9 dot
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false)   // Extra tile (any tile from 1 to 9)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: true, isConcealedHand: true)
        XCTAssertEqual(result.0, "Nine Gates Hand 九蓮寶燈", "Valid Nine Gates Hand was not recognized correctly.")
        XCTAssertEqual(result.1, 10, "Nine Gates Hand points were not calculated correctly.")
    }
    func testInvalidNineGatesHand() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),  // 3 x 1 dot
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),  // 3 x 9 dot
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: true, isConcealedHand: true)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Nine Gates Hand was not caught correctly.")
    }
    
    
    // MARK: - All Honor Hand 字一色 - 10 points
    func testValidAllHonorTilesHand() {
        let tiles = [
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true)
        ]
        
        let result = scoreCalculator.validateHand(
            tiles: tiles,
            selectedSeatWind: .east,
            selectedPrevailingWind: .east,
            selectedFlowerTiles: [],
            isSelfDrawn: false,
            isConcealedHand: true
        )
        
        XCTAssertEqual(result.0, "All Honor Tiles Hand 字一色", "The hand should be recognized as All Honor Tiles.")
        XCTAssertEqual(result.1, 10, "The hand should score 10 points for All Honor Tiles.")
    }
    func testInvalidAllHonorTilesHand() {
        let tiles = [
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false), // Non-honor tile
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false), // Non-honor tile
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false), // Non-honor tile
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true)
        ]
        
        let result = scoreCalculator.validateHand(
            tiles: tiles,
            selectedSeatWind: .east,
            selectedPrevailingWind: .east,
            selectedFlowerTiles: [],
            isSelfDrawn: false,
            isConcealedHand: true
        )
        
        XCTAssertNotEqual(result.0, "All Honor Tiles Hand 字一色", "The hand should not be recognized as All Honor Tiles.")
        XCTAssertNotEqual(result.1, 10, "The hand should not score 10 points for All Honor Tiles.")
    }
    
    // MARK: - Great Dragons Hand 大三元 - 8 points
    func testGreatDragonsHand() {
        let tiles = [
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),  // Pung of Red Dragon
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),  // Pung of Green Dragon
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),  // Pung of White Dragon
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
            Tile(name: "bamboo_4", suit: "bamboo", number: 4, isHonor: false),
            Tile(name: "bamboo_5", suit: "bamboo", number: 5, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Great Dragons Hand 大三元", "Great Dragons Hand did not validate correctly.")
        XCTAssertEqual(result.1, 8, "Points for Great Dragons Hand should be 8.")
    }
    func testInvalidGreatDragonsHand() {
        let tiles = [
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),  // Missing 1 White Dragon tile
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Great Dragons Hand was not caught.")
    }
    
    
    // MARK: - Pure Hand 清一色 - 7 points
    func testPureHand() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Pure Hand 清一色", "Pure hand did not validate correctly.")
    }
    func testPureHandInvalid() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertNotEqual(result.0, "Pure Hand 清一色", "Invalid Pure Hand was not caught.")
    }
    
    
    // MARK: - Small Winds Hand 小四喜 - 6 points
    func testSmallWindsHand() {
        let tiles = [
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true), // Pair
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false), // Additional set
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false)
        ]
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Small Winds Hand 小四喜", "Valid Small Winds hand did not validate correctly.")
    }
    func testInvalidSmallWindsHand_MissingPair() {
        let tiles = [
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "east_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "south_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "west_wind", suit: "wind", number: nil, isHonor: true),
            Tile(name: "north_wind", suit: "wind", number: nil, isHonor: true), // Missing pair
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false), // Additional set
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false) // Extra tile
        ]
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Small Winds hand was not caught.")
    }
    
    
    // MARK: - Small Dragons Hand 小三元 - 5 points
    func testSmallDragonsHand() {
        let tiles = [
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),  // Pung of Red Dragon
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),  // Pung of Green Dragon
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),  // Pair of White Dragon
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),  // Chow of 1-2-3 dots
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false)   // Chow of 4-5-6 dots
        ]
        
        let result = scoreCalculator.validateHand(
            tiles: tiles,
            selectedSeatWind: .east,
            selectedPrevailingWind: .east,
            selectedFlowerTiles: [],
            isSelfDrawn: false,
            isConcealedHand: false
        )
        
        XCTAssertEqual(result.0, "Small Dragons Hand 小三元", "Small Dragons Hand did not validate correctly.")
        XCTAssertEqual(result.1, 5, "Points for Small Dragons Hand should be 5.")
    }
    func testInvalidSmallDragonsHand() {
        let tiles = [
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),  // Pung of Red Dragon
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),  // Missing one green dragon for a valid pung
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),  // Pair of White Dragon
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),  // Chow of 1-2-3 dots
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(
            tiles: tiles,
            selectedSeatWind: .east,
            selectedPrevailingWind: .east,
            selectedFlowerTiles: [],
            isSelfDrawn: false,
            isConcealedHand: false
        )
        
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Small Dragons Hand was not caught.")
    }
    
    
    // MARK: - Seven Pair Hand 七對子 - 4 points
    func testSevenPairsHand() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Seven Pair Hand 七對子", "Seven pairs hand did not validate correctly.")
    }
    func testInvalidSevenPairsHand() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Seven Pairs hand was not caught.")
    }
    func testInvalidSevenPairsHandRepeatPair() {
        let tiles = [
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
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Seven Pairs hand was not caught.")
    }
    
    
    // MARK: - Mixed One Suit Hand 混一色 - 3 points
    func testMixedOneSuitHand() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Mixed One Suit Hand 混一色", "Mixed One Suit hand did not validate correctly.")
    }
    func testMixedOneSuitHandFourChows() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),  // Chow of 1-2-3 dots
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),  // Chow of 1-2-3 dots
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),  // Chow of 1-2-3 dots
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),  // Chow of 1-2-3 dots
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true)   // Pair of Dragons
        ]
        
        // Validate the hand
        let result = scoreCalculator.validateHand(
            tiles: tiles,
            selectedSeatWind: .east,
            selectedPrevailingWind: .east,
            selectedFlowerTiles: [],
            isSelfDrawn: false,
            isConcealedHand: false
        )
        
        // Assertions
        XCTAssertEqual(result.0, "Mixed One Suit Hand 混一色", "The hand should be recognized as Mixed One Suit.")
        XCTAssertEqual(result.1, 3, "The hand should score 3 points for Mixed One Suit.")
    }
    func testInvalidMixedOneSuitHand() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Mixed One Suit hand was not caught.")
    }
    func testInvalidMixedOneSuitHandWithDragons() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "white_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true) // Different Dragons is not a valid meld
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid Mixed One Suit hand with multiple dragons was not caught.")
    }
    
    
    // MARK: - All Triplets Hand 對對糊 - 3 points
    func testAllTripletsHand() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "green_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true) // The pair
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "All Triplets Hand 對對糊", "All Triplets hand did not validate correctly.")
    }
    
    
    // MARK: - All Chow Hand 平糊 - 1 point
    func testAllChowsHand() {
        let tiles = [
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
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "All Chow Hand 平糊", "All Chows hand did not validate correctly.")
    }
    func testAllChowsHandOnesPair() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_2", suit: "bamboo", number: 2, isHonor: false),
            Tile(name: "bamboo_3", suit: "bamboo", number: 3, isHonor: false),
            Tile(name: "character_7", suit: "characters", number: 7, isHonor: false),
            Tile(name: "character_8", suit: "characters", number: 8, isHonor: false),
            Tile(name: "character_9", suit: "characters", number: 9, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "All Chow Hand 平糊", "All Chows hand did not validate correctly.")
    }
    func testAllChowsHandSameChows() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "character_1", suit: "characters", number: 1, isHonor: false),
            Tile(name: "character_1", suit: "characters", number: 1, isHonor: false) // Pair
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: true)
        
        XCTAssertEqual(result.0, "All Chow Hand 平糊", "The hand should be recognized as All Chow Hand")
    }
    func testInvalidAllChowsHand() {
        let tiles = [
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
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false), // Breaks
            Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false),
            Tile(name: "bamboo_7", suit: "bamboo", number: 7, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Oh no! You don't have a winning combination", "Invalid All Chows hand was not caught.")
    }
    
    
    // MARK: - Chicken Hand 雞糊 - 0 point
    func testChickenHand() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Chicken Hand 雞糊", "The hand should be recognized as Chicken Hand.")
    }
    func testChickenHandOnesPair() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertEqual(result.0, "Chicken Hand 雞糊", "The hand should be recognized as Chicken Hand.")
    }
    func testInvalidChickenHand() {
        let tiles = [
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_1", suit: "dots", number: 1, isHonor: false),
            Tile(name: "dot_2", suit: "dots", number: 2, isHonor: false),
            Tile(name: "dot_3", suit: "dots", number: 3, isHonor: false),
            Tile(name: "dot_4", suit: "dots", number: 4, isHonor: false),
            Tile(name: "dot_5", suit: "dots", number: 5, isHonor: false),
            Tile(name: "dot_6", suit: "dots", number: 6, isHonor: false),
            Tile(name: "dot_7", suit: "dots", number: 7, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "bamboo_1", suit: "bamboo", number: 1, isHonor: false),
            Tile(name: "red_dragon", suit: "dragon", number: nil, isHonor: true),
            Tile(name: "dot_8", suit: "dots", number: 8, isHonor: false),
            Tile(name: "dot_9", suit: "dots", number: 9, isHonor: false)
        ]
        
        let result = scoreCalculator.validateHand(tiles: tiles, selectedSeatWind: .east, selectedPrevailingWind: .east, selectedFlowerTiles: [], isSelfDrawn: false, isConcealedHand: false)
        XCTAssertNotEqual(result.0, "Chicken Hand 雞糊", "The hand should not be recognized as Chicken Hand.")
    }
    
}
