//
//  WordBank.swift
//  Imposter
//
//  Created by Duy Tran on 10/13/25.
//
//Purpose: offline word list by theme and difficulty.
//

import Foundation

enum Theme: String {
    case animals, food, jobs, places, random
}

struct WordBank {
    // --- Animals ---
    static let animalsEasy   = ["Cat","Dog","Fish","Bird","Cow","Frog","Bee","Ant","Duck","Goat"]
    static let animalsMedium = ["Otter","Falcon","Leopard","Cobra","Raccoon","Walrus","Buffalo","Mule"]
    static let animalsHard   = ["Axolotl","Okapi","Tapir","Ibis","Numbat","Quokka","Cassowary"]

    // --- Food ---
    static let foodEasy   = ["Pizza","Apple","Bread","Cookie","Cheese","Rice","Cake","Banana"]
    static let foodMedium = ["Lasagna","Burrito","Omelette","Yogurt","Tortilla","Pancake","Lemonade"]
    static let foodHard   = ["Bouillabaisse","Tiramisu","Ratatouille","Gnocchi"]

    // --- Jobs ---
    static let jobsEasy   = ["Teacher","Doctor","Chef","Farmer","Pilot","Nurse","Baker","Artist"]
    static let jobsMedium = ["Plumber","Mechanic","Architect","Librarian","Photographer","Paramedic"]
    static let jobsHard   = ["Cartographer","Actuary","Cryptographer","Sommelier"]

    // --- Places ---
    static let placesEasy   = ["Beach","Forest","Desert","Island","Castle","Bridge","Airport","Museum"]
    static let placesMedium = ["Harbor","Canyon","Temple","Volcano","Subway","Palace","Aquarium"]
    static let placesHard   = ["Observatory","Cathedral","Archipelago","Peninsula"]

    // Returns a pool for a theme + difficulty.
    static func words(theme: String, difficulty: Difficulty) -> [String] {
        let t = theme.lowercased()
        switch (t, difficulty) {
        case ("animals", .easy):  return animalsEasy
        case ("animals", .medium):return animalsMedium
        case ("animals", .hard):  return animalsHard
        case ("food", .easy):     return foodEasy
        case ("food", .medium):   return foodMedium
        case ("food", .hard):     return foodHard
        case ("jobs", .easy):     return jobsEasy
        case ("jobs", .medium):   return jobsMedium
        case ("jobs", .hard):     return jobsHard
        case ("places", .easy):   return placesEasy
        case ("places", .medium): return placesMedium
        case ("places", .hard):   return placesHard
        default:
            // Random = combine several lists so there’s always something.
            return (animalsEasy + foodEasy + jobsEasy + placesEasy
                    + animalsMedium + foodMedium + jobsMedium + placesMedium)
        }
    }
}
