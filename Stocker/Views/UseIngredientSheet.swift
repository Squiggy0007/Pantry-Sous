import SwiftUI
import SwiftData

// MARK: - UseUnit

enum UseUnit: String, CaseIterable {
    case oz    = "oz"
    case lbs   = "lb"
    case cup   = "cup"
    case flOz  = "fl oz"
    case tbsp  = "tbsp"
    case tsp   = "tsp"

    var quantityUnit: QuantityUnit {
        switch self {
        case .oz:   return .oz
        case .lbs:  return .lbs
        case .cup:  return .cup
        case .flOz: return .flOz
        case .tbsp: return .tbsp
        case .tsp:  return .tsp
        }
    }
}

// MARK: - FractionChoice

enum FractionChoice: CaseIterable {
    case none, quarter, third, half, twoThirds, threeQuarters

    var value: Double {
        switch self {
        case .none:          return 0
        case .quarter:       return 0.25
        case .third:         return 1.0 / 3.0
        case .half:          return 0.5
        case .twoThirds:     return 2.0 / 3.0
        case .threeQuarters: return 0.75
        }
    }

    var display: String {
        switch self {
        case .none:          return "—"
        case .quarter:       return "¼"
        case .third:         return "⅓"
        case .half:          return "½"
        case .twoThirds:     return "⅔"
        case .threeQuarters: return "¾"
        }
    }
}

// MARK: - UseIngredientSheet

struct UseIngredientSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let ingredient: Ingredient
    var isAddMode: Bool = false

    @State private var wholeAmount: Int = 0
    @State private var selectedFraction: FractionChoice = .none
    @State private var selectedUnit: UseUnit = .oz

    // MARK: - Init

    init(ingredient: Ingredient, isAddMode: Bool = false) {
        self.ingredient = ingredient
        self.isAddMode = isAddMode
        let defaultUnit = UseIngredientSheet.defaultUnit(for: ingredient)
        _selectedUnit = State(initialValue: defaultUnit)
    }

    private static func defaultUnit(for ingredient: Ingredient) -> UseUnit {
        if ingredient.containerSize > 0, !ingredient.containerSizeUnit.isEmpty,
           let csUnit = QuantityUnit(rawValue: ingredient.containerSizeUnit) {
            return UseUnit.allCases.first { $0.quantityUnit == csUnit } ?? .oz
        }
        if let storedUnit = QuantityUnit(rawValue: ingredient.quantityUnit) {
            if let match = UseUnit.allCases.first(where: { $0.quantityUnit == storedUnit }) {
                return match
            }
        }
        return .oz
    }

    // MARK: - Computed

    private var totalAmount: Double {
        Double(wholeAmount) + selectedFraction.value
    }

    private var isValid: Bool { totalAmount > 0 }

    private var amountDisplay: String {
        if wholeAmount == 0 && selectedFraction == .none { return "0" }
        if wholeAmount > 0 && selectedFraction != .none {
            return "\(wholeAmount)\(selectedFraction.display)"
        }
        if selectedFraction != .none { return selectedFraction.display }
        return "\(wholeAmount)"
    }

    private var maxAllowed: Double {
        if ingredient.containerSize > 0 {
            return ingredient.quantityAmount * ingredient.containerSize
        }
        return ingredient.quantityAmount
    }

    private var accentColor: Color {
        isAddMode ? Color("AccentSage") : Color("AccentSage")
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // Drag handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color("TextSecondary").opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 16)

            // Title
            Text(isAddMode ? "How much to add?" : "How much did you use?")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(Color("TextPrimary"))
                .padding(.bottom, 6)

            // Ingredient chip
            HStack(spacing: 6) {
                Text(ingredient.category.emoji)
                    .font(.system(size: 16))
                Text(ingredient.name)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextSecondary"))
            }
            .padding(.bottom, 10)

            // In-stock pill
            HStack(spacing: 8) {
                Image(systemName: "archivebox.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("AccentSage"))
                Text("In stock: \(ingredient.displayQuantity)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color("BackgroundSecondary")))
            .padding(.bottom, 24)

            // ── Amount display ──
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(amountDisplay)
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(isValid ? Color("TextPrimary") : Color("TextSecondary").opacity(0.4))
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.2), value: amountDisplay)

                Text(selectedUnit.rawValue)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    .foregroundStyle(Color("AccentSage"))
                    .animation(.spring(response: 0.2), value: selectedUnit.rawValue)
            }
            .padding(.bottom, 16)

            // ── Whole number stepper ──
            HStack(spacing: 28) {
                Button {
                    HapticFeedback.light()
                    if wholeAmount > 0 { withAnimation(.spring(response: 0.2)) { wholeAmount -= 1 } }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(wholeAmount > 0 ? Color("AccentSage") : Color("TextSecondary").opacity(0.3))
                }
                .buttonStyle(.plain)

                Text("\(wholeAmount)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("TextPrimary"))
                    .frame(minWidth: 52)
                    .multilineTextAlignment(.center)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.2), value: wholeAmount)

                Button {
                    HapticFeedback.light()
                    withAnimation(.spring(response: 0.2)) { wholeAmount += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Color("AccentSage"))
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 14)

            // ── Fraction pills ──
            HStack(spacing: 8) {
                ForEach(FractionChoice.allCases, id: \.display) { fraction in
                    let isSelected = selectedFraction == fraction
                    Button {
                        HapticFeedback.light()
                        withAnimation(.spring(response: 0.25)) { selectedFraction = fraction }
                    } label: {
                        Text(fraction.display)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .frame(width: 44, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isSelected ? Color("AccentSage") : Color("CardBackground"))
                            )
                            .foregroundStyle(isSelected ? .white : Color("TextSecondary"))
                            .scaleEffect(isSelected ? 1.05 : 1.0)
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(response: 0.25), value: isSelected)
                }
            }
            .padding(.bottom, 20)

            // ── Unit wheel picker ──
            Picker("Unit", selection: $selectedUnit) {
                ForEach(UseUnit.allCases, id: \.self) { unit in
                    Text(unit.rawValue)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .tag(unit)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
            .clipped()
            .onChange(of: selectedUnit) { _, _ in HapticFeedback.light() }
            .padding(.bottom, 16)

            // ── Action button ──
            Button {
                isAddMode ? addMore() : logUse()
            } label: {
                Text(isAddMode ? "Add to Ingredients" : "Log Use")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isValid ? Color("AccentSage") : Color("BackgroundSecondary"))
                    )
                    .foregroundStyle(isValid ? .white : Color("TextSecondary"))
            }
            .disabled(!isValid)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color("BackgroundPrimary").ignoresSafeArea())
    }

    // MARK: - Add More

    private func addMore() {
        guard totalAmount > 0 else { return }

        let storageUnit = QuantityUnit(rawValue: ingredient.quantityUnit) ?? .item

        if ingredient.containerSize > 0 {
            // Container-tracked: convert to container units and add whole containers
            let csUnit = QuantityUnit(rawValue: ingredient.containerSizeUnit) ?? .oz
            let converted = UnitConversionHelper.convertBetweenUnits(
                amount: totalAmount,
                from: selectedUnit.quantityUnit,
                to: csUnit,
                ingredientHint: ingredient.name
            )
            let addedInContainerUnits = converted > 0 ? converted : totalAmount
            // Round to nearest container
            let containers = (addedInContainerUnits / ingredient.containerSize).rounded()
            if containers > 0 { ingredient.quantityAmount += containers }
        } else {
            // Bulk: convert user's unit → ingredient's storage unit
            let converted = UnitConversionHelper.convertBetweenUnits(
                amount: totalAmount,
                from: selectedUnit.quantityUnit,
                to: storageUnit,
                ingredientHint: ingredient.name
            )
            ingredient.quantityAmount += converted > 0 ? converted : totalAmount
        }

        try? modelContext.save()
        HapticFeedback.success()
        dismiss()
    }

    // MARK: - Log Use

    private func logUse() {
        guard totalAmount > 0 else { return }

        if ingredient.containerSize > 0 {
            let csUnit = QuantityUnit(rawValue: ingredient.containerSizeUnit) ?? .oz
            let converted = UnitConversionHelper.convertBetweenUnits(
                amount: totalAmount,
                from: selectedUnit.quantityUnit,
                to: csUnit,
                ingredientHint: ingredient.name
            )
            let usedInContainerUnits = converted > 0 ? converted : totalAmount
            let capped = min(usedInContainerUnits, maxAllowed)
            applyContainerSplit(capped)
        } else {
            let storageUnit = QuantityUnit(rawValue: ingredient.quantityUnit) ?? .item
            let converted = UnitConversionHelper.convertBetweenUnits(
                amount: totalAmount,
                from: selectedUnit.quantityUnit,
                to: storageUnit,
                ingredientHint: ingredient.name
            )
            let usedInStorageUnits = converted > 0 ? converted : totalAmount
            let capped = min(usedInStorageUnits, maxAllowed)
            applyBulkDeduction(capped)
        }

        try? modelContext.save()
        HapticFeedback.success()
        dismiss()
    }

    // MARK: - Split Algorithm

    private func applyContainerSplit(_ used: Double) {
        let sz = ingredient.containerSize
        let fullRemoved = Int(used / sz)
        let remainder = used.truncatingRemainder(dividingBy: sz)

        if remainder > 0.001 {
            ingredient.quantityAmount -= Double(fullRemoved + 1)
            let partial = Ingredient(
                name: ingredient.name,
                quantityAmount: 1,
                quantityUnit: QuantityUnit(rawValue: ingredient.quantityUnit) ?? .can,
                category: ingredient.category,
                barcode: ingredient.barcode,
                containerSize: sz - remainder,
                containerSizeUnit: QuantityUnit(rawValue: ingredient.containerSizeUnit)
            )
            modelContext.insert(partial)
        } else {
            ingredient.quantityAmount -= Double(fullRemoved)
        }

        if ingredient.quantityAmount <= 0 {
            modelContext.delete(ingredient)
        }
    }

    private func applyBulkDeduction(_ used: Double) {
        ingredient.quantityAmount -= used
        if ingredient.quantityAmount <= 0.001 {
            modelContext.delete(ingredient)
        }
    }
}
