//
//  ContentView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var viewModel = MahjongViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView()
                    TileSectionView(viewModel: viewModel)
                }
                .padding()
            }
            
            StickyBarView(selectedCount: viewModel.selectedTilesCount) {
                isSheetPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            SheetContentView(selectedCount: viewModel.selectedTilesCount)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
    }
}


// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        Text("Hand Score")
            .font(.title2)
            .fontWeight(.semibold)
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
            
            Spacer(minLength: 30)
            
            TileAccordionView(title: "Flowers", tiles: $viewModel.flowerTiles, onTileTap: { index in viewModel.toggleTileState(index: index, for: .flowers) })
            AdditionalView()
            
            Spacer(minLength: 60)
        }
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
    
    @State private var selectedSeatWind: SeatWind = .east
    @State private var selectedPrevailingWind: PrevailingWind = .east
    @State private var isSelfDrawn: Bool = false
    @State private var isConcealed: Bool = false
    
    var body: some View {
        AccordionView(title: "Additional") {
            VStack(spacing: 25) {
                HStack {
                    Text("Seat Wind")
                        .font(.body)
                        .foregroundStyle(Color(UIColor.systemGray))
                    
                    Spacer()

                    Picker("Seat Wind", selection: $selectedSeatWind) {
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

                    Picker("Prevailing Wind", selection: $selectedPrevailingWind) {
                        ForEach(PrevailingWind.allCases) { wind in
                            Text(wind.rawValue).tag(wind)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown style
                }
                HStack {
                    Toggle(isOn: $isSelfDrawn) {
                        Text("Self Draw")
                            .font(.body)
                            .foregroundStyle(Color(UIColor.systemGray))
                    }
                }
                HStack {
                    Toggle(isOn: $isConcealed) {
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

// MARK: - Tile Accordion View
struct TileAccordionView: View {
    let title: String
    @Binding var tiles: [Tile]
    let onTileTap: (Int) -> Void
    
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
        Tile(name: "dot_1"), Tile(name: "dot_1"), Tile(name: "dot_1"), Tile(name: "dot_1"),
        Tile(name: "dot_2"), Tile(name: "dot_2"), Tile(name: "dot_2"), Tile(name: "dot_2"),
        Tile(name: "dot_3"), Tile(name: "dot_3"), Tile(name: "dot_3"), Tile(name: "dot_3"),
        Tile(name: "dot_4"), Tile(name: "dot_4"), Tile(name: "dot_4"), Tile(name: "dot_4"),
        Tile(name: "dot_5"), Tile(name: "dot_5"), Tile(name: "dot_5"), Tile(name: "dot_5"),
        Tile(name: "dot_6"), Tile(name: "dot_6"), Tile(name: "dot_6"), Tile(name: "dot_6"),
        Tile(name: "dot_7"), Tile(name: "dot_7"), Tile(name: "dot_7"), Tile(name: "dot_7"),
        Tile(name: "dot_8"), Tile(name: "dot_8"), Tile(name: "dot_8"), Tile(name: "dot_8"),
        Tile(name: "dot_9"), Tile(name: "dot_9"), Tile(name: "dot_9"), Tile(name: "dot_9")
    ]
    
    @Published var bambooTiles: [Tile] = [
        Tile(name: "bamboo_1"), Tile(name: "bamboo_1"), Tile(name: "bamboo_1"), Tile(name: "bamboo_1"),
        Tile(name: "bamboo_2"), Tile(name: "bamboo_2"), Tile(name: "bamboo_2"), Tile(name: "bamboo_2"),
        Tile(name: "bamboo_3"), Tile(name: "bamboo_3"), Tile(name: "bamboo_3"), Tile(name: "bamboo_3"),
        Tile(name: "bamboo_4"), Tile(name: "bamboo_4"), Tile(name: "bamboo_4"), Tile(name: "bamboo_4"),
        Tile(name: "bamboo_5"), Tile(name: "bamboo_5"), Tile(name: "bamboo_5"), Tile(name: "bamboo_5"),
        Tile(name: "bamboo_6"), Tile(name: "bamboo_6"), Tile(name: "bamboo_6"), Tile(name: "bamboo_6"),
        Tile(name: "bamboo_7"), Tile(name: "bamboo_7"), Tile(name: "bamboo_7"), Tile(name: "bamboo_7"),
        Tile(name: "bamboo_8"), Tile(name: "bamboo_8"), Tile(name: "bamboo_8"), Tile(name: "bamboo_8"),
        Tile(name: "bamboo_9"), Tile(name: "bamboo_9"), Tile(name: "bamboo_9"), Tile(name: "bamboo_9")
    ]
    
    @Published var characterTiles: [Tile] = [
        Tile(name: "character_1"), Tile(name: "character_1"), Tile(name: "character_1"), Tile(name: "character_1"),
        Tile(name: "character_2"), Tile(name: "character_2"), Tile(name: "character_2"), Tile(name: "character_2"),
        Tile(name: "character_3"), Tile(name: "character_3"), Tile(name: "character_3"), Tile(name: "character_3"),
        Tile(name: "character_4"), Tile(name: "character_4"), Tile(name: "character_4"), Tile(name: "character_4"),
        Tile(name: "character_5"), Tile(name: "character_5"), Tile(name: "character_5"), Tile(name: "character_5"),
        Tile(name: "character_6"), Tile(name: "character_6"), Tile(name: "character_6"), Tile(name: "character_6"),
        Tile(name: "character_7"), Tile(name: "character_7"), Tile(name: "character_7"), Tile(name: "character_7"),
        Tile(name: "character_8"), Tile(name: "character_8"), Tile(name: "character_8"), Tile(name: "character_8"),
        Tile(name: "character_9"), Tile(name: "character_9"), Tile(name: "character_9"), Tile(name: "character_9")
    ]
    
    @Published var windTiles: [Tile] = [
        Tile(name: "east_wind"), Tile(name: "east_wind"), Tile(name: "east_wind"), Tile(name: "east_wind"),
        Tile(name: "south_wind"), Tile(name: "south_wind"), Tile(name: "south_wind"), Tile(name: "south_wind"),
        Tile(name: "west_wind"), Tile(name: "west_wind"), Tile(name: "west_wind"), Tile(name: "west_wind"),
        Tile(name: "north_wind"), Tile(name: "north_wind"), Tile(name: "north_wind"), Tile(name: "north_wind")
    ]
    
    @Published var dragonTiles: [Tile] = [
        Tile(name: "red_dragon"), Tile(name: "red_dragon"), Tile(name: "red_dragon"), Tile(name: "red_dragon"),
        Tile(name: "green_dragon"), Tile(name: "green_dragon"), Tile(name: "green_dragon"), Tile(name: "green_dragon"),
        Tile(name: "white_dragon"), Tile(name: "white_dragon"), Tile(name: "white_dragon"), Tile(name: "white_dragon")
    ]
    
    @Published var flowerTiles: [Tile] = [
        Tile(name: "plum_flower"), Tile(name: "orchid_flower"), Tile(name: "bamboo_flower"), Tile(name: "chrysanthemum_flower"),
        Tile(name: "spring_season"), Tile(name: "summer_season"), Tile(name: "autumn_season"), Tile(name: "winter_season")
    ]
    
    @Published var selectedTilesCount = 0
    
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

        updateTileStates(for: category)
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
}

// MARK: - Tile Model and Views
struct Tile: Identifiable {
    let id = UUID()
    let name: String
    var state: MahjongTileView.TileState = .unselected
}

struct MahjongTileView: View {
    let tileName: String
    let state: TileState
    
    enum TileState {
        case unselected, selected, disabled
    }
    
    var body: some View {
        Image("placeholder")
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
                        .foregroundColor(.white)
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
            .padding()
            .background(Color(UIColor.systemGray6))
            .onTapGesture {
                onTap()
            }
        }
    }
}

// MARK: - Sheet Content View
struct SheetContentView: View {
    let selectedCount: Int
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Your Hand")
                    .font(.headline)
                Spacer()
                Text("\(selectedCount)/14")
                    .font(.headline)
            }
            
            Text("Score will show here")
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button(action: {
                // Add your score calculation logic here
                print("Calculating score...")
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
