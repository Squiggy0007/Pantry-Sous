import Foundation

enum QuantityUnit: String, Codable, CaseIterable {
    // Count
    case item = "item"

    // Egg specific (individual eggs only)
    case egg = "egg"

    // Weight
    case oz = "oz"
    case lbs = "lbs"
    case g = "g"
    case kg = "kg"

    // Volume
    case tsp = "tsp"
    case tbsp = "tbsp"
    case cup = "cup"
    case flOz = "fl oz"
    case pint = "pint"
    case quart = "quart"
    case gallon = "gallon"

    // Containers
    case can = "can"
    case bag = "bag"
    case box = "box"
    case bottle = "bottle"
    case jar = "jar"
    case package = "package"
    case packet = "packet"

    var category: QuantityCategory {
        switch self {
        case .item: return .count
        case .egg: return .eggs
        case .oz, .lbs, .g, .kg: return .weight
        case .tsp, .tbsp, .cup, .flOz, .pint, .quart, .gallon: return .volume
        case .can, .bag, .box, .bottle, .jar, .package, .packet: return .container
        }
    }

    func label(for amount: Double) -> String {
        switch self {
        case .item:
            return amount == 1 ? "item" : "items"
        case .egg:
            return amount == 1 ? "egg" : "eggs"
        case .can:
            return amount == 1 ? "can" : "cans"
        case .bag:
            return amount == 1 ? "bag" : "bags"
        case .box:
            return amount == 1 ? "box" : "boxes"
        case .bottle:
            return amount == 1 ? "bottle" : "bottles"
        case .jar:
            return amount == 1 ? "jar" : "jars"
        case .package:
            return amount == 1 ? "package" : "packages"
        case .packet:
            return amount == 1 ? "packet" : "packets"
        default:
            return self.rawValue
        }
    }

    // Returns true if this unit is egg-specific
    var isEggUnit: Bool {
        return self == .egg
    }
}

enum QuantityCategory: String, CaseIterable {
    case count = "Count"
    case eggs = "Eggs"
    case weight = "Weight"
    case volume = "Volume"
    case container = "Container"

    var units: [QuantityUnit] {
        switch self {
        case .count: return [.item]
        case .eggs: return [.egg]
        case .weight: return [.oz, .lbs]
        case .volume: return [.tsp, .tbsp, .cup, .flOz, .pint, .quart, .gallon]
        case .container: return [.packet]
        }
    }

    var icon: String {
        switch self {
        case .count: return "number"
        case .eggs: return "circle.grid.3x3"
        case .weight: return "scalemass"
        case .volume: return "drop"
        case .container: return "shippingbox"
        }
    }
}

struct IngredientQuantity: Codable {
    var amount: Double
    var unit: QuantityUnit

    var displayString: String {
        let formattedAmount: String
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            formattedAmount = String(Int(amount))
        } else {
            // Show 2 decimal places so 3.25 shows as "3.25", not "3.2"
            formattedAmount = String(format: "%.2f", amount)
        }
        return "\(formattedAmount) \(unit.label(for: amount))"
    }

    static var defaultQuantity: IngredientQuantity {
        IngredientQuantity(amount: 1, unit: .item)
    }

    // Returns egg-appropriate default quantity (individual eggs)
    static var defaultEggQuantity: IngredientQuantity {
        IngredientQuantity(amount: 1, unit: .egg)
    }
}

// Determines if an ingredient name is egg-related
func isEggIngredient(_ name: String) -> Bool {
    let lower = name.lowercased()
    return lower.contains("egg")
}
