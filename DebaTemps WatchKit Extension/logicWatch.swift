//
//  logicWatch.swift
//  DebaTemps WatchKit Extension
//
//  Created by Louis Couture on 2019-12-24.
//  Copyright © 2019 lrcstudios. All rights reserved.
//

import Foundation
import Foundation

class Debat{
    var tempsTotalMillieu:Int{
        return 0;
    };
    func formatTime(time:Int) -> String {
        let minutes:Int = time/60
        let seconds:Int = time%60
        return String(minutes) + ":" + String(seconds)
    }
    func prochainTour(time: inout Int)->Void{
        let tempsAvantLaFin = time % self.tempsTotalMillieu
        time -= tempsAvantLaFin
    }
    func tourPrecdedent(time: inout Int, round: inout Int)->Void{
        if time == 0{
            round += 2
        }
        else {
            time = 0
            round += 2
            // ne marche pas complètement car on enlève quand même une round lorsqu'on le fait à cause de l'autre chronomètre...
        }
    }

}

class CP:Debat{
    override var tempsTotalMillieu : Int{
        return 420;
    };
}
