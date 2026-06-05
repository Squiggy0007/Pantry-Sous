import SwiftUI
import SwiftData
import PhotosUI
import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

private let recipeOCRCIContext = CIContext(options: [.useSoftwareRenderer: false])

private struct ParsedRecipeText: Equatable {
    var title: String
    var ingredients: [String]
    var steps: [String]
    var notes: String
    var rawLines: [String]
    var lowConfidenceLines: [String]
    var imageCount: Int
}

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
    @State private var recipeScanPhotoItems: [PhotosPickerItem] = []
    @State private var recipeScanImageData: [Data] = []
    @State private var showingRecipeCamera = false
    @State private var isRecognizingRecipeText = false
    @State private var recipeScanError: String? = nil
    @State private var recognizedRecipeDraft: ParsedRecipeText? = nil
    @State private var showingRecipeReview = false

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

                        recipeInfoSection

                        ingredientsSection

                        instructionsSection

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
                            uploadSection
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
            .alert("Could Not Read Recipe", isPresented: Binding(
                get: { recipeScanError != nil },
                set: { if !$0 { recipeScanError = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(recipeScanError ?? "")
            }
            .sheet(isPresented: $showingRecipeCamera) {
                RecipeCameraPicker { imageData in
                    if selectedImageData == nil {
                        selectedImageData = imageData
                    }
                    recipeScanImageData.append(imageData)
                    Task { await importRecipeText(from: recipeScanImageData) }
                }
            }
            .sheet(isPresented: $showingRecipeReview) {
                if let draft = Binding($recognizedRecipeDraft) {
                    RecipeOCRReviewSheet(
                        draft: draft,
                        onAddPhoto: { showingRecipeReview = false },
                        onApply: { reviewed in
                            mergeRecipeScan(reviewed)
                            recognizedRecipeDraft = nil
                            showingRecipeReview = false
                            recipeScanImageData.removeAll()
                            recipeScanPhotoItems.removeAll()
                            HapticFeedback.success()
                        }
                    )
                }
            }
            .onChange(of: recipeScanPhotoItems) { _, newItems in
                Task {
                    var loaded: [Data] = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            loaded.append(data)
                        }
                    }
                    guard !loaded.isEmpty else { return }
                    if selectedImageData == nil {
                        selectedImageData = loaded.first
                    }
                    recipeScanImageData.append(contentsOf: loaded)
                    await importRecipeText(from: recipeScanImageData)
                    recipeScanPhotoItems.removeAll()
                }
            }
        }
    }

    private var recipeScanControls: some View {
        HStack(spacing: 10) {
            Button {
                showingRecipeCamera = true
            } label: {
                scanControlLabel("Camera", icon: "camera.viewfinder")
            }
            .disabled(isRecognizingRecipeText || !UIImagePickerController.isSourceTypeAvailable(.camera))

            PhotosPicker(
                selection: $recipeScanPhotoItems,
                maxSelectionCount: 4,
                matching: .images,
                photoLibrary: .shared()
            ) {
                scanControlLabel("Photo", icon: "photo.on.rectangle.angled")
            }
            .disabled(isRecognizingRecipeText)

            if isRecognizingRecipeText {
                ProgressView()
                    .tint(Color("AccentSage"))
            }
        }
    }

    private var recipeInfoSection: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader("Recipe Info", icon: "fork.knife")
                FloatingLabelField(label: "Recipe Name", text: $title)
                cookTimeAndServingsRow
                mealCategoryPicker
                coverPhotoPicker
                privacyToggle
            }
        }
    }

    private var cookTimeAndServingsRow: some View {
        HStack(spacing: 12) {
            recipeNumberField(label: "Cook Time (min)", placeholder: "30", text: $readyInMinutes)
            recipeNumberField(label: "Servings", placeholder: "4", text: $servings)
        }
    }

    private func recipeNumberField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Color("TextSecondary"))
            TextField(placeholder, text: text)
                .keyboardType(.numberPad)
                .font(.system(.body, design: .rounded))
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
        }
    }

    private var mealCategoryPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Category")
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Color("TextSecondary"))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MealCategory.allCases.filter { $0 != .uncategorized }, id: \.self) { category in
                        mealCategoryButton(category)
                    }
                }
            }
        }
    }

    private func mealCategoryButton(_ category: MealCategory) -> some View {
        let isSelected = selectedMealCategory == category
        return Button {
            selectedMealCategory = category
        } label: {
            HStack(spacing: 4) {
                Text(category.emoji)
                    .font(.system(size: 14))
                Text(category.rawValue)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color("AccentSage") : Color("BackgroundSecondary"))
            )
            .foregroundStyle(isSelected ? .white : Color("TextSecondary"))
        }
        .buttonStyle(.plain)
    }

    private var privacyToggle: some View {
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

    private var ingredientsSection: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    sectionHeader("Ingredients", icon: "list.bullet")
                    Spacer()
                    if !filledIngredients.isEmpty {
                        matchBadge
                    }
                }

                recipeScanControls

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
    }

    private var matchBadge: some View {
        let isComplete = matchPercent == 100
        return Text("\(matchPercent)% match")
            .font(.system(.caption, design: .rounded, weight: .semibold))
            .foregroundStyle(isComplete ? Color("AccentSage") : Color("TextSecondary"))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(isComplete ? Color("AccentSage").opacity(0.12) : Color("BackgroundSecondary"))
            )
    }

    private var instructionsSection: some View {
        sectionCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader("Instructions", icon: "list.number")

                ForEach(steps.indices, id: \.self) { idx in
                    instructionRow(index: idx)
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
    }

    private func instructionRow(index: Int) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color("AccentSage"))
                    .frame(width: 26, height: 26)
                Text("\(index + 1)")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 10)

            TextField("Describe step \(index + 1)...", text: $steps[index], axis: .vertical)
                .font(.system(.body, design: .rounded))
                .lineLimit(3...)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))

            if steps.count > 1 {
                Button {
                    steps.remove(at: index)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color("TextSecondary").opacity(0.5))
                }
                .padding(.top, 8)
            }
        }
    }

    private var uploadSection: some View {
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

    private var coverPhotoPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Photo (optional)")
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Color("TextSecondary"))

            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                coverPhotoLabel
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
    }

    @ViewBuilder
    private var coverPhotoLabel: some View {
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

    private func scanControlLabel(_ text: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 11)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color("BackgroundSecondary")))
        .foregroundStyle(Color("AccentSage"))
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

    @MainActor
    private func importRecipeText(from imageDataList: [Data]) async {
        let imageDataList = imageDataList.filter { !$0.isEmpty }
        guard !imageDataList.isEmpty else {
            recipeScanError = "Choose or capture a recipe photo first."
            return
        }

        isRecognizingRecipeText = true
        defer { isRecognizingRecipeText = false }
        await Task.yield()

        do {
            var recognizedLines: [RecognizedRecipeLine] = []
            for (index, imageData) in imageDataList.enumerated() {
                guard let image = UIImage(data: imageData) else { continue }
                let pageLines = try recognizeRecipeLines(in: image, pageIndex: index)
                recognizedLines.append(contentsOf: pageLines)
            }

            let orderedLines = orderRecognizedLines(recognizedLines)
            var parsed = parseRecipeLines(orderedLines.map(\.text), imageCount: imageDataList.count)
            parsed.lowConfidenceLines = orderedLines
                .filter { $0.confidence < 0.72 }
                .map(\.text)
            parsed.ingredients = await canonicalizedIngredientLines(parsed.ingredients)

            guard !parsed.ingredients.isEmpty || !parsed.steps.isEmpty else {
                recipeScanError = "No recipe text was found. Try a clearer, well-lit photo with the card filling the frame."
                return
            }

            recognizedRecipeDraft = parsed
            showingRecipeReview = true
        } catch {
            recipeScanError = "Text recognition failed. Try a sharper photo with less shadow."
        }
    }

    private func recognizeRecipeLines(in image: UIImage, pageIndex: Int) throws -> [RecognizedRecipeLine] {
        guard let cgImage = preprocessedRecipeImage(from: image) ?? image.cgImage else { return [] }

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["en-US"]
        request.minimumTextHeight = 0.012

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        return (request.results ?? []).compactMap { observation in
            guard let candidate = observation.topCandidates(1).first else { return nil }
            let text = candidate.string
            let cleaned = cleanOCRLine(text)
            guard !cleaned.isEmpty else { return nil }
            return RecognizedRecipeLine(
                text: cleaned,
                confidence: candidate.confidence,
                boundingBox: observation.boundingBox,
                pageIndex: pageIndex
            )
        }
    }

    private func preprocessedRecipeImage(from image: UIImage) -> CGImage? {
        guard let input = CIImage(image: image) else { return image.cgImage }
        let normalized = resizedForOCR(input)
        let cropped = perspectiveCorrectedImage(from: normalized, context: recipeOCRCIContext) ?? normalized

        let controls = CIFilter.colorControls()
        controls.inputImage = cropped
        controls.saturation = 0
        controls.contrast = 1.45
        controls.brightness = 0.06

        let sharpen = CIFilter.sharpenLuminance()
        sharpen.inputImage = controls.outputImage ?? cropped
        sharpen.sharpness = 0.35

        guard let output = sharpen.outputImage else { return image.cgImage }
        return recipeOCRCIContext.createCGImage(output, from: output.extent)
    }

    private func resizedForOCR(_ image: CIImage) -> CIImage {
        let maxDimension = max(image.extent.width, image.extent.height)
        guard maxDimension > 1800 else { return image }
        let scale = 1800 / maxDimension
        return image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    }

    private func perspectiveCorrectedImage(from image: CIImage, context: CIContext) -> CIImage? {
        guard let cgImage = context.createCGImage(image, from: image.extent) else { return nil }

        let request = VNDetectRectanglesRequest()
        request.maximumObservations = 1
        request.minimumConfidence = 0.55
        request.minimumAspectRatio = 0.25
        request.quadratureTolerance = 25

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])

        guard let rectangle = request.results?.first else { return nil }
        let width = image.extent.width
        let height = image.extent.height

        func point(_ normalized: CGPoint) -> CGPoint {
            CGPoint(x: normalized.x * width, y: normalized.y * height)
        }

        let correction = CIFilter.perspectiveCorrection()
        correction.inputImage = image
        correction.topLeft = point(rectangle.topLeft)
        correction.topRight = point(rectangle.topRight)
        correction.bottomLeft = point(rectangle.bottomLeft)
        correction.bottomRight = point(rectangle.bottomRight)
        return correction.outputImage
    }

    private func orderRecognizedLines(_ lines: [RecognizedRecipeLine]) -> [RecognizedRecipeLine] {
        Dictionary(grouping: lines, by: \.pageIndex)
            .sorted { $0.key < $1.key }
            .flatMap { _, pageLines in
                let titleLines = pageLines.filter { $0.boundingBox.midY > 0.82 || $0.boundingBox.width > 0.72 }
                    .sorted(by: lineReadingOrder)
                let bodyLines = pageLines.filter { !titleLines.contains($0) }

                let hasTwoColumns =
                    bodyLines.filter { $0.boundingBox.midX < 0.48 }.count >= 4 &&
                    bodyLines.filter { $0.boundingBox.midX > 0.52 }.count >= 4

                if hasTwoColumns {
                    let left = bodyLines.filter { $0.boundingBox.midX < 0.5 }.sorted(by: lineReadingOrder)
                    let right = bodyLines.filter { $0.boundingBox.midX >= 0.5 }.sorted(by: lineReadingOrder)
                    return titleLines + left + right
                }

                return pageLines.sorted(by: lineReadingOrder)
            }
    }

    private func lineReadingOrder(_ lhs: RecognizedRecipeLine, _ rhs: RecognizedRecipeLine) -> Bool {
        if abs(lhs.boundingBox.midY - rhs.boundingBox.midY) > 0.018 {
            return lhs.boundingBox.midY > rhs.boundingBox.midY
        }
        return lhs.boundingBox.minX < rhs.boundingBox.minX
    }

    private struct RecognizedRecipeLine: Identifiable, Equatable {
        let id = UUID()
        let text: String
        let confidence: Float
        let boundingBox: CGRect
        let pageIndex: Int
    }

    private func parseRecipeLines(_ rawLines: [String], imageCount: Int) -> ParsedRecipeText {
        let lines = rawLines.map(cleanOCRLine).filter { !$0.isEmpty }
        guard !lines.isEmpty else {
            return ParsedRecipeText(title: "", ingredients: [], steps: [], notes: "", rawLines: [], lowConfidenceLines: [], imageCount: imageCount)
        }

        var ingredients: [String] = []
        var steps: [String] = []
        var notes: [String] = []
        var titleCandidates: [String] = []
        var section: RecipeOCRSection = .unknown

        for line in lines {
            if isIngredientHeader(line) {
                section = .ingredients
                continue
            }
            if isStepHeader(line) {
                section = .steps
                continue
            }
            if isNotesHeader(line) {
                section = .notes
                continue
            }
            if isRecipeSubsectionHeader(line) {
                switch section {
                case .ingredients:
                    ingredients.append(cleanRecipeField(line))
                case .steps:
                    steps.append(cleanRecipeField(line))
                default:
                    notes.append(cleanRecipeField(line))
                }
                continue
            }

            let cleaned = cleanRecipeField(line)
            guard !cleaned.isEmpty else { continue }

            switch section {
            case .ingredients:
                ingredients.append(cleaned)
            case .steps:
                steps.append(cleaned)
            case .notes:
                notes.append(cleaned)
            case .unknown:
                if isLikelyIngredientLine(cleaned) {
                    ingredients.append(cleaned)
                } else if isLikelyStepLine(cleaned) {
                    steps.append(cleaned)
                } else if titleCandidates.count < 3 && cleaned.count <= 64 {
                    titleCandidates.append(cleaned)
                } else {
                    notes.append(cleaned)
                }
            }
        }

        if steps.isEmpty {
            let nonIngredientLines = lines
                .map(cleanRecipeField)
                .filter { !$0.isEmpty && !ingredients.contains($0) && !titleCandidates.contains($0) }
            steps = mergeWrappedStepLines(nonIngredientLines.filter { isLikelyStepLine($0) || $0.count > 24 })
        } else {
            steps = mergeWrappedStepLines(steps)
        }

        let title = inferRecipeTitle(from: titleCandidates, lines: lines)
        return ParsedRecipeText(
            title: title,
            ingredients: uniqueLines(ingredients),
            steps: uniqueLines(steps),
            notes: uniqueLines(notes).joined(separator: "\n"),
            rawLines: lines,
            lowConfidenceLines: [],
            imageCount: imageCount
        )
    }

    private enum RecipeOCRSection {
        case unknown
        case ingredients
        case steps
        case notes
    }

    private func canonicalizedIngredientLines(_ lines: [String]) async -> [String] {
        guard !lines.isEmpty else { return [] }
        guard let parsed = try? await SpoonacularService.shared.parseIngredients(lines) else {
            return lines
        }

        return lines.enumerated().map { index, line in
            guard index < parsed.count else { return line }
            let spoonacularOriginal = parsed[index].original?.trimmingCharacters(in: .whitespacesAndNewlines)
            return spoonacularOriginal?.isEmpty == false ? spoonacularOriginal! : line
        }
    }

    private func cleanOCRLine(_ line: String) -> String {
        line.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: #"^[•·\-–—*]\s*"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .replacingOccurrences(of: "  ", with: " ")
    }

    private func cleanRecipeField(_ line: String) -> String {
        line.replacingOccurrences(of: #"^\d+[\.)]\s*"#, with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func isIngredientHeader(_ line: String) -> Bool {
        let lower = line.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ": "))
        return lower == "ingredients" || lower == "ingredient" || lower == "what you need"
    }

    private func isStepHeader(_ line: String) -> Bool {
        let lower = line.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ": "))
        return lower == "instructions" || lower == "directions" || lower == "method" ||
            lower == "preparation" || lower == "steps" || lower == "how to make it"
    }

    private func isNotesHeader(_ line: String) -> Bool {
        let lower = line.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ": "))
        return lower == "notes" || lower == "tips" || lower == "variation" || lower == "variations"
    }

    private func isRecipeSubsectionHeader(_ line: String) -> Bool {
        let lower = line.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ": "))
        let headings = ["for the sauce", "sauce", "filling", "topping", "for serving", "garnish", "dough", "marinade", "dressing"]
        return headings.contains(lower)
    }

    private func isLikelyIngredientLine(_ line: String) -> Bool {
        let lower = " \(line.lowercased()) "
        let units = ["cup", "cups", "tsp", "teaspoon", "teaspoons", "tbsp", "tablespoon",
                     "tablespoons", "oz", "ounce", "ounces", "lb", "lbs", "pound", "pounds",
                     "g", "gram", "grams", "kg", "ml", "l", "can", "cans", "clove", "cloves",
                     "pinch", "dash", "stick", "sticks", "package", "packet", "slice", "slices",
                     "sprig", "sprigs", "bunch", "bunches", "large", "medium", "small"]
        let startsWithAmount = line.lowercased().range(of: #"^(\d+([\/.]\d+)?|\d+\s+\d+\/\d+|[¼½¾⅓⅔⅛⅜⅝⅞])\b"#, options: .regularExpression) != nil
        return startsWithAmount || units.contains { lower.contains(" \($0) ") }
    }

    private func isLikelyStepLine(_ line: String) -> Bool {
        let lower = line.lowercased()
        let actionWords = ["preheat", "heat", "mix", "combine", "stir", "whisk", "beat", "fold", "add", "cook", "bake", "roast", "simmer", "boil", "serve", "pour", "spread", "chop", "slice", "season", "cover", "remove"]
        return actionWords.contains { lower.hasPrefix($0) || lower.contains(" \($0) ") }
    }

    private func mergeWrappedStepLines(_ lines: [String]) -> [String] {
        var merged: [String] = []
        for line in lines {
            let cleaned = cleanRecipeField(line)
            guard !cleaned.isEmpty else { continue }
            if let last = merged.last,
               !last.hasSuffix("."),
               !last.hasSuffix("!"),
               !last.hasSuffix("?"),
               !isLikelyIngredientLine(cleaned),
               cleaned.count < 70 {
                merged[merged.count - 1] = "\(last) \(cleaned)"
            } else {
                merged.append(cleaned)
            }
        }
        return merged
    }

    private func inferRecipeTitle(from candidates: [String], lines: [String]) -> String {
        if let candidate = candidates.first(where: { !$0.isEmpty && !isLikelyIngredientLine($0) && !isLikelyStepLine($0) }) {
            return candidate
        }
        return lines.first(where: { line in
            line.count <= 64 && !isIngredientHeader(line) && !isStepHeader(line) && !isLikelyIngredientLine(line)
        }) ?? ""
    }

    private func uniqueLines(_ lines: [String]) -> [String] {
        var seen = Set<String>()
        return lines.filter { line in
            let key = line.lowercased()
            guard !seen.contains(key) else { return false }
            seen.insert(key)
            return true
        }
    }

    private func mergeRecipeScan(_ parsed: ParsedRecipeText) {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           !parsed.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            title = parsed.title
        }

        if !parsed.ingredients.isEmpty {
            ingredientLines = mergeScannedFields(existing: ingredientLines, scanned: parsed.ingredients)
        }

        if !parsed.steps.isEmpty {
            steps = mergeScannedFields(existing: steps, scanned: parsed.steps)
        }

        if !parsed.notes.isEmpty {
            notes = [notes, parsed.notes]
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: "\n\n")
        }
    }

    private func mergeScannedFields(existing: [String], scanned: [String]) -> [String] {
        let filled = existing.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        return filled.isEmpty ? scanned : filled + scanned
    }

    // MARK: - Helper: extract ingredient name from a line like "2 cups chicken broth"
    private func ingredientLine_name(_ line: String) -> String {
        IngredientNormalizer.extractIngredientName(line)
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
        IngredientNormalizer.extractIngredientName(line)
    }
}

private struct RecipeOCRReviewSheet: View {
    @Binding var draft: ParsedRecipeText
    let onAddPhoto: () -> Void
    let onApply: (ParsedRecipeText) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(draft.imageCount) photo\(draft.imageCount == 1 ? "" : "s") scanned")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color("AccentSage"))
                        Text("Review OCR")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Color("TextPrimary"))
                    }

                    if !draft.lowConfidenceLines.isEmpty {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("DestructiveTerracotta"))
                                .padding(.top, 2)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Review Highlighted Lines")
                                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color("TextPrimary"))
                                Text("OCR was less confident on \(draft.lowConfidenceLines.count) line\(draft.lowConfidenceLines.count == 1 ? "" : "s"). Highlighted rows may need a quick correction.")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(Color("TextSecondary"))
                                    .lineSpacing(3)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("DestructiveTerracotta").opacity(0.12))
                        )
                    }

                    reviewCard(title: "Recipe Name", icon: "fork.knife") {
                        TextField("Recipe name", text: $draft.title)
                            .font(.system(.body, design: .rounded))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                    }

                    editableLinesSection(
                        title: "Ingredients",
                        icon: "list.bullet",
                        placeholder: "Ingredient",
                        lines: $draft.ingredients,
                        alternateActionTitle: "Move to Steps",
                        alternateActionIcon: "arrow.down.doc",
                        onAlternateAction: { line in
                            draft.steps.append(line)
                        }
                    )

                    editableLinesSection(
                        title: "Steps",
                        icon: "list.number",
                        placeholder: "Step",
                        lines: $draft.steps,
                        alternateActionTitle: "Move to Ingredients",
                        alternateActionIcon: "arrow.up.doc",
                        onAlternateAction: { line in
                            draft.ingredients.append(line)
                        }
                    )

                    reviewCard(title: "Notes", icon: "note.text") {
                        TextField("Notes", text: $draft.notes, axis: .vertical)
                            .font(.system(.body, design: .rounded))
                            .lineLimit(3...)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
                    }

                    if !draft.rawLines.isEmpty {
                        reviewCard(title: "Raw Text", icon: "text.viewfinder") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(draft.rawLines.indices, id: \.self) { index in
                                    rawLineRow(draft.rawLines[index])
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color("BackgroundPrimary").ignoresSafeArea())
            .navigationTitle("Import Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color("TextSecondary"))
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        onAddPhoto()
                    } label: {
                        Image(systemName: "plus.viewfinder")
                    }
                    .foregroundStyle(Color("AccentSage"))

                    Button("Apply") {
                        onApply(draft)
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
                }
            }
        }
    }

    @ViewBuilder
    private func reviewCard<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
            }
            content()
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color("CardBackground")))
    }

    private func editableLinesSection(
        title: String,
        icon: String,
        placeholder: String,
        lines: Binding<[String]>,
        alternateActionTitle: String,
        alternateActionIcon: String,
        onAlternateAction: @escaping (String) -> Void
    ) -> some View {
        reviewCard(title: title, icon: icon) {
            VStack(spacing: 10) {
                ForEach(lines.wrappedValue.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 8) {
                        TextField(placeholder, text: Binding(
                            get: { lines.wrappedValue[index] },
                            set: { lines.wrappedValue[index] = $0 }
                        ), axis: .vertical)
                        .font(.system(.body, design: .rounded))
                        .lineLimit(2...)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("BackgroundSecondary"))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isLowConfidence(lines.wrappedValue[index])
                                        ? Color("DestructiveTerracotta").opacity(0.75)
                                        : .clear,
                                        lineWidth: 1.5)
                        )

                        Menu {
                            Button {
                                let value = lines.wrappedValue[index]
                                lines.wrappedValue.remove(at: index)
                                onAlternateAction(value)
                            } label: {
                                Label(alternateActionTitle, systemImage: alternateActionIcon)
                            }
                            Button(role: .destructive) {
                                lines.wrappedValue.remove(at: index)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(Color("TextSecondary"))
                                .padding(.top, 8)
                        }
                    }
                }

                Button {
                    lines.wrappedValue.append("")
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add \(placeholder)")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(Color("AccentSage"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func rawLineRow(_ line: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(line)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                if isLowConfidence(line) {
                    Label("Check this line", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(.caption2, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color("DestructiveTerracotta"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                Button {
                    draft.ingredients.append(line)
                } label: {
                    Label("Add to Ingredients", systemImage: "list.bullet")
                }
                Button {
                    draft.steps.append(line)
                } label: {
                    Label("Add to Steps", systemImage: "list.number")
                }
                Button {
                    draft.notes = [draft.notes, line]
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                        .joined(separator: "\n")
                } label: {
                    Label("Add to Notes", systemImage: "note.text")
                }
            } label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(Color("AccentSage"))
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BackgroundSecondary")))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isLowConfidence(line) ? Color("DestructiveTerracotta").opacity(0.75) : .clear, lineWidth: 1.5)
        )
    }

    private func isLowConfidence(_ line: String) -> Bool {
        let normalized = normalizeConfidenceLine(line)
        return draft.lowConfidenceLines.contains { normalizeConfidenceLine($0) == normalized }
    }

    private func normalizeConfidenceLine(_ line: String) -> String {
        line.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

private struct RecipeCameraPicker: UIViewControllerRepresentable {
    let onImageData: (Data) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImageData: onImageData, dismiss: dismiss)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onImageData: (Data) -> Void
        let dismiss: DismissAction

        init(onImageData: @escaping (Data) -> Void, dismiss: DismissAction) {
            self.onImageData = onImageData
            self.dismiss = dismiss
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.92) {
                onImageData(data)
            }
            dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }
    }
}
