import SwiftUI
import SwiftData
import PhotosUI

struct CreateRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allIngredients: [Ingredient]
    @Query private var customRecipes: [CustomRecipe]

    // Basic info
    @State private var title: String = ""
    @State private var readyInMinutes: String = "30"
    @State private var servings: String = "4"
    @State private var selectedMealCategory: MealCategory = .dinner
    @State private var isPrivate: Bool = true
    @State private var notes: String = ""

    // Photo
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    // Ingredients
    @State private var ingredientLines: [String] = [""]

    // Steps
    @State private var steps: [String] = [""]

    // Upload sheet
    @State private var showingUploadConfirm = false
    @State private var showingSaveToast = false
    @State private var showingCustomRecipeLimitAlert = false

    // Validation
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !ingredientLines.filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty }).isEmpty
    }

    // Match % against current inventory
    var matchedIngredients: Int {
        let inventoryNames = allIngredients.map { $0.name }
        return ingredientLines.filter { line in
            let name = ingredientLine_name(line)
            return !name.isEmpty && IngredientNormalizer.matches(name, against: inventoryNames)
        }.count
    }

    var filledIngredients: [String] {
        ingredientLines.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var matchPercent: Int {
        guard !filledIngredients.isEmpty else { return 0 }
        return Int(Double(matchedIngredients) / Double(filledIngredients.count) * 100)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // MARK: Basic Info
                        sectionCard {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionHeader("Recipe Info", icon: "fork.knife")

                                FloatingLabelField(label: "Recipe Name", text: $title)

                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Cook Time (min)")
                                            .font(.system(.caption, design: .rounded, weight: .medium))
                                            .foregroundStyle(Color("TextSecondary"))
                                        TextField("30", text: $readyInMinutes)
                                            .keyboardType(.numberPad)
                                            .font(.system(.body, design: .rounded))
                                            .padding(12)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Servings")
                                            .font(.system(.caption, design: .rounded, weight: .medium))
                                            .foregroundStyle(Color("TextSecondary"))
                                        TextField("4", text: $servings)
                                            .keyboardType(.numberPad)
                                            .font(.system(.body, design: .rounded))
                                            .padding(12)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                                    }
                                }

                                // Meal category picker
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Category")
                                        .font(.system(.caption, design: .rounded, weight: .medium))
                                        .foregroundStyle(Color("TextSecondary"))

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(MealCategory.allCases.filter { $0 != .uncategorized }, id: \.self) { cat in
                                                Button {
                                                    selectedMealCategory = cat
                                                } label: {
                                                    HStack(spacing: 4) {
                                                        Text(cat.emoji)
                                                            .font(.system(size: 14))
                                                        Text(cat.rawValue)
                                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                                    }
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(selectedMealCategory == cat
                                                                  ? Color("AccentSage")
                                                                  : Color("BackgroundSecondary"))
                                                    )
                                                    .foregroundStyle(selectedMealCategory == cat ? .white : Color("TextSecondary"))
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                    }
                                }

                                // Photo picker
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Photo (optional)")
                                        .font(.system(.caption, design: .rounded, weight: .medium))
                                        .foregroundStyle(Color("TextSecondary"))

                                    PhotosPicker(
                                        selection: $selectedPhotoItem,
                                        matching: .images,
                                        photoLibrary: .shared()
                                    ) {
                                        if let imageData = selectedImageData,
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 140)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color("AccentSage").opacity(0.3), lineWidth: 1)
                                                )
                                        } else {
                                            HStack(spacing: 10) {
                                                Image(systemName: "photo.badge.plus")
                                                    .font(.system(size: 20))
                                                Text("Add Photo")
                                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color("BackgroundSecondary"))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                                            .foregroundStyle(Color("TextSecondary").opacity(0.3))
                                                    )
                                            )
                                            .foregroundStyle(Color("TextSecondary"))
                                        }
                                    }
                                    .onChange(of: selectedPhotoItem) { _, newItem in
                                        Task {
                                            selectedImageData = try? await newItem?.loadTransferable(type: Data.self)
                                        }
                                    }

                                    if selectedImageData != nil {
                                        Button {
                                            selectedImageData = nil
                                            selectedPhotoItem = nil
                                        } label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 12))
                                                Text("Remove photo")
                                                    .font(.system(.caption, design: .rounded))
                                            }
                                            .foregroundStyle(Color("DestructiveTerracotta"))
                                        }
                                    }
                                }

                                // Privacy toggle
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Private Recipe")
                                            .font(.system(.body, design: .rounded, weight: .medium))
                                            .foregroundStyle(Color("TextPrimary"))
                                        Text(isPrivate ? "Only on this device" : "Can be shared to Spoonacular")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(Color("TextSecondary"))
                                    }
                                    Spacer()
                                    Toggle("", isOn: $isPrivate)
                                        .tint(Color("AccentSage"))
                                }
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color("BackgroundSecondary")))
                            }
                        }

                        // MARK: Ingredients
                        sectionCard {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    sectionHeader("Ingredients", icon: "list.bullet")
                                    Spacer()
                                    // Match badge
                                    if !filledIngredients.isEmpty {
                                        Text("\(matchPercent)% match")
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                            .foregroundStyle(matchPercent == 100 ? Color("AccentSage") : Color("TextSecondary"))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(matchPercent == 100
                                                          ? Color("AccentSage").opacity(0.12)
                                                          : Color("BackgroundSecondary"))
                                            )
                                    }
                                }

                                Text("Enter each ingredient with amount, e.g. \"2 cups chicken broth\"")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(Color("TextSecondary").opacity(0.8))

                                ForEach(ingredientLines.indices, id: \.self) { idx in
                                    IngredientLineField(
                                        text: $ingredientLines[idx],
                                        inventoryNames: allIngredients.map { $0.name },
                                        onDelete: ingredientLines.count > 1 ? {
                                            ingredientLines.remove(at: idx)
                                        } : nil
                                    )
                                }

                                Button {
                                    ingredientLines.append("")
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add Ingredient")
                                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    }
                                    .foregroundStyle(Color("AccentSage"))
                                }
                            }
                        }

                        // MARK: Instructions
                        sectionCard {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionHeader("Instructions", icon: "list.number")

                                ForEach(steps.indices, id: \.self) { idx in
                                    HStack(alignment: .top, spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(Color("AccentSage"))
                                                .frame(width: 26, height: 26)
                                            Text("\(idx + 1)")
                                                .font(.system(.caption, design: .rounded, weight: .bold))
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.top, 10)

                                        TextField("Describe step \(idx + 1)…", text: $steps[idx], axis: .vertical)
                                            .font(.system(.body, design: .rounded))
                                            .lineLimit(3...)
                                            .padding(12)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))

                                        if steps.count > 1 {
                                            Button {
                                                steps.remove(at: idx)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(Color("TextSecondary").opacity(0.5))
                                            }
                                            .padding(.top, 8)
                                        }
                                    }
                                }

                                Button {
                                    steps.append("")
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add Step")
                                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    }
                                    .foregroundStyle(Color("AccentSage"))
                                }
                            }
                        }

                        // MARK: Notes
                        sectionCard {
                            VStack(alignment: .leading, spacing: 10) {
                                sectionHeader("Notes", icon: "note.text")
                                TextField("Optional notes, tips, or variations…", text: $notes, axis: .vertical)
                                    .font(.system(.body, design: .rounded))
                                    .lineLimit(3...)
                                    .padding(12)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                            }
                        }

                        // MARK: Upload to Spoonacular (when not private)
                        if !isPrivate {
                            sectionCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    sectionHeader("Share to Spoonacular", icon: "arrow.up.circle")
                                    Text("Your recipe will be uploaded publicly to Spoonacular's community database. Requires an active Spoonacular account. This option is available because \"Private\" is off.")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Color("TextSecondary"))
                                    Button {
                                        showingUploadConfirm = true
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "arrow.up.to.line.circle.fill")
                                            Text("Upload to Spoonacular")
                                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(RoundedRectangle(cornerRadius: 12).fill(Color("AccentSage").opacity(0.12)))
                                        .foregroundStyle(Color("AccentSage"))
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("AccentSage"), lineWidth: 1))
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color("TextSecondary"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveRecipe()
                    } label: {
                        Text("Save")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(isValid ? Color("AccentSage") : Color("TextSecondary"))
                    }
                    .disabled(!isValid)
                }
            }
            .alert("Upload to Spoonacular?", isPresented: $showingUploadConfirm) {
                Button("Upload", role: .none) { uploadToSpoonacular() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will submit your recipe publicly to Spoonacular. Make sure you have an active Spoonacular account.")
            }
            .alert("Custom Recipe Limit Reached", isPresented: $showingCustomRecipeLimitAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(FeatureLimits.customRecipeLimitMessage)
            }
        }
    }

    // MARK: - Save
    private func saveRecipe() {
        guard FeatureLimits.canCreateCustomRecipe(currentCount: customRecipes.count) else {
            HapticFeedback.warning()
            showingCustomRecipeLimitAlert = true
            return
        }

        let filteredIngredients = ingredientLines.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let filteredSteps = steps.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        let recipe = CustomRecipe(
            title: title.trimmingCharacters(in: .whitespaces),
            readyInMinutes: Int(readyInMinutes) ?? 30,
            servings: Int(servings) ?? 4,
            ingredients: filteredIngredients,
            steps: filteredSteps,
            mealCategory: selectedMealCategory,
            isPrivate: isPrivate,
            notes: notes,
            imageData: selectedImageData
        )
        modelContext.insert(recipe)
        try? modelContext.save()
        dismiss()
    }

    // MARK: - Upload (stub)
    private func uploadToSpoonacular() {
        // Stub: Spoonacular upload requires a paid plan + OAuth.
        // Implement when upgrading to Spoonacular Cook plan.
    }

    // MARK: - Helper: extract ingredient name from a line like "2 cups chicken broth"
    private func ingredientLine_name(_ line: String) -> String {
        let words = line.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
        // Skip leading number/unit tokens
        var start = 0
        for word in words {
            if Double(word) != nil { start += 1; continue }
            let lower = word.lowercased()
            let unitWords = ["cup","cups","tsp","tbsp","oz","lbs","g","kg","pint","quart","gallon","can","cans","jar","jars","bag","bags","box","boxes","bottle","bottles","package","packet"]
            if unitWords.contains(lower) { start += 1; continue }
            break
        }
        return words.dropFirst(start).joined(separator: " ")
    }

    // MARK: - View Builders
    @ViewBuilder
    private func sectionCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }

    @ViewBuilder
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color("AccentSage"))
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(Color("TextPrimary"))
        }
    }
}

// MARK: - Floating Label Field
struct FloatingLabelField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Color("TextSecondary"))
            TextField(label, text: $text)
                .font(.system(.body, design: .rounded))
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
        }
    }
}

// MARK: - Ingredient Line Field
/// Shows a text field with a green/red indicator for inventory match status
struct IngredientLineField: View {
    @Binding var text: String
    let inventoryNames: [String]
    let onDelete: (() -> Void)?

    var isMatched: Bool {
        let name = extractName(text)
        return !name.isEmpty && IngredientNormalizer.matches(name, against: inventoryNames)
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: text.trimmingCharacters(in: .whitespaces).isEmpty
                  ? "circle"
                  : (isMatched ? "checkmark.circle.fill" : "circle.fill"))
                .font(.system(size: 16))
                .foregroundStyle(text.trimmingCharacters(in: .whitespaces).isEmpty
                                 ? Color("TextSecondary").opacity(0.3)
                                 : (isMatched ? Color("AccentSage") : Color("DestructiveTerracotta")))

            TextField("e.g. 2 cups chicken broth", text: $text)
                .font(.system(.body, design: .rounded))
                .padding(.vertical, 10)

            if let onDelete {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color("TextSecondary").opacity(0.4))
                }
            }
        }
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BackgroundSecondary"))
        )
    }

    private func extractName(_ line: String) -> String {
        let words = line.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
        var start = 0
        for word in words {
            if Double(word) != nil { start += 1; continue }
            let lower = word.lowercased()
            let unitWords = ["cup","cups","tsp","tbsp","oz","lbs","g","kg","pint","quart","gallon","can","cans","jar","jars","bag","bags","box","boxes","bottle","bottles","package","packet"]
            if unitWords.contains(lower) { start += 1; continue }
            break
        }
        return words.dropFirst(start).joined(separator: " ")
    }
}
