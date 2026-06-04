import SwiftUI
import SwiftData

struct AddToMenuSheet: View {
    let recipe: SpoonacularRecipe
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var menuEntries: [MenuEntry]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                VStack(spacing: 0) {
                    // Recipe preview
                    HStack(spacing: 14) {
                        CachedAsyncImage(url: URL(string: recipe.image)) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            default:
                                Rectangle().fill(Color("BackgroundSecondary"))
                                    .overlay(
                                        Image(systemName: "fork.knife")
                                            .foregroundStyle(Color("TextSecondary"))
                                    )
                            }
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(recipe.title)
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundStyle(Color("TextPrimary"))
                                .lineLimit(2)
                            if let minutes = recipe.readyInMinutes, minutes > 0 {
                                Label("\(minutes) min", systemImage: "clock")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(Color("TextSecondary"))
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color("CardBackground"))
                    .overlay(Divider(), alignment: .bottom)

                    // Day picker list
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(WeekDay.allCases, id: \.rawValue) { day in
                                let alreadyAdded = menuEntries.contains {
                                    $0.recipeId == recipe.id && $0.dayOfWeek == day.rawValue
                                }
                                Button {
                                    toggleMenu(day: day)
                                } label: {
                                    HStack(spacing: 14) {
                                        Text(day.displayName)
                                            .font(.system(.body, design: .rounded, weight: .medium))
                                            .foregroundStyle(Color("TextPrimary"))

                                        Spacer()

                                        Image(systemName: alreadyAdded ? "checkmark.circle.fill" : "plus.circle")
                                            .font(.system(size: 18))
                                            .foregroundStyle(alreadyAdded
                                                             ? Color("AccentSage")
                                                             : Color("AccentSage").opacity(0.6))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(Color("CardBackground"))
                                    .overlay(
                                        Divider()
                                            .frame(maxWidth: .infinity, maxHeight: 0.5)
                                            .background(Color("BackgroundSecondary")),
                                        alignment: .bottom
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Add to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("AccentSage"))
                }
            }
        }
    }

    private func toggleMenu(day: WeekDay) {
        if let existing = menuEntries.first(where: {
            $0.recipeId == recipe.id && $0.dayOfWeek == day.rawValue
        }) {
            // Already on this day — remove it
            HapticFeedback.light()
            modelContext.delete(existing)
            try? modelContext.save()
        } else {
            // Not yet on this day — add it
            HapticFeedback.success()
            let entry = MenuEntry(recipe: recipe, day: day)
            modelContext.insert(entry)
            try? modelContext.save()
            dismiss()
        }
    }
}
