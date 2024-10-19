//
//  ContentView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI
import UIKit

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var viewModel = MahjongViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(viewModel: viewModel)
                    TileSectionView(viewModel: viewModel)
                }
                .padding()
            }
            
            StickyBarView(selectedCount: viewModel.selectedTilesCount) {
                isSheetPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            SheetContentView(viewModel: viewModel)  // Pass viewModel to SheetContentView
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
    }
}


// MARK: - Header View
struct HeaderView: View {
    @ObservedObject var viewModel: MahjongViewModel
    
    var body: some View {
        HStack {
            Text("Hand Score")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer() // Pushes the "X" icon to the right end
            
            if viewModel.selectedTilesCount > 0 {
                Button(action: {
                    viewModel.resetTiles() // Call the reset method on the view model
                    HapticFeedbackManager.triggerLightFeedback() // Trigger haptic feedback
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundColor(.white) // You can change the color as you prefer
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
    }
}

// MARK: - Tile Section View
struct TileSectionView: View {
    @ObservedObject var viewModel: MahjongViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            TileAccordionView(title: "Dots", tiles: $viewModel.dotTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .dots) })
            TileAccordionView(title: "Bamboo", tiles: $viewModel.bambooTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .bamboo) })
            TileAccordionView(title: "Characters", tiles: $viewModel.characterTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .characters) })
            TileAccordionView(title: "Winds", tiles: $viewModel.windTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .winds) })
            TileAccordionView(title: "Dragons", tiles: $viewModel.dragonTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .dragons) })
            TileAccordionView(title: "Flowers", tiles: $viewModel.flowerTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .flowers) })
            AdditionalView(viewModel: viewModel)
            
            Spacer(minLength: 60)
        }
    }
}


// MARK: - Tile Accordion View
struct TileAccordionView: View {
    let title: String
    @Binding var tiles: [Tile]
    let onTileTap: (Int) -> Void
    @State private var isDragging = false
    @State private var activeTileIndex: Int? = nil
    
    var body: some View {
        AccordionView(title: title) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 6) {
                ForEach(tiles.indices, id: \.self) { index in
                    MahjongTileView(tileName: tiles[index].name, state: tiles[index].state)
                        .onTapGesture { onTileTap(index) }
                }
            }
        }
    }
}

// MARK: - ViewModel
class MahjongViewModel: ObservableObject {
    enum TileCategory {
        case dots, bamboo, characters, winds, dragons, flowers
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


// MARK: - Additional View
struct AdditionalView: View {
    
    enum SeatWind: String, CaseIterable, Identifiable {
        case north = "North Wind"
        case east = "East Wind"
        case south = "South Wind"
        case west = "West Wind"
        
        var id: String { self.rawValue }
    }
    
    enum PrevailingWind: String, CaseIterable, Identifiable {
        case north = "North Wind"
        case east = "East Wind"
        case south = "South Wind"
        case west = "West Wind"
        
        var id: String { self.rawValue }
    }
    
    @ObservedObject var viewModel: MahjongViewModel
    
    var body: some View {
        AccordionView(title: "Additional") {
            VStack(spacing: 25) {
                HStack {
                    Text("Seat Wind")
                        .font(.body)
                        .foregroundStyle(Color(UIColor.systemGray))
                    
                    Spacer()

                    Picker("Seat Wind", selection: $viewModel.selectedSeatWind) {
                        ForEach(SeatWind.allCases) { wind in
                            Text(wind.rawValue).tag(wind)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown style
                }
                
                HStack {
                    Text("Prevailing Wind")
                        .font(.body)
                        .foregroundStyle(Color(UIColor.systemGray))
                    
                    Spacer()

                    Picker("Prevailing Wind", selection: $viewModel.selectedPrevailingWind) {
                        ForEach(PrevailingWind.allCases) { wind in
                            Text(wind.rawValue).tag(wind)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown style
                }
                HStack {
                    Toggle(isOn: $viewModel.isSelfDrawn) {
                        Text("Self Draw")
                            .font(.body)
                            .foregroundStyle(Color(UIColor.systemGray))
                    }
                }
                HStack {
                    Toggle(isOn: $viewModel.isConcealedHand) {
                        Text("Concealed Hand")
                            .font(.body)
                            .foregroundStyle(Color(UIColor.systemGray))
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 40)
            .padding(.horizontal, 4)
        }
    }
}



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

// MARK: - Accordion View
struct AccordionView<Content: View>: View {
    let title: String
    let content: Content
    @State private var isExpanded: Bool = false
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundStyle(Color(UIColor.systemGray2))
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
            }
            
            if isExpanded {
                content
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Sticky Bar
struct StickyBarView: View {
    let selectedCount: Int
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Text("Your Hand")
                    .font(.headline)
                Spacer()
                Text("\(selectedCount)/14")
                    .font(.headline)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                Color.black.opacity(0.3)
            )
            .background(.thinMaterial)
            .onTapGesture {
                onTap()
            }
        }
    }
}


// MARK: - Sheet Content View
struct SheetContentView: View {
    @ObservedObject var viewModel: MahjongViewModel
    @State private var handMessage: String = ""
    @State private var handPoints: Int = 0
    @State private var flowerPoints: Int = 0
    @State private var dragonPoints: Int = 0
    @State private var windPoints: Int = 0
    @State private var selfDrawnPoints: Int = 0
    @State private var concealedHandPoints: Int = 0
    let scoreCalculator = ScoreCalculator()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Your Hand")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.selectedTilesCount)/14")  // Show selected tile count
                    .font(.headline)
            }
            
            Divider()
            
            // Hand Points
            HStack {
                Text(handMessage)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if handPoints > 0 {
                    Text("\(handPoints)")
                }
            }
            
            // Flower Points
            if flowerPoints > 0 {
                Divider()
                
                HStack {
                    Text("Flower Points")
                        .font(.body)
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("+\(flowerPoints)")
                        .font(.body)
                        .foregroundColor(.green)
                }
            }
            
            // Dragon Points
            if dragonPoints > 0 {
                Divider()
                
                HStack {
                    Text("Dragon Points")
                        .font(.body)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("+\(dragonPoints)")
                        .font(.body)
                        .foregroundColor(.orange)
                }
            }
            
            // Wind Points
            if windPoints > 0 {
                Divider()
                
                HStack {
                    Text("Wind Points")
                        .font(.body)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("+\(windPoints)")
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            
            // Self Drawn Points
            if selfDrawnPoints > 0 {
                Divider()
                
                HStack {
                    Text("Self Drawn")
                        .font(.body)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("+\(selfDrawnPoints)")
                        .font(.body)
                        .foregroundColor(.purple)
                }
            }
            
            // Concealed Hand Points
            if concealedHandPoints > 0 {
                Divider()
                
                HStack {
                    Text("Concealed Hand")
                        .font(.body)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("+\(concealedHandPoints)")
                        .font(.body)
                        .foregroundColor(.purple)
                }
            }
            
            // Total Points
            if handPoints > 0 {
                Divider()
                
                HStack {
                    Text("Total points")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("\(handPoints + windPoints + flowerPoints + dragonPoints + selfDrawnPoints + concealedHandPoints)")
                        .font(.headline)
                }
            }
                
            Spacer()
            
            Button(action: {
                // Trigger haptic feedback when the button is pressed
                HapticFeedbackManager.triggerLightFeedback()
                
                // Validate the selected tiles and update the message
                let selectedTiles = viewModel.allSelectedTiles()
                let selectedFlowerTiles = viewModel.flowerTiles.filter { $0.state == .selected }
                
                print("Selected tiles: \(selectedTiles.map { $0.name })")
                print("Selected seat wind: \(viewModel.selectedSeatWind.rawValue)")
                print("Selected prevailing wind: \(viewModel.selectedPrevailingWind.rawValue)")
                
                // Unpack the tuple into three variables
                let (message, handPts, flowerPts, dragonPts, windPts, selfDrawnPts, concealedHandPts) = scoreCalculator.validateHand(
                    tiles: selectedTiles,
                    selectedSeatWind: viewModel.selectedSeatWind,  // Ensure this is of type SeatWind
                    selectedPrevailingWind: viewModel.selectedPrevailingWind, // Ensure this is of type PrevailingWind
                    selectedFlowerTiles: selectedFlowerTiles,
                    isSelfDrawn: viewModel.isSelfDrawn,
                    isConcealedHand: viewModel.isConcealedHand
                )
                                
                handMessage = message
                handPoints = handPts
                flowerPoints = flowerPts
                dragonPoints = dragonPts
                windPoints = windPts
                selfDrawnPoints = selfDrawnPts
                concealedHandPoints = concealedHandPts
                
            }) {
                Text("Calculate Score")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}
