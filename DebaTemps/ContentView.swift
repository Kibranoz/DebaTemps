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
    @State var pausePlay = "⏸"
    @State var tempsMillieu = 420;
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
                let chronoMillieu = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (chronoMilieu) in
                    self.debatCP.verifierEtatDebut(round: &self.round, tempsActuel: &self.tempsMillieu, pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                    if self.round<=2{
                        chronoMilieu.invalidate()
                        self.partie = "Fin"
                    }
                    
                }
                self.a = "CP"
                }) {
                    Text(enCours)
            }
            Text(tempsString)
            HStack{
                Button(action: {
                    self.debatCP.tourPrecdedent(time: &self.tempsMillieu, round: &self.round)
                }, label: {
                    Text("⏪")
                })
                Button(action: {
                    switch (self.pausePlay) {
                    case "▶️" :
                        self.pausePlay = "⏸"
                        break
                    case "⏸" :
                        self.pausePlay = "▶️"
                        break
                    default:
                        self.pausePlay = "Erreur"
                    }
                    
                    
                }) {
                    Text(pausePlay)
                        .lineLimit(nil)
                    
                }
                Button(action: {
                    self.debatCP.prochainTour(time: &self.tempsMillieu)
                }, label: {
                    Text("⏩")
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
