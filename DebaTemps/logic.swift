//
//  logic.swift
//  DebaTemps
//
//  Created by Louis Couture on 2019-11-22.
//  Copyright © 2019 lrcstudios. All rights reserved.
//
//2 se fait deux fois..
import Foundation
import SwiftUI
class Debat{
    var ronde = 7;
     var rondeFermeture:Int{
        return 0;
    }
     var tempsTotalMillieu:Int{//420
        return 0;
    };
     var tempsProtege:Int{//60
        return 0;
    }
    var tempsLibre:Int{//360
        return 0;
    }
    var tempsFermeture:Int{
        return 0
    }
    func formatTime(time:Int) -> String {
        let minutes:Int = time/60
        let seconds:Int = time%60
        return String(minutes) + ":" + String(seconds)
    }
    func prochainTour(time: inout Int, round : inout Int)->Void{
        self.ronde = round
        if self.ronde > rondeFermeture {
        let tempsAvantLaFin = time % self.tempsTotalMillieu
            time -= tempsAvantLaFin
        }
        if self.ronde <= rondeFermeture{
            let tempsAvantLaFin = time % self.tempsFermeture
            time -= tempsAvantLaFin
        }
        self.ronde = round
        
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
        self.ronde = round
    }
    func verifierEtatDebut(round: inout Int, tempsActuel: inout Int, pause:inout String, partie: inout String, tempsStr:inout String){
        if self.ronde > rondeFermeture {
            if tempsActuel != 0{
                tempsStr = String(self.formatTime(time: tempsActuel))
                if pause == "pause"{
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
                //à 3 les deux runnent enc même temps
                round -= 1
                self.ronde = round
                //il fallait updater round
                if self.ronde == 2{
                    tempsActuel = tempsFermeture;
                }
                else{
                tempsActuel = tempsTotalMillieu
                }
        }
            self.ronde = round
    }
        }
        func verifierEtatFin(round: inout Int, tempsActuel: inout Int, pause:inout String, partie: inout String, tempsStr:inout String){
            self.ronde = round
            //tempsActuel = tempsFermeture
            if self.ronde <= rondeFermeture + 1{
                //c'est que on a pas enlevé un a rount encore
            if tempsActuel != 0 {
                tempsStr = String(self.formatTime(time: tempsActuel))
            if pause == "pause"{
                tempsActuel -= 1
            }
            partie = "3 min temps protégé"
                }
            else {
              round -= 1
                self.ronde = round
                tempsActuel = tempsFermeture
            }
                
            }
            self.ronde = round
        }

}
//utiliser les init et avoir des paramètre selon le mode choisi 
class CP:Debat{
    @Binding var modePM:String
    
    init(modePM:Binding <String>){
        self._modePM = modePM
        super.init()

    }
      override  var rondeFermeture:Int{
            return 2;
        }
        override var tempsTotalMillieu : Int{
            if self.ronde == 7 && self.modePM == "6/4" {
                return 360
            }
            else{
                return 420;
            }
        };
        override var tempsProtege:Int{//60
            return 60;
        }
        
        override var tempsLibre:Int{//360
             if self.ronde == 7 && self.modePM == "6/4" {
                //run avant d'updater
                
                return 300
            }
             else {
            return 360;
            }
        }
        override var tempsFermeture: Int{
             if self.ronde == 1 && self.modePM == "6/4" {
                return 240
            }
            else{
            return 180;
            }
    }
    func changerModePM(newModePM:Binding<String>){
        self._modePM = newModePM
    }
    func modePm(){
        print(self._modePM)
    }
    func updateRound(round:inout Int){
        self.ronde = round
    }
    func returnRound()->Int{
        return self.ronde
    }
    func returnTempsFermeture()->Int{
        return tempsFermeture;
    }
    //changer le temps selon le mode choisi
    
    
}

