//
//  logic.swift
//  DebaTemps
//
//  Created by Louis Couture on 2019-11-22.
//  Copyright © 2019 lrcstudios. All rights reserved.
//

import Foundation

class Debat{
    var tempsTotalMillieu:Int{//420
        return 0;
    };
    var tempsProtege:Int{//60
        return 0;
    }
    var tempsLibre:Int{//360
        return 0;
    }
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
    func verifierEtatDebut(round: inout Int, tempsActuel: inout Int, pause:inout String, partie: inout String, tempsStr:inout String){
        if round > 2 {
            if tempsActuel != 0{
                tempsStr = String(self.formatTime(time: tempsActuel))
                if pause == "⏸"{
                    tempsActuel -= 1
                }
                if tempsActuel > self.tempsLibre{
                    partie = "1 min temps protégé"
                }
                if tempsActuel < self.tempsLibre && tempsActuel > self.tempsProtege {
                    partie = "5 min temps non protégé"
                }
                if tempsActuel < self.tempsProtege {
                    partie = "1 min temps protégé"
                }
            }
            else{
                round -= 1
                tempsActuel = 420
        }
    }
    }
}

class CP:Debat{
    override var tempsTotalMillieu : Int{
        return 420;
    };
    override var tempsProtege:Int{//60
        return 60;
    }
    
    override var tempsLibre:Int{//360
        return 360;
    }
    
}
