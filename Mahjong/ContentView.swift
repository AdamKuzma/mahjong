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
    @State private var isViewLoaded = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(viewModel: viewModel)
                    TileSectionView(viewModel: viewModel)
                }
                .padding()
            }
            .refreshable {
                await performRefresh()
            }
            
            StickyBarView(selectedCount: viewModel.selectedTilesCount) {
                isSheetPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            HandScoreView(viewModel: viewModel)  // Pass viewModel to HandScoreView
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
    }
    
    func performRefresh() async {
        // Simulate a brief delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Reset tiles
        viewModel.resetTiles()
        
        // Trigger haptic feedback
        HapticFeedbackManager.triggerLightFeedback()
    }
    
}



// MARK: - Preview

#Preview {
    ContentView()
}
