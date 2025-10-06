//
//  ResourceData.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//

struct Resource {
    let title: String
    let description: String
    let url: String?
    let category: String
}


// MARK: - DOUBLE CHECK ALL RESOURCES!!!

struct ResourceData {
    static let nationalResources: [Resource] = [
        Resource(
            title: "U.S. Department of Veteran Affairs",
            description: "Access VA benefits, including healthcare and education resources and services",
            url: "https://www.va.gov/",
            category: "National"
        ),
        Resource(
            title: "Veterans Crisis Line",
            description: "Get immediate confidential help — Dial 988, then Press 1.",
            url: "https://www.veteranscrisisline.net/",
            category: "National"
        ),
        Resource(
            title: "Veterans Employment and Training Service (VETS)",
            description: "Employment resources and transition support.",
            url: "https://www.dol.gov/agencies/vets",
            category: "National"
        )
    ]
    
    static let missouriResources: [Resource] = [
        Resource(
            title: "Missouri Veterans Commission",
            description: "Statewide support for veterans benefits, homes, and cemeteries.",
            url: "https://mvc.dps.mo.gov/",
            category: "Missouri"
        ),
        Resource(
            title: "Missouri Veterans Benefits Guide",
            description: "Comprehensive guide to Missouri-specific veterans benefits.",
            url: "https://mvc.dps.mo.gov/docs/benefits/MissouriVeteransBenefitsGuide.pdf",
            category: "Missouri"
        ),
        Resource(
            title: "St. Louis VA Health Care System",
            description: "Healthcare and services for veterans in the St. Louis area.",
            url: "https://www.va.gov/st-louis-health-care/",
            category: "Missouri"
        )
    ]
}
