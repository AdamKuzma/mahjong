//
//  Stories.swift
//  Mahjong
//

// MARK: - Stories
//
//  I need to be able to select all Mahjong tiles with their respective design, including flowers
//
//  I need to be able to select additional properties like self-draw
//
//  I need to be able to open a detail drawer and see my hand and Calculate button
//
//  I need to be able to press calculate button to count my hand score
//
//  I need to be able to see my hand score 
//
//


// MARK: - Basic Hand Validation

//    Check hand has 14 tiles
//    If not: "Please select 14 tiles"
//
//    Check hand has a valid 4 set + 1 pair or 7 pair structure 
//    If not: "You don't have a winning combination"

//    Identify Sets
//    Identify all chows, pungs, and kongs
//    Identify the pair


// MARK: - Evaluate Hand Composition

//    Once Basic hand validation is approved:

//     All Chows (平和 - Ping Hu):
//    If the hand consists of only chows and a pair, award 1 point (valid hand)
//     Pure Hand (清一色 - Qing Yi Se):
//    If all tiles are from a single suit, award 7 points. 
//    Mixed One Suit (混一色 - Hun Yi Se):
//    If all tiles are from one suit plus honors, award 3 points.
//
//    Seven Pairs (七對子 - Qi Dui Zi):
//    If the hand consists of 7 pairs, award 4 points.
//
//    Thirteen Orphans (十三幺 - Shi San Yao):
//    If the hand is a valid Thirteen Orphans, award 13 points.
//     
//    Honor Tile Bonuses:
//    For each pung of dragons, award 1 point.
//    For a pung of the player's seat wind, award 1 point.
//    For a pung of the prevailing wind, award 1 point.
//
//
//    Additional Inputs:
//    Self-Draw (自摸 - Zi Mo): If the player drew the winning tile, add 1 point.
//    Fully Concealed Hand (門前清 - Men Qian Qing): If no tiles were claimed from discards, add 1 point.
//    Winning on the Last Tile (海底撈月 - Hai Di Lao Yue): If it's the last tile from the wall, add 1 point.
//    Robbing a Kong (搶槓 - Qiang Gang): If won by claiming a tile used to extend a pung to a kong, add 1 point.
//     
//    Flowers and Seasons:
//    Add 1 point for each Flower or Season tile.
//
//
//

// MARK: - Tests


// [FAIL] - Thirteen Orphans - Gets recognized as Mixed One Suit

// [FAIL] - Pure Hand - When selecting 4 pungs of Dot and a pair of Bamboo is mistakes as a Pure Hand. When selecting pair of Characters it counts as invalid hand
// [FAIL] - Pure Hand - When selecting 4 pairs of Winds and 2 Pungs of Dots, it mistakes as a Pure Hand.

// [FAIL] - Seven Pairs - Only recognizes unique pairs

// [FAIL] - Mixed One Suit - Always gets recognized as a Pure Hand

// Switching between accordions messes up the disabled state

// Disabled state triggers haptic feedback
