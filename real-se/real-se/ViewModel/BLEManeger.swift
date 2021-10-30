//
//  BLEManeger.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/29.
//

import Foundation
import CoreLocation

class BLEManeger: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var rssi = 0
    @Published var inHounse =  true
    var preInHounse = true
    var trackLocationManager : CLLocationManager!
    var beaconRegion : CLBeaconRegion!

    var rssiOverCnt: Int = 0
    var rssiUnderCnt: Int = 0

    override init() {
        super.init()
        trackLocationManager = CLLocationManager()
        trackLocationManager.delegate = self
        let uuid:UUID? = UUID(uuidString: "00000000-b53c-1001-b000-001c4d5c1dc1")

        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "real-se")

        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined) {
            trackLocationManager.requestWhenInUseAuthorization()
        }
    }

    //位置認証のステータスが変更された時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        trackLocationManager.startMonitoring(for: self.beaconRegion)
    }

    //観測の開始に成功すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        trackLocationManager.requestState(for: self.beaconRegion)
    }

    //領域内にいるかどうかを判定する
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {
        switch (state) {
        case .inside:
            trackLocationManager.startRangingBeacons(in: beaconRegion)
            break
        case .outside:
            break
        case .unknown:
            break
        }
    }

    //領域に入った時
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.trackLocationManager.startRangingBeacons(in: self.beaconRegion)
    }

    //領域から出た時
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.trackLocationManager.stopRangingBeacons(in: self.beaconRegion)
    }

    //領域内にいるので測定をする
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        /*
         beaconから取得できるデータ
         proximityUUID   :   regionの識別子
         major           :   識別子１
         minor           :   識別子２
         proximity       :   相対距離
         accuracy        :   精度
         rssi            :   電波強度
         */
        for becon in beacons {
            if becon.minor == 1100 {
                rssi = becon.rssi
                print(rssi)
                if rssi > -65 {
                    rssiOverCnt += 1
                    rssiUnderCnt = 0
                    if rssiOverCnt == 3 {
                        inHounse = true
                        Ch.shared.inHounse = true
                        Ch.shared.sePlaySound(name: "enter2")
                        Ch.shared.bgmPlaySound(name: "inHouse", rate: 0.7)
                    }
                } else {
                    rssiUnderCnt += 1
                    rssiOverCnt = 0
                    if rssiUnderCnt == 3 {
                        inHounse = false
                        Ch.shared.inHounse = false
                        Ch.shared.sePlaySound(name: "enter2")
                        Ch.shared.bgmPlaySound(name: "gamebgm", rate: 0.7)
                    }
                }
            }
        }
    }

}
