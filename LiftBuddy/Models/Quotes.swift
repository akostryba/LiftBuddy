//
//  Quotes.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/12/24.
//

import Foundation

let quotes =  [
    Quote(quote: "If when you look in the mirror you don’t see the perfect version of yourself, you better see the hardest working version of yourself.",
          source: "Chris Bumstead"),
    Quote(quote: "It's not about winning. It's not about a trophy. It's about having no quit. It's about giving everything you have so that when you show up on game day, before the results are over, you're proud of yourself and you know the work you put in.",
          source: "Chris Bumstead"),
    Quote(quote: "Our growing softness, and our increasing lack of physical fitness, is a menace to our security.",
          source: "John F. Kennedy"),
    Quote(quote: "The last three or four reps is what makes the muscle grow. This area of pain divides a champion from someone who is not a champion.",
          source: "Arnold Schwarzenegger"),
    Quote(quote: "The resistance that you fight physically in the gym and the resistance that you fight in life can only build a strong character.",
          source: "Arnold Schwarzenegger"),
    Quote(quote: "The pain you feel today will be the strength you feel tomorrow.",
          source: "Arnold Schwarzenegger"),
    Quote(quote: "Some people want it to happen, some wish it would happen, others make it happen.",
          source: "Michael Jordan"),
    Quote(quote: "I have nothing in common with lazy people who blame others for their lack of success. Great things come from hard work and perseverance. No excuses.",
          source: "Kobe Bryant"),
    Quote(quote: "You dream. You plan. You reach. There will be obstacles. There will be doubters. There will be mistakes. But with hard work, with belief, with confidence and trust in yourself and those around you, there are no limits.",
          source: "Michael Phelps"),
    Quote(quote: "Success is not about how many times you fall, but how many times you get back up.",
          source: "Novak Djokovic")]

class Quote {
    
    var quote : String
    var source : String
    
    init(quote: String, source: String) {
        self.quote = quote
        self.source = source
    }
    
}
