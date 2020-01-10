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
    var debatCP = CP();
    //il va falloir un bouton pause
    var body: some View {
        VStack {
            Text(String(self.round))
            Text(a)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .lineLimit(nil)
            
            Text(partie)
                .font(.subheadline)
                
            Button(action: {
                self.enCours = "Recommencer"
                //var round = 7
                let chrono = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (chrono) in
                    self.debatCP.verifierEtatDebut(round: &self.round, tempsActuel: &self.tempsMillieu, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                    if self.round <= 2{
                         self.debatCP.verifierEtatFin(round: &self.round, tempsActuel: &self.tempsFermeture, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                        
                    }
                    if self.round <= 0 {
                        chrono.invalidate()
                    }
                }

                self.a = "CP"
                }) {
                    Text(enCours)
            }
            Text(tempsString)
            HStack{
                Button(action: {
                    if self.round >= 2 {
                       self.debatCP.tourPrecdedent(time: &self.tempsMillieu, round: &self.round)
                    }
                    if self.round < 2 {
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
                    if self.round > 2 {
                        self.debatCP.prochainTour(time: &self.tempsMillieu, round: &self.round)
                    }
                    else {
                        self.debatCP.prochainTour(time: &self.tempsFermeture,round: &self.round)
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
