// WordBank.swift
// Purpose: Central place to edit game content.
// - No difficulty levels.
// - Each theme has two editable arrays: `words` (true answers) and `hints` (decoy/hint words).

import Foundation

struct WordBankTheme {
    var words: [String]
    var hints: [String]
}

struct WordBank {
    // EDIT HERE: add/remove themes, change words/hints at will.
    // Keep items short (single words) for clarity on the card.
    static var themes: [String: WordBankTheme] = [
        "Animals": .init(
            words: ["Cat","Dog","Fish","Bird","Cow","Frog","Bee","Duck","Otter","Leopard","Walrus","Falcon","Buffalo","Raccoon","Cobra"],
            hints: ["Mammal","Reptile","Bird","Insect","Pet","Farm","Wild","Ocean","Forest","Tail","Claws","Wings","Fur","Scales","Herd"]
        ),
        "Food": .init(
            words: ["Pizza","Apple","Bread","Cookie","Cheese","Rice","Cake","Banana","Burrito","Omelette","Pancake","Yogurt","Taco","Burger","Salad"],
            hints: ["Fruit","Dessert","Breakfast","Dinner","Snack","Dairy","Sweet","Savory","Baked","Grilled","Fried","Sauce","Spicy","Cold","Hot"]
        ),
        "Jobs": .init(
            words: ["Teacher","Doctor","Chef","Farmer","Pilot","Nurse","Baker","Artist","Plumber","Mechanic","Architect","Librarian","Photographer","Paramedic"],
            hints: ["Hospital","School","Kitchen","Tools","Office","Uniform","Vehicle","Craft","Books","Camera","Team","Client","Manager","License","Hands-on"]
        ),
        "Places": .init(
            words: ["Beach","Forest","Desert","Island","Castle","Bridge","Airport","Museum","Harbor","Canyon","Temple","Volcano","Subway","Palace","Aquarium"],
            hints: ["Travel","Outside","City","Nature","Water","Mountain","Underground","Historic","Tourist","Crowd","Quiet","Ticket","Map","Guide","View"]
        ),
        "Random": .init(
            words: ["Robot","Diamond","Guitar","Laptop","Balloon","Mirror","Compass","Lantern","Helmet","Backpack","Telescope","Hammer","Candle","Notebook","Rocket"],
            hints: ["Shiny","Tool","Music","Light","Round","Heavy","Small","Large","Carry","Metal","Glass","Paper","Wood","Outdoor","Indoor"]
        )
    ]

    /// Return the theme object; falls back to "Random" if unknown.
    static func theme(_ name: String) -> WordBankTheme {
        if let t = themes[name] { return t }
        return themes["Random"] ?? .init(words: ["Word"], hints: ["Hint"])
    }

    /// Convenience helpers
    static func words(for name: String) -> [String] { theme(name).words }
    static func hints(for name: String) -> [String] { theme(name).hints }
}
