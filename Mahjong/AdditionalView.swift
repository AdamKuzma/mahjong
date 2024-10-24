//
//  HeaderView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/21/24.
//

import SwiftUI
import UIKit


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


// MARK: - Sticky Bar
struct StickyBarView: View {
    let selectedCount: Int
    let onTap: () -> Void
    let calculateScore: () -> Void
    
    @State private var showDynamicText = false
    @State private var isLoading = false  // Add this state
    
    private var isHidden: Bool {
        selectedCount == 0
    }
    
    private var isHandComplete: Bool {
        selectedCount == 14
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                if isHandComplete {
                    isLoading = true  // Start loading
                    calculateScore()
                    
                    // Simulate a brief delay before showing the sheet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading = false  // Stop loading
                        onTap()  // Show the sheet
                    }
                } else {
                    onTap()
                }
            }) {
                HStack(spacing: 8) {
                    if isHandComplete {
                        if isLoading {
                            ProgressView()  // Show spinner
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(0.8)
                        } else {
                            Text("Calculate Score")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    } else if !showDynamicText {
                        Text("Selected 1/14")
                            .font(.headline)
                            .foregroundColor(.white)
                            .opacity(isHidden ? 0 : 1)
                    } else {
                        Text("Selected \(selectedCount)/14")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity) // This makes the HStack span full width
                .background(isHandComplete ? Color.white : Color(UIColor.systemGray6))
                .animation(.spring(response: 0.3), value: isHandComplete) // Animate background change
                .cornerRadius(14)
            }
            .disabled(isLoading || (!isHandComplete && selectedCount > 0))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(.black)
        .offset(y: isHidden ? 160 : 0) // Move view 100 points down when hidden
        .animation(.easeInOut(duration: 0.3), value: isHidden) // Animate changes
        .onChange(of: selectedCount) { _, count in
            if count > 1 {
                // Delay the swap to dynamic text
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showDynamicText = true
                }
            }
            if count == 0 {
                showDynamicText = false // Reset when all tiles are deselected
            }
        }
    }
}
