//
//  Mandolin.swift
//  Spritely
//
//  Created by Simon Gladman on 08/03/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import Foundation
import AudioKit

class MarimbaInstrument: AKInstrument
{
    override init()
    {
        super.init()
        
        let note = BarNote()
        addNoteProperty(note.frequency)
        addNoteProperty(note.amplitude)
        
        let instrument = AKMarimba()
        
        instrument.stickHardness = 0.0025.ak
        instrument.doubleStrikePercentage = 100.ak
        instrument.tripleStrikePercentage = 100.ak
        instrument.vibratoAmplitude = 5.ak
        instrument.vibratoFrequency = 2.ak
        instrument.frequency = note.frequency
        instrument.amplitude = note.amplitude
        
        setAudioOutput(instrument)
    }
}

class VibesInstrument: AKInstrument
{
    override init()
    {
        super.init()
        
        let note = BarNote()
        addNoteProperty(note.frequency)
        addNoteProperty(note.amplitude)
        
        let instrument = AKVibes()
  

      
        instrument.frequency = note.frequency
        instrument.amplitude = note.amplitude
        
        setAudioOutput(instrument)
    }
}

class MandolinInstrument: AKInstrument
{
    override init()
    {
        super.init()
        
        let note = BarNote()
        addNoteProperty(note.frequency)
        addNoteProperty(note.amplitude)
        
        let instrument = AKMandolin()
        
        instrument.bodySize = 0.8.ak
        instrument.loopGain = 0.994.ak
        instrument.frequency = note.frequency
        instrument.amplitude = note.amplitude
        
        setAudioOutput(instrument)
    }
}

class BarNote: AKNote
{
    var frequency = AKNoteProperty(value: 0,    minimum: 0, maximum: 1000)
    var amplitude = AKNoteProperty(value: 0.04, minimum: 0, maximum: 0.25)
    
    override init() {
        super.init()
        addProperty(frequency)
        addProperty(amplitude)
    }
    
    convenience init(frequency: Float, amplitude: Float) {
        self.init()
        self.frequency.setValue(frequency, afterDelay: 0)
        self.amplitude.setValue(amplitude, afterDelay: 0)
    }
}

enum Instruments: String
{
    case vibes = "Vibes"
    case marimba = "Marimba"
    case mandolin = "Mandolin"
}
