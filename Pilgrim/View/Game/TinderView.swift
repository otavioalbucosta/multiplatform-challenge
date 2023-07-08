//
//  TinderView.swift
//  Pilgrim
//
//  Created by Luiz Sena on 14/06/23.
//

import SwiftUI
import Kingfisher

struct TinderView: View {

    @StateObject var viewmodel = TinderViewmodel()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    SemiCircle()
                        .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.20)
                        .foregroundColor(.red)
                        .opacity(0.7)
                        .offset(CGSize(width: -10, height: 0))
                        .overlay {
                            Image(systemName: "xmark")
                                .font(.system(size: geo.size.width * 0.055))
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                    Spacer()
                    SemiCircle()
                        .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.20)
                        .foregroundColor(.green)
                        .rotationEffect(.degrees(180))
                        .opacity(0.7)
                        .offset(CGSize(width: 10, height: 0))
                        .overlay {
                            Image(systemName: "checkmark")
                                .font(.system(size: geo.size.width * 0.055))
                                .foregroundColor(.white)
                                .padding(.leading)
                        }
                }
                .padding(.top, 120)
                ForEach(viewmodel.cardsQueue.reversed(), id: \.self) { element in
                    CardView(
                        localName: element.local,
                        localEstado: element.state.rawValue,
                        url: URL(string: element.imageURL ?? "https://images.hdqwalls.com/download/kerry-park-seattle-united-states-5k-gu-1080x1920.jpg")
                        , frame: CGSize(width: geo.size.width * 0.60, height: geo.size.height * 0.60)) {
                        viewmodel.popCard(.right)
                    } wrongChoice: {
                        viewmodel.popCard(.left)
                    }

                }.padding(.top, 120)

                VStack {
                    Spacer()
                    HStack {
                        Text("Score: \(viewmodel.score)")
                            .font(.system(size: geo.size.width * 0.045, weight: .medium, design: .default))
                            .padding(.bottom, 20)
                    }
                }

                VStack {

                    // MARK: Vidas
                    if !viewmodel.isGameOver {
                        HStack(spacing: 15) {
                            ForEach(0...viewmodel.numberOfLifesRemains-1, id: \.self) { life in
                                Image("seloCoracao")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.top, 50)
                            }
                            Spacer()
                        }
                        .padding(.leading, 45)
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.thinMaterial)
                            .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.07)
                            .overlay {
                                Text(viewmodel.cardsQueue.first?.state.rawValue ?? "Você viu todos os cards")
                                    .font(.system(size: geo.size.width * 0.045, weight: .medium, design: .default))
                            }
                            .padding(.top, 18)
                        Spacer()
                    }

                    // MARK: Tela de Game Over
                    if viewmodel.isGameOver {
                        ZStack {
                            Rectangle()
                                .fill(.thinMaterial)
                                .ignoresSafeArea()
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 300, height: 450)
                                .foregroundColor(Color(red: 179/255, green: 190/255, blue: 217/255))
                                .overlay {
                                    VStack(spacing: 15) {

                                        HStack {
                                            Spacer()
                                            Text("Você perdeu!")
                                                .foregroundColor(Color(red: 27/255, green: 42/255, blue: 108/255))
                                                .font(.system(size: 20, weight: .bold))
                                            Spacer()
                                        }
                                        HStack {
                                            Spacer()
                                            Text("Você ainda não conquistou todos os pontos turisticos")
                                                .foregroundColor(Color(red: 27/255, green: 42/255, blue: 108/255))
                                                .font(.system(size: 20))
                                            Spacer()
                                        }
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(
                                                    .white.shadow(.inner(color: .black.opacity(0.3), radius: 3,x: 1, y: 1))
                                                )

                                            VStack(alignment: .leading, spacing: 15) {
                                                Text("Total de acertos na partida: \(viewmodel.score, specifier: "%d")")
                                                    .foregroundColor(Color(red: 27/255, green: 42/255, blue: 108/255))
                                                    .fontWeight(.semibold)

                                                Text("Melhor pontuação: \(viewmodel.highScore, specifier: "%d")")
                                                    .foregroundColor(Color(red: 27/255, green: 42/255, blue: 108/255))
                                                    .fontWeight(.semibold)

                                            }
                                        }
                                        .frame(width: 280, height: 100)
                                        .offset(x: -5)



                                        .padding(.leading, 10)

                                        Button("Jogar Novamente") {
                                            withAnimation {
                                                viewmodel.resetGame()
                                            }
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color(red: 81/255, green: 104/255, blue: 160/255))
                                        .fontWeight(.bold)

                                        Spacer()
                                    }
                                    .padding(.top, 29)
                                }

                            VStack {
                                Spacer()
                                Image("Pilgrim")
                                    .resizable()
                                    .frame(width: 200, height: 250)
                                    .animation(.linear(duration: 3), value: 10)
                                    .padding(.top, 25)

                            }
                        }

                    }
                }
            }
            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
            .background {
                KFImage(URL(string: viewmodel.cardsQueue.first?.imageURL ?? "https://images.hdqwalls.com/download/kerry-park-seattle-united-states-5k-gu-1080x1920.jpg"))
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        Rectangle().fill(.ultraThinMaterial)
                    }
                    .ignoresSafeArea()
            }

        }
    }
}

struct TinderView_Previews: PreviewProvider {
    static var previews: some View {
        TinderView()
    }
}
