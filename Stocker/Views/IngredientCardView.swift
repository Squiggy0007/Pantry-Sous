import SwiftUI

struct IngredientCardView: View {
    let ingredient: Ingredient
    var onEdit: (() -> Void)? = nil
    var onAddToList: (() -> Void)? = nil
    var onUse: (() -> Void)? = nil
    var onAdd: (() -> Void)? = nil
    var onInfo: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 14) {
            // Category emoji circle
            ZStack {
                Circle()
                    .fill(Color("AccentSage").opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(ingredient.category.emoji)
                    .font(.system(size: 20))
            }
            .frame(width: 44, height: 44)

            // Name and quantity
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                Text(ingredient.displayQuantity)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
            }

            Spacer()

            // Nutrition info button — only shown when data is available
            if ingredient.hasNutritionData {
                Button {
                    HapticFeedback.light()
                    onInfo?()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: 18))
                        .foregroundStyle(Color("AccentSage").opacity(0.75))
                }
                .buttonStyle(.plain)
            }

            // Add to shopping list button
            Button {
                HapticFeedback.light()
                onAddToList?()
            } label: {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("TextSecondary").opacity(0.5))
            }
            .buttonStyle(.plain)

            // Edit button
            Button {
                onEdit?()
            } label: {
                Image(systemName: "pencil.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(Color("AccentSage").opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .contextMenu {
            Button {
                HapticFeedback.medium()
                onUse?()
            } label: {
                Label("Log Use", systemImage: "minus.circle")
            }
            Button {
                HapticFeedback.medium()
                onAdd?()
            } label: {
                Label("Add More", systemImage: "plus.circle")
            }
        }
    }
}
