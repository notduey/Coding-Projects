// WordBank.swift
// Purpose: Central place to edit game content.
// - No difficulty levels.
// - Each theme has two editable arrays: `words` (true answers) and `hints` (decoy/hint words).

import Foundation

struct WordBankTheme {
    /// word -> [up to many hints you define]
    var entries: [String: [String]]
}

struct WordBank {
    // EDIT HERE: add more words and tune their hints.
    // Keep hints short; they should be clues that *fit that specific word*.
    static var themes: [String: WordBankTheme] = [
        "Animals": .init(entries: [
            "Cat":   ["Pet", "Whiskers", "Purr"],
            "Dog":   ["Pet", "Fetch", "Bark"],
            "Bee":   ["Honey", "Hive", "Sting"],
            "Fish":  ["Gills", "Swim", "Scales"],
            "Bird":  ["Feathers", "Wings", "Nest"],
            "Cow":   ["Milk", "Pasture", "Moo"],
            "Frog":  ["Amphibian", "Leap", "Pond"],
            "Otter": ["River", "Playful", "Seaweed"],
        ]),
        "Food": .init(entries: [
            "Pizza":   ["Slice", "Cheese", "Oven"],
            "Apple":   ["Fruit", "Tree", "Crisp"],
            "Bread":   ["Loaf", "Bakery", "Slice"],
            "Burrito": ["Wrap", "Rice", "Beans"],
        ]),
        "Jobs": .init(entries: [
            "Teacher": ["Classroom", "Lesson", "Homework"],
            "Doctor":  ["Clinic", "Stethoscope", "Patient"],
            "Chef":    ["Kitchen", "Knife", "Recipe"],
        ]),
        "Places": .init(entries: [
            "Beach":   ["Sand", "Waves", "Umbrella"],
            "Forest":  ["Trees", "Trail", "Wildlife"],
            "Museum":  ["Exhibit", "Gallery", "Ticket"],
        ]),
        "Random": .init(entries: [
            "Robot":   ["Metal", "Program", "Battery"],
            "Guitar":  ["Strings", "Pick", "Chord"],
            "Lantern": ["Light", "Handle", "Camping"],
        ])
    ]

    static func theme(_ name: String) -> WordBankTheme {
        themes[name] ?? themes["Random"]!
    }

    /// Pick a random (word, hints) pair from the given theme.
    static func randomEntry(for themeName: String) -> (word: String, hints: [String]) {
        let t = theme(themeName)
        guard let (word, hints) = t.entries.randomElement() else {
            return ("Word", ["Hint"])
        }
        return (word, hints)
    }
}
