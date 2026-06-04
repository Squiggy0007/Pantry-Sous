import SwiftUI

struct RecipeCardView: View {
    let recipe: SpoonacularRecipe
    let totalIngredients: Int
    var onAddToMenu: (() -> Void)? = nil

    var matchPercentage: Int {
        guard totalIngredients > 0 else { return 0 }
        return Int((Double(recipe.usedIngredientCount) / Double(totalIngredients)) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            CachedAsyncImage(url: URL(string: recipe.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Rectangle()
                        .fill(Color("BackgroundSecondary"))
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 28))
                                .foregroundStyle(Color("TextSecondary"))
                        )
                case .empty:
                    Rectangle()
                        .fill(Color("BackgroundSecondary"))
                        .overlay(ProgressView())
                }
            }
            .frame(height: 160)
            .clipped()
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 16,
                topTrailingRadius: 16
            ))

            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(2)

                HStack(spacing: 8) {
                    if let minutes = recipe.readyInMinutes, minutes > 0 {
                        Label("\(minutes) min", systemImage: "clock")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Color("TextSecondary"))
                    }

                    Spacer()

                    // Spoonacular score badge
                    if let score = recipe.spoonacularScore, score > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text("\(Int(score))")
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("AccentSage").opacity(0.15))
                        )
                        .foregroundStyle(Color("AccentSage"))
                    }
                }

                // Bottom row: match pill + Add to Menu
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11))
                        Text("100% match")
                            .font(.system(.caption2, design: .rounded, weight: .semibold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("AccentSage"))
                    )
                    .foregroundStyle(.white)

                    Spacer()

                    if let onAddToMenu {
                        Button {
                            HapticFeedback.light()
                            onAddToMenu()
                        } label: {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color("AccentSage"))
                                .padding(6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("AccentSage").opacity(0.12))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
}
