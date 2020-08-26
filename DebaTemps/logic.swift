//
//  logic.swift
//  DebaTemps
//
//  Created by Louis Couture on 2019-11-22.
//  Copyright © 2019 lrcstudios. All rights reserved.
//
//2 se fait deux fois.
import Foundation
import AVFoundation
import SwiftUI
class Debat{
    var clap :AVAudioPlayer?;
    func playClapSound()->Void{
        do{
            self.clap = try AVAudioPlayer(contentsOf: URL(fileURLWithPath:  Bundle.main.path(forResource: "267930__anagar__clapping.wav", ofType: nil)!));
            clap?.play()
        }
        catch {
            print("Impossible de faire jouer le son");
        }
    }
    var rollback:Bool = false;
    var ronde = 6;
     var rondeFermeture:Int{
        return 0;
    }
    
    var baseTime = Date().timeIntervalSinceReferenceDate
    var now = Date().timeIntervalSinceReferenceDate
    var timeOffset = 0;
    var tempsActuel:Int{
        var seconds = Int(self.baseTime - self.now) + (self.timeOffset)
        return (seconds)
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
    func returnRound()->Int{
        fatalError("La classe fille doit override cette méthode")
    }
    func returnRole()->String{
        fatalError("La classe fille doit override cette méthode");
    }
    func formatTime(time:Int) -> String {
        let minutes:Int = time/60
        let seconds:Int = time%60
        let secondString:String = seconds < 10 ? "0"+String(seconds) : String(seconds)
        return String(minutes) + ":" + secondString
    }
    /*
     Cette fonction prépare la classe Debat a changer de tour, ce changement pourra être fait sans problème lors du prochain appel de verifierEtatDebut() ou verifierEtatFin
     */
    func prochainTour()->Void{
        self.baseTime = Date().timeIntervalSinceReferenceDate
        self.now = Date().timeIntervalSinceReferenceDate
        self.timeOffset = 0
        self.rollback = false
            
        }
    
/*
Cette fonction prépare la classe Debat a retourner au tour précédent, ce retour pourra être fait sans problème lors du prochain appel de verifierEtatDebut() ou verifierEtatFin()
*/
    func tourPrecdedent()->Void{
            self.baseTime = Date().timeIntervalSinceReferenceDate
            self.now = Date().timeIntervalSinceReferenceDate
            self.timeOffset = 0
            self.rollback = true;
        
    }
    func verifierEtatDebut(pause:inout String, partie: inout String, tempsStr:inout String){
        
        if self.ronde > rondeFermeture {
            if self.tempsActuel != 0{
                tempsStr = String(self.formatTime(time: Int(self.tempsActuel)))
                if pause == "pause"{
                    self.now =  Date().timeIntervalSinceReferenceDate
                }
                if self.tempsActuel > self.tempsLibre{
                    partie = "1 min temps protégé"
                }
                if self.tempsActuel < self.tempsLibre && tempsActuel > self.tempsProtege {
                    partie = "5 min temps non protégé"
                }
                if self.tempsActuel < self.tempsProtege {
                    partie = "1 min temps protégé"
                }
            }
            else{
                if !self.rollback {
                    self.ronde -= 1;
                }
               else{
                    self.ronde += 1;
                    self.rollback = false;
                }
                if self.ronde == rondeFermeture{
                    self.timeOffset = tempsFermeture;
                }
                else{
                    self.timeOffset = tempsTotalMillieu
                }
                playClapSound()
                pause = "play"
        }
    }
        func returnRound()->Int{
               return self.ronde
           }
        }
    func toBeggining()->Void{
        self.baseTime = Date().timeIntervalSinceReferenceDate
        self.now = Date().timeIntervalSinceReferenceDate
    }
        func verifierEtatFin(pause:inout String, partie: inout String, tempsStr:inout String){
            //tempsActuel = tempsFermeture
            if self.ronde <= rondeFermeture + 1{
                //c'est que on a pas enlevé un a rount encore
                if self.tempsActuel != 0 {
                    tempsStr = String(self.formatTime(time: self.tempsActuel))
            if pause == "pause"{
                self.now = Date().timeIntervalSinceReferenceDate
            }
            partie = "3 min temps protégé"
                }
            else {
                if !self.rollback {
                     self.ronde -= 1;
                 }
                else{
                     self.ronde += 1;
                     self.rollback = false;
                 }
                    self.timeOffset = tempsFermeture
                    playClapSound()
                     pause = "play"
            }
              
            }
        }

}
//utiliser les init et avoir des paramètre selon le mode choisi 
class CP:Debat{
    var modePM:String
     var modeCO:String
    override init(){
        self.modePM = "6/4"
        self.modeCO = "7/3"
        super.init()
        self.timeOffset = 420;

    }
      override  var rondeFermeture:Int{
            return 2;
        }
        override var tempsTotalMillieu : Int{
            if self.ronde == 6 && self.modePM == "6/4" {
                return 360
            }
            if self.ronde == 5 && self.modeCO == "Traditionnelle"{
                return 600;
            }
            
            else{
                return 420;
            }
        };
        override var tempsProtege:Int{//60
            return 60;
        }
        
        override var tempsLibre:Int{//360
             if self.ronde == 6 && self.modePM == "6/4" {
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
            if self.ronde == 2 && self.modeCO == "Traditionnelle" {
                return 0;
            }
            else{
            return 180;
            }
    }
    func reset(){
        self.ronde = 6;
        self.baseTime = Date().timeIntervalSinceReferenceDate
        self.baseTime = Date().timeIntervalSinceReferenceDate
        if self.modePM == "6/4"{
        self.timeOffset = 360;
        }
        else {
            self.timeOffset = 420;
        }
    }
    func changerModePM(sixquatre:Bool,septtrois:Bool){
        if (sixquatre){
        self.modePM = "6/4"
        self.timeOffset = 360;
        }
        else {
            self.modePM = "7/3"
            self.timeOffset = 420;
        }
        
    }
    func changerModeCO(trad:Bool, split:Bool){
        if (trad){
        self.modeCO = "Traditionnelle"
        }
        else {
            self.modeCO = "Split"
        }
    }
    func modePm(){
        print(self.modePM)
    }
    override func returnRound()->Int{
        return self.ronde
    }
    override func returnRole() -> String {
        let role = ["","Premier(ière) ministre", "Chef(fe) de l'opposition", "Membre de l'opposition", "Membre du gouvernement","Chef(fe) de l'opposition", "Premier(ière) ministre"];
        return "\(role[returnRound()])"
    }
    func returnTempsFermeture()->Int{
        return tempsFermeture;
    }
    func returnTempsMilieu()->Int { 
        return tempsTotalMillieu;
    }
        
    //changer le temps selon le mode choisi
    
    
}
class BP:Debat{
    override init(){
        super.init()
        self.ronde = 8;
        self.timeOffset = 420;
    }
    override var tempsTotalMillieu : Int{
        return 420;
    }
    override var tempsLibre:Int{
        return 360;
    }
    
    override var tempsProtege:Int{//60
        return 60;
    }
    override var rondeFermeture:Int{
        return -1;
    }
    
    override func verifierEtatFin(pause:inout String, partie: inout String, tempsStr:inout String){
        fatalError("Erreur toutes les rondes en bp sont de 7 minutes")
    }
    override func returnRound() -> Int {
        return self.ronde
    }
    func reset(){
           self.ronde = 8;
           self.timeOffset = 420;
       }
    
    override func returnRole() -> String {
        let role = ["","Whip de l'opposition","Whip du gouvernement", "Membre de l'opposition", "Membre du gouvernement", "Chef(fe) adjoint(e) de l'opposition", "Premier(ière) ministre adjoint(e)" ,"Chef(fe) de l'opposition", "Premier(ière) ministre"];
        return "\(role[returnRound()])"
    }
}
//est ce que c'est nécéssaire d'avoir deux fois round?
