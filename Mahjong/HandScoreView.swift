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
    @Environment(\.dismiss) var dismiss
    
    private var totalPoints: Int {
        viewModel.handPoints + viewModel.windPoints + viewModel.flowerPoints +
        viewModel.dragonPoints + viewModel.selfDrawnPoints + viewModel.concealedHandPoints
    }
    
    private var pointsMessage: String {
        switch totalPoints {
        case 13:
            return "You’ve achieved the impossible!"
        case 12:
            return "That’s a legendary win!"
        case 11:
            return "Unbelievable hand! That’s a huge score!"
        case 10:
            return "Wow! That’s a powerful hand!"
        case 8...9:
            return "Impressive hand! You’re on fire!"
        case 7:
            return "Getting serious now! You’re in the game!"
        case 5...6:
            return "Great job! You’re stacking up nicely!"
        case 4:
            return "Solid hand! You’re building up!"
        case 3:
            return "A good hand—keep up the pace!"
        case 1...2:
            return "A small win! Every point counts!"
        case 0:
            if viewModel.handMessage == "Chicken Hand 雞糊" {
                return "Chicken Hand! Better luck next time!"
            } else {
                return "Oh no! That’s not a valid hand!"
            }
        default:
            return "Total Points"
        }
    }
        
    private var handTypeEmoji: String {
        switch viewModel.handMessage {
        case let message where message.contains("Thirteen Orphans"):
            return "🦄"
        case let message where message.contains("Great Winds"):
            return "🌪️"
        case let message where message.contains("Orphans"):
            return "🌚"
        case let message where message.contains("Nine Gates"):
            return "⛩️"
        case let message where message.contains("All Honor"):
            return "👑"
        case let message where message.contains("Great Dragons"):
            return "🔥"
        case let message where message.contains("Pure Hand"):
            return "💎"
        case let message where message.contains("Small Winds"):
            return "🍃"
        case let message where message.contains("Small Dragons"):
            return "🐉"
        case let message where message.contains("Seven Pair"):
            return "🔗"
        case let message where message.contains("All Triplets"):
            return "🌟"
        case let message where message.contains("Mixed One Suit"):
            return "🎨"
        case let message where message.contains("All Chow"):
            return "🌿"
        case let message where message.contains("Chicken Hand"):
            return "🐔"
        default:
            return ""
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            
            
            // ------ Total Points ------
            
            HStack {
                
                if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand 雞糊" {
                    VStack(spacing: 24) {
                        Text(handTypeEmoji)
                            .font(.system(size: 42))
                            .lineSpacing(70)
                        
                        
                        VStack(spacing: 16) {
                            Text(pointsMessage)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("\(totalPoints) points")
                                .font(.system(size: 32, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                            
                        HStack {
                            Text(viewModel.handMessage)
                                .font(.system(size: 12))  // or .subheadline for smaller text
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(red: 36/255, green: 36/255, blue: 36/255))  // Light gray background
                                .cornerRadius(16)  // Rounded corners
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                    }
                    .padding(.vertical, 24)
                }
            }
            
            Spacer()  // This pushes everything up and the button to the bottom
                        
            Button(action: {
                viewModel.resetTiles()  // Reset the tiles
                dismiss()  // Dismiss the sheet
            }) {
                Text("Start New Hand")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)  // Or any color you prefer
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)
            
            // ------ Point Breakdown ------
            
//            // Hand Points
//            HStack {
//                Text(viewModel.handMessage)
//                    .font(.body)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                Spacer()
//                
//                if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand 雞糊" {
//                    Text("\(viewModel.handPoints)")
//                }
//            }
//            
//            // Flower Points
//            if viewModel.flowerPoints > 0 {
//                Divider()
//                
//                HStack {
//                    Text("Flower Points")
//                        .font(.body)
//                        .foregroundColor(.green)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Text("+\(viewModel.flowerPoints)")
//                        .font(.body)
//                        .foregroundColor(.green)
//                }
//            }
//            
//            // Dragon Points
//            if viewModel.dragonPoints > 0 {
//                Divider()
//                
//                HStack {
//                    Text("Dragon Points")
//                        .font(.body)
//                        .foregroundColor(.orange)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Text("+\(viewModel.dragonPoints)")
//                        .font(.body)
//                        .foregroundColor(.orange)
//                }
//            }
//            
//            // Wind Points
//            if viewModel.windPoints > 0 {
//                Divider()
//                
//                HStack {
//                    Text("Wind Points")
//                        .font(.body)
//                        .foregroundColor(.blue)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Text("+\(viewModel.windPoints)")
//                        .font(.body)
//                        .foregroundColor(.blue)
//                }
//            }
//            
//            // Self Drawn Points
//            if viewModel.selfDrawnPoints > 0 {
//                Divider()
//                
//                HStack {
//                    Text("Self Drawn")
//                        .font(.body)
//                        .foregroundColor(.purple)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Text("+\(viewModel.selfDrawnPoints)")
//                        .font(.body)
//                        .foregroundColor(.purple)
//                }
//            }
//            
//            // Concealed Hand Points
//            if viewModel.concealedHandPoints > 0 {
//                Divider()
//                
//                HStack {
//                    Text("Concealed Hand")
//                        .font(.body)
//                        .foregroundColor(.purple)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Text("+\(viewModel.concealedHandPoints)")
//                        .font(.body)
//                        .foregroundColor(.purple)
//                }
//            }
//            
//            // Total Points
//            if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand 雞糊" {
//                Divider()
//                
//                HStack {
//                    Text("Total points")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Spacer()
//                    
//                    Text("\(viewModel.handPoints + viewModel.windPoints + viewModel.flowerPoints + viewModel.dragonPoints + viewModel.selfDrawnPoints + viewModel.concealedHandPoints)")
//                        .font(.headline)
//                }
//            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 26)
        .padding(.vertical, 42)
    }
}
