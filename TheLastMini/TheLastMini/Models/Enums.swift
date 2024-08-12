//
//  Enums.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 31/07/24.
//

import Foundation


enum Identifier: String{
    case recordID = "RankingTotalTimeID"
}

enum FontsCuston: String{
    case fontMediumItalick = "Kanit-MediumItalic"
    case fontBoldItalick = "Kanit-BoldItalic"
    case fontLightItalick = "Kanit-LightItalic"
}

enum FileName: String {
    case voiceCong = "voiceCong"
    case countSemaforoInit = "race_countdown2-106294-2"
    case countSemaforoFinish = "race_countdown2-106294"
    case soundCong = "soundCong"
    case idlCar = "02-0807"
    case startCar = "01-nissan_skyline_r34"
    case accelerateCar1 = "CarAudioV3"
    case accelerateCar3 = "03-nissan_skyline_r34"
    case musicaFoda = "Phonky_Frog__Day__10_de_ago_de_2024_2230"
}

enum TypeSound {
    case soundEffect, music
}

enum Lado{
    case L
    case R
}
