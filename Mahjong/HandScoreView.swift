//
//  HandScoreView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/21/24.
//

import SwiftUI
import UIKit


// MARK: - Hand Score View
struct HandScoreView: View {
    @ObservedObject var viewModel: MahjongViewModel
    @State private var handMessage: String = ""
    @State private var handPoints: Int = 0
    @State private var flowerPoints: Int = 0
    @State private var dragonPoints: Int = 0
    @State private var windPoints: Int = 0
    @State private var selfDrawnPoints: Int = 0
    @State private var concealedHandPoints: Int = 0
    let scoreCalculator = ScoreCalculator()
    
    
    func calculateScore() {
        // Trigger haptic feedback when the button is pressed
        HapticFeedbackManager.triggerLightFeedback()
        
        // Validate the selected tiles and update the message
        let selectedTiles = viewModel.allSelectedTiles()
        let selectedFlowerTiles = viewModel.flowerTiles.filter { $0.state == .selected }
        
        // Unpack the tuple into three variables
        let (message, handPts, flowerPts, dragonPts, windPts, selfDrawnPts, concealedHandPts) = scoreCalculator.validateHand(
            tiles: selectedTiles,
            selectedSeatWind: viewModel.selectedSeatWind,
            selectedPrevailingWind: viewModel.selectedPrevailingWind,
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
    }
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Your Hand")
                    .font(.headline)
                Spacer()
//                Text("\(viewModel.selectedTilesCount)/14")  // Show selected tile count
//                    .font(.headline)
            }
            
            Divider()
            
            // Hand Points
            HStack {
                Text(handMessage)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if handPoints > 0 || handMessage == "Chicken Hand 雞糊" {
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
            if handPoints > 0 || handMessage == "Chicken Hand 雞糊" {
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
            
            Button(action: calculateScore) {
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
