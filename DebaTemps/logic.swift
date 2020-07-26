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
        
    var ronde = 6;
     var rondeFermeture:Int{
        return 0;
    }
    var tempsActuel = 0;
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
        return String(minutes) + ":" + String(seconds)
    }
    func prochainTour()->Void{
        if self.ronde > rondeFermeture {
            let tempsAvantLaFin = self.tempsActuel % self.tempsTotalMillieu
            self.tempsActuel -= tempsAvantLaFin
        }
        if self.ronde <= rondeFermeture{
            let tempsAvantLaFin = self.tempsActuel % self.tempsFermeture
            self.tempsActuel -= tempsAvantLaFin
        }
    }
    func tourPrecdedent()->Void{
        if self.tempsActuel == 0{
            self.ronde += 2
        }
        else {
            self.tempsActuel = 0
            self.ronde += 2
            // ne marche pas complètement car on enlève quand même une round lorsqu'on le fait à cause de l'autre chronomètre...
        }
    }
    func verifierEtatDebut(pause:inout String, partie: inout String, tempsStr:inout String){
        if self.ronde > rondeFermeture {
            if self.tempsActuel != 0{
                tempsStr = String(self.formatTime(time: tempsActuel))
                if pause == "pause"{
                    self.tempsActuel -= 1
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
                //à 3 les deux runnent enc même temps
                self.ronde -= 1
                //il fallait updater round
                if self.ronde == rondeFermeture{
                    self.tempsActuel = tempsFermeture;
                }
                else{
                    self.tempsActuel = tempsTotalMillieu
                }
                playClapSound()
                pause = "play"
        }
    }
        func returnRound()->Int{
               return self.ronde
           }
        }
        func verifierEtatFin(pause:inout String, partie: inout String, tempsStr:inout String){
            //tempsActuel = tempsFermeture
            if self.ronde <= rondeFermeture + 1{
                //c'est que on a pas enlevé un a rount encore
                if self.tempsActuel != 0 {
                    tempsStr = String(self.formatTime(time: self.tempsActuel))
            if pause == "pause"{
                self.tempsActuel -= 1
            }
            partie = "3 min temps protégé"
                }
            else {
                self.ronde -= 1
                    self.tempsActuel = tempsFermeture
                    playClapSound()
                     pause = "play"
            }
              
            }
        }

}
//utiliser les init et avoir des paramètre selon le mode choisi 
class CP:Debat{
    @Binding var modePM:String
    @Binding var modeCO:String
    init(modePM:Binding <String>, modeCO:Binding<String>){
        self._modePM = modePM
        self._modeCO = modeCO
        super.init()
        self.tempsActuel = 420;

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
        if self.modePM == "6/4"{
        self.tempsActuel = 360;
        }
        else {
            self.tempsActuel = 420;
        }
    }
    func changerModePM(newModePM:Binding<String>){
        self._modePM = newModePM
        if self.modePM == "6/4"{
        self.tempsActuel = 360;
        }
        else {
            self.tempsActuel = 420;
        }
        
    }
    func changerModeCO(newModeCO:Binding<String>){
        self._modeCO = newModeCO
    }
    func modePm(){
        print(self._modePM)
    }
    override func returnRound()->Int{
        return self.ronde
    }
    override func returnRole() -> String {
        let role = ["","Premier(ière) ministre", "Chef(fe) de l'opposition", "Membre de l'opposition", "Membre du gouvernement","Chef(fe) de l'opposition", "Premier(ière) ministre"];
        return "C'est au tour du ou de la  \(role[returnRound()])"
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
        self.tempsActuel = 420;
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
           self.tempsActuel = 420;
       }
    
    override func returnRole() -> String {
        let role = ["","Whip de l'opposition","Whip du gouvernement", "Membre de l'opposition", "Membre du gouvernement", "Chef(fe) adjoint(e) de l'opposition", "Premier(ière) ministre adjoint(e)" ,"Chef(fe) de l'opposition", "Premier(ière) ministre"];
        return "C'est au tour du ou de la  \(role[returnRound()])"
    }
}
//est ce que c'est nécéssaire d'avoir deux fois round?
