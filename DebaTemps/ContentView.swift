//
//  ContentView.swift
//  DebaTemps
//
//  Created by Louis Couture on 2019-11-22.
//  Copyright © 2019 lrcstudios. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var a = "Chronometre"
    @State var partie = "Partie du débat"
    @State var tempsString = "Temps ici"
    @State var enCours = "CanadienParlementaire - Commencer"
    @State var pausePlay = "pause"
    @State var tempsMillieu = 420;
    @State var tempsFermeture = 180
    @State var round = 7;
    @State var repartitionPM = "7/3"
    var debatCP:CP!=nil
    @State private var showingAlert = false
    @State var sixQuatre = "6/4"
    //il va falloir un bouton pause
    
    init(){
        debatCP = CP(modePM: $repartitionPM)
    }
    var body: some View {
        VStack {
            Text(String(self.round))
            Text(a)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .lineLimit(nil)
            
            Text(partie)
            Button(action: {
                self.showingAlert = true
                self.debatCP.modePm()
                if self.enCours != "Recommencer"{
                let chrono = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (chrono) in
                    if self.round > 2 {
                    self.debatCP.verifierEtatDebut(round: &self.round, tempsActuel: &self.tempsMillieu, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                        self.debatCP.updateRound(round: &self.round)
                    }
                    else{
                         self.debatCP.verifierEtatFin(round: &self.round, tempsActuel: &self.tempsFermeture, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                        self.debatCP.updateRound(round: &self.round)
                        
                    }
                    if self.round <= 0 {
                        chrono.invalidate()
                        self.enCours = "Canadien Parlementaire - Commencer"
                    }
                }
                }
                else{
                    self.tempsMillieu = 420
                    self.tempsFermeture = 180
                    self.round = 7
                }
                self.enCours = "Recommencer"

                self.a = "CP"
            }, label: {
                Text(enCours)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("6/4 ou 7/3"), message: Text("6/4 pour avoir plus de temps à la fin et 7/3 pour en avoir plus au début"), primaryButton: .default(Text("6/4"), action: {
                            self.debatCP.changerModePM(newModePM: self.$sixQuatre);
                            self.tempsMillieu = 360;
                            self.tempsFermeture = 240;
                        }), secondaryButton: .default(Text("7/3"), action: {
                            self.debatCP.changerModePM(newModePM: self.$repartitionPM)
                            self.tempsMillieu = 420
                            self.tempsFermeture = 180
                        }))
                }
            })
                
            Text(tempsString)
            HStack{
                Button(action: {
                    if self.round > 2 {
                       self.debatCP.tourPrecdedent(time: &self.tempsMillieu, round: &self.round)
                    }
                    else{
                      self.debatCP.tourPrecdedent(time: &self.tempsFermeture, round: &self.round)
                    }
                    
                }, label: {
                    Image("backwards").renderingMode(.original)
                })
                Button(action: {
                    switch (self.pausePlay) {
                    case "play" :
                        self.pausePlay = "pause"
                        break
                    case "pause" :
                        self.pausePlay = "play"
                        break
                    default:
                        self.pausePlay = "Erreur"
                    }
                    
                    
                }) {
                    Image(self.pausePlay).renderingMode(.original)

                    
                }
                Button(action: {
                    self.round = self.debatCP.returnRound();
                    if self.round > 3 {
                        self.debatCP.prochainTour(time: &self.tempsMillieu, round: &self.round)
                        self.debatCP.verifierEtatDebut(round: &self.round, tempsActuel: &self.tempsMillieu, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                        //le probleme est ici ronde de 3 au lieu de 2...
                    }
                    else {
                        self.debatCP.prochainTour(time: &self.tempsFermeture,round: &self.round)
                        //self.round -= 1
                        self.debatCP.verifierEtatFin(round: &self.round, tempsActuel: &self.tempsFermeture, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                        self.debatCP.updateRound(round: &self.round)
                    }
                }, label: {
                    Image("forward").renderingMode(.original)
                } )
            }
        }

  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
