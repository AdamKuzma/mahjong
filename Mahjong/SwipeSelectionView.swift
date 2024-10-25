//
//  SwipeSelectionView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/22/24.
//

import SwiftUI
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let impact = UIImpactFeedbackGenerator(style: .medium)
    
    private init() {
        // Prepare the haptic engine
        impact.prepare()
    }
    
    func playHaptic() {
        impact.impactOccurred()
    }
}

struct SwipeSelectionView: View {
    @State private var rectangleStates = Array(repeating: Array(repeating: false, count: 4), count: 2)
    @State private var isDragging = false
    @State private var dragColor = false
    @State private var activeRow: Int?
    
    private func updateRectangleState(row: Int, column: Int, to newState: Bool) {
        if rectangleStates[row][column] != newState {
            rectangleStates[row][column] = newState
            HapticManager.shared.playHaptic()
        }
    }
    
    let columns = [
      GridItem(.adaptive(minimum: 42), alignment: .leading)
    ]
        
        var body: some View {
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
              Text("sup")
                .border(Color.gray)
            }
            
            
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    ForEach(0..<2) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<4) { column in
                                Rectangle()
                                    .fill(rectangleStates[row][column] ? Color.white : Color.gray)
                                    .frame(width: 80, height: 80)
                                    .border(Color.black, width: 1)
                                    .onTapGesture {
                                        updateRectangleState(row: row, column: column, to: !rectangleStates[row][column])
                                    }
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear.preference(
                                                key: RectPreferenceKey.self,
                                                value: [RectData(row: row, column: column, rect: geo.frame(in: .named("dragSpace")))]
                                            )
                                        }
                                    )
                            }
                        }
                    }
                }
                .padding()
                .coordinateSpace(name: "dragSpace")
                .onPreferenceChange(RectPreferenceKey.self) { preferences in
                    rectPositions = preferences
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .named("dragSpace"))
                        .onChanged { value in
                            if !isDragging {
                                if let (row, column) = rectIndexAt(value.location) {
                                    isDragging = true
                                    activeRow = row
                                    dragColor = !rectangleStates[row][column]
                                    updateRectangleState(row: row, column: column, to: dragColor)
                                }
                            } else if let activeRow = activeRow,
                                      let (row, column) = rectIndexAt(value.location),
                                      row == activeRow {
                                updateRectangleState(row: row, column: column, to: dragColor)
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            activeRow = nil
                        }
                )
            }
        }
        
        @State private var rectPositions: [RectData] = []
        
        private func rectIndexAt(_ location: CGPoint) -> (row: Int, column: Int)? {
            guard let rectData = rectPositions.first(where: { rectData in
                rectData.rect.contains(location)
            }) else { return nil }
            
            return (rectData.row, rectData.column)
        }
    }

    struct RectPreferenceKey: PreferenceKey {
        static var defaultValue: [RectData] = []
        
        static func reduce(value: inout [RectData], nextValue: () -> [RectData]) {
            value.append(contentsOf: nextValue())
        }
    }

    struct RectData: Equatable {
        let row: Int
        let column: Int
        let rect: CGRect
    }



// MARK: - Preview

#Preview {
    SwipeSelectionView()
}
