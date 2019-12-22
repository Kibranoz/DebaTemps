//
//  logic.swift
//  DebaTemps
//
//  Created by Louis Couture on 2019-11-22.
//  Copyright © 2019 lrcstudios. All rights reserved.
//

import Foundation


func formatTime(time:Int) -> String {
    let minutes:Int = time/60
    let seconds:Int = time%60
    return String(minutes) + ":" + String(seconds)
}
func prochainTour(time: inout Int)->Void{
    let tempsAvantLaFin = time % 420
    time -= tempsAvantLaFin
}

