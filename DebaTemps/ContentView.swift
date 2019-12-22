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
    //il va falloir un bouton pause
    var body: some View {
        VStack {
            Text(a)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
                .lineLimit(nil)
            
            Text(partie)
                .font(.subheadline)
                
            Button(action: {
                self.enCours = "Recommencer"
                //var round = 7
                let chronoMillieu = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (chronoMilieu) in
                    if self.round > 2 {
                    if self.tempsMillieu != 0{
                        self.tempsString = String(formatTime(time: self.tempsMillieu))
                        if self.pausePlay == "⏸"{
                            self.tempsMillieu -= 1
                        }
                        if self.tempsMillieu > 360{
                            self.partie = "1 min temps protégé"
                        }
                        if self.tempsMillieu < 360 && self.tempsMillieu > 60 {
                            self.partie = "5 min temps non protégé"
                        }
                        if self.tempsMillieu < 60 {
                            self.partie = "1 min temps protégé"
                        }
                    }
                    else{
                        //chronoMilieu.invalidate()
                        self.round -= 1
                        self.tempsMillieu = 420
                        
                        //self.partie = "Fin"
                    }
                }
                    else{
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
                    if self.tempsMillieu == 0{
                        self.round += 1
                    }
                    else {
                        self.tempsMillieu = 0
                        // ne marche pas complètement car on enlève quand même une round lorsqu'on le fait à cause de l'autre chronomètre...
                    }
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
                    prochainTour(time: &self.tempsMillieu)
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
