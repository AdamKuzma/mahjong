//
//  TileSectionView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/21/24.
//

import SwiftUI
import UIKit


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
    
    // State for drag gesture
   @State private var isDragging = false
   @State private var dragState: MahjongTileView.TileState?
   @GestureState private var location: CGPoint = .zero
  
    
    var body: some View {
        AccordionView(title: title) {
            GeometryReader { geometry in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 6) {
                    ForEach(tiles.indices, id: \.self) { index in
                        MahjongTileView(tileName: tiles[index].name, state: tiles[index].state)
                            .onTapGesture { onTileTap(index) }
                            .background(
                                GeometryReader { tileGeometry in
                                    Color.clear.preference(
                                        key: TilePreferenceKey.self,
                                        value: [TilePosition(index: index, frame: tileGeometry.frame(in: .named("dragSpace")))]
                                    )
                                }
                            )
                    }
                }
                .coordinateSpace(name: "dragSpace")
                .onPreferenceChange(TilePreferenceKey.self) { preferences in
                    tilePositions = preferences
                }
                .simultaneousGesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .named("dragSpace"))
                                        .onChanged { value in
                                            // Only handle horizontal drags
                                            if abs(value.translation.width) > abs(value.translation.height) {
                                                if !isDragging {
                                                    // Start of drag
                                                    if let index = tileIndexAt(value.location) {
                                                        isDragging = true
                                                        dragState = tiles[index].state == .selected ? .unselected : .selected
                                                        onTileTap(index)
                                                    }
                                                } else {
                                                    // During drag
                                                    if let index = tileIndexAt(value.location),
                                                       tiles[index].state != dragState,
                                                       tiles[index].state != .disabled {
                                                        onTileTap(index)
                                                    }
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            isDragging = false
                                            dragState = nil
                                        }
                                )
                            }
            .frame(height: CGFloat(ceil(Double(tiles.count) / 4.0)) * 106) // Adjust height based on number of rows
        }
    }
    
    @State private var tilePositions: [TilePosition] = []
        
    private func tileIndexAt(_ location: CGPoint) -> Int? {
        return tilePositions.first { position in
            position.frame.contains(location)
        }?.index
    }
}


// Preference key for tile positions
struct TilePreferenceKey: PreferenceKey {
    static var defaultValue: [TilePosition] = []
    
    static func reduce(value: inout [TilePosition], nextValue: () -> [TilePosition]) {
        value.append(contentsOf: nextValue())
    }
}

// Data structure to store tile position information
struct TilePosition: Equatable {
    let index: Int
    let frame: CGRect
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
