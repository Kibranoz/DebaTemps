//
//  ContentView.swift
//  DebaTemps
//
//  Created by Louis Couture on 2019-11-22.
//  Copyright © 2019 lrcstudios. All rights reserved.
//

import SwiftUI

enum ActiveAlert {
    case first, second
}

struct ContentView : View{
    var body : some View {
        NavigationView{
            VStack{
        NavigationLink(destination: BPView()) {
            Text("Format British Parliamentary")
                .foregroundColor(Color.blue);
        }
            NavigationLink(destination:cpView()) {
                Text("Format Canadien Parlementaire")
                .foregroundColor(Color.blue);
            }
            }}

    }
}
struct cpView: View {
    @State var mode = "Chronometre"
    @State var partie = "Partie du débat"
    @State var tempsString = "Temps ici"
    @State var enCours = "CanadienParlementaire - Commencer"
    @State var pausePlay = "pause"
    @State var tempsMillieu = 420; //on en a besoin car on veut pouvoir changer le temps actuel d'ici
    @State var tempsFermeture = 180
    @State var round = 6;
    @State var role  = ""
    @State var repartitionPM = "7/3"
    @State var repartitionCO = "Split"
    @State var traditionnelle = "Traditionnelle"
    var debatCP:CP!=nil
    @State private var showingAlert = false
    @State private var activeAlert :ActiveAlert = .first
    @State var sixQuatre = "6/4"
    @State var showContentView = false;
   @Environment(\.presentationMode) var presentationMode

    //il va falloir un bouton pause
    
    init(){
        debatCP = CP(modePM: $repartitionPM, modeCO:$repartitionCO)
    }
    var body: some View {

                VStack{
                    Text(String(self.role))
                    Text(mode)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .lineLimit(nil)
                    
                    Text(partie)
                    Button(action: {
                        self.showAlert(.first)
                        //self.debatCP.modePm()
                        if self.enCours != "Recommencer"{
                            let chrono = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (chrono) in
                            //self.round = self.debatCP.returnRound();
                            self.role = self.debatCP.returnRole()
                            if self.debatCP.returnRound() > 2{
                            self.debatCP.verifierEtatDebut(pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                            }
                            else{
                                //self.round = self.debatCP.returnRound();
                                self.role = self.debatCP.returnRole();
                                 self.debatCP.verifierEtatFin(pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                                
                            }
                                if self.debatCP.returnRound() <= 0 {
                                    self.enCours = "Canadien Parlementaire - Commencer"
                                    self.debatCP.reset();
                                    chrono.invalidate();
                                    self.presentationMode.wrappedValue.dismiss()
                                    
            
                                
                    
                            }
                            else{
                                self.enCours = "Recommencer"
                            }
                        }
                        }
                        else{
                            self.tempsMillieu = 420
                            self.tempsFermeture = 180
                            self.debatCP.reset();
                        }


                        self.mode = "CP"
                    }, label: {
                        Text(enCours)
                            .alert(isPresented: $showingAlert) {
                                switch activeAlert{
                                case .first:
                                    //self.showAlert(.second)
                                 return Alert(title: Text("6/4 ou 7/3"), message: Text("6/4 pour avoir plus de temps à la fin et 7/3 pour en avoir plus au début"), primaryButton: .default(Text("6/4"), action: {
                                    self.debatCP.changerModePM(newModePM: self.$sixQuatre);
                                    self.tempsMillieu = 360;
                                    self.tempsFermeture = self.debatCP.returnTempsFermeture();
                                    self.showAlert(.second)
                                }), secondaryButton: .default(Text("7/3"), action: {
                                    self.debatCP.changerModePM(newModePM: self.$repartitionPM)
                                    self.tempsMillieu = 420
                                    self.tempsFermeture = 180
                                    self.showAlert(.second)
                                }))
                                case .second :
                                return Alert(title: Text("Split ou traditionnel"), message: Text("Split : 7/3 Traditionnel : 10/0 "), primaryButton: .default(Text("Split"), action: {
                                    self.debatCP.changerModeCO(newModeCO: self.$repartitionCO);
                                    self.tempsMillieu = self.debatCP.returnTempsMilieu();
                                    self.tempsFermeture = self.debatCP.returnTempsFermeture();
                                }), secondaryButton: .default(Text("Traditionnelle"), action: {
                                    self.debatCP.changerModeCO(newModeCO: self.$traditionnelle)
                                    self.tempsMillieu = self.debatCP.returnTempsMilieu()
                                    self.tempsFermeture = self.debatCP.returnTempsFermeture()
                                }))
                                }
                        }})
                        
                    Text(tempsString)
                    HStack{
                        Button(action: {
                            if self.debatCP.returnRound() > 2 {
                               self.debatCP.tourPrecdedent()
                            }
                            else{
                              self.debatCP.tourPrecdedent()
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
                            if self.debatCP.returnRound() > 3 {
                                self.debatCP.prochainTour()
                                self.debatCP.verifierEtatDebut(pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                                //le probleme est ici ronde de 3 au lieu de 2...
                            }
                            else {
                                self.debatCP.prochainTour()
                                //self.round -= 1
                                self.debatCP.verifierEtatFin(pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                            }
                        }, label: {
                            Image("forward").renderingMode(.original)
                        } )
                    }
            
}
            
            
        

    
    }
    func showAlert(_ active: ActiveAlert) -> Void {
          DispatchQueue.global().async {
              self.activeAlert = active
              self.showingAlert = true
          }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct BPView :View {
    @State var mode = "Chronometre"
       @State var partie = "Partie du débat"
       @State var tempsString = "Temps ici"
       @State var enCours = "BP - Commencer"
       @State var pausePlay = "pause"
       @State var tempsMillieu = 600;
       @State var tempsFermeture = 0
       @State var round = 8;
       @State var role = ""
       var debatBP:BP!=nil
    @State var showContentView = false;
    @Environment(\.presentationMode) var presentationMode
    init(){
        debatBP = BP();
    }
    var body : some View {
        VStack{
        Text(String(self.role))
        Text(mode)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .lineLimit(nil)
        
        Text(partie)
        
            Button(action: {
                if self.enCours != "Recommencer"{
                    let chrono = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (chrono) in
                        self.round = self.debatBP.returnRound();
                        self.role = self.debatBP.returnRole();
                        self.debatBP.verifierEtatDebut(pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                        if self.debatBP.returnRound() <= 0 {
                                               self.enCours = "BP - Commencer"
                                               chrono.invalidate()
                                               self.debatBP.reset();
                                               self.presentationMode.wrappedValue.dismiss()
                                                                      }
                    }
                   
                }
                else{
                    self.tempsMillieu = 420
                    self.tempsFermeture = 0
                    self.round = self.debatBP.returnRound();
                }
                self.enCours = "Recommencer"

                self.mode = "BP"
                
            }, label: {Text(enCours)})
                
             Text(tempsString)
            HStack{
                                    Button(action: {
                                        if self.debatBP.returnRound() > 2 {
                                           self.debatBP.tourPrecdedent()
                                        }
                                        else{
                                          self.debatBP.tourPrecdedent()
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
                                        
                                            self.debatBP.prochainTour()
                                            self.debatBP.verifierEtatDebut(pause: &self.pausePlay, partie: &self.partie, tempsStr: &self.tempsString)
                                            //le probleme est ici ronde de 3 au lieu de 2...
                                        
                                    }, label: {
                                        Image("forward").renderingMode(.original)
                                    } )
                //ici
                                }
                        
            }
        }
        
    


}
