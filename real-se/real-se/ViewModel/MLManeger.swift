//
//  MLManeger.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/28.
//

import Foundation
import CoreMotion
import CoreML
import Combine

class MLManeger: ObservableObject{

    @Published var classLabel = ""
    let motionManager = CMMotionManager()
    static let configuration = MLModelConfiguration()
    let model = try! activity_cml_hand2(configuration: configuration)

    let inputDataLength = 50
    var predictionCount = 0

    var attitudeX = [Double]()
    var attitudeY = [Double]()
    var attitudeZ = [Double]()
    var gyroX = [Double]()
    var gyroY = [Double]()
    var gyroZ = [Double]()
    var gravityX = [Double]()
    var gravityY = [Double]()
    var gravityZ = [Double]()
    var accX = [Double]()
    var accY = [Double]()
    var accZ = [Double]()
    var currentState = try! MLMultiArray(shape: [NSNumber(value: 400)], dataType: MLMultiArrayDataType.double)
    
    // BGM用
    var stopCnt: Int = 0
    var preLabel: String = ""

    init() {
        startSensorUpdates(intervalSeconds: 0.02) // 50Hz
    }

    func startSensorUpdates(intervalSeconds:Double) {
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = intervalSeconds

            // start sensor updates
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                self.getMotionData(deviceMotion: motion!)

            })
        }
    }

    func stopSensorUpdates() {
        if motionManager.isDeviceMotionAvailable{
            motionManager.stopDeviceMotionUpdates()
        }
    }

    func getMotionData(deviceMotion:CMDeviceMotion) {
//        print("attitudeX:", deviceMotion.attitude.pitch)
//        print("attitudeY:", deviceMotion.attitude.roll)
//        print("attitudeZ:", deviceMotion.attitude.yaw)
//        print("gyroX:", deviceMotion.rotationRate.x)
//        print("gyroY:", deviceMotion.rotationRate.y)
//        print("gyroZ:", deviceMotion.rotationRate.z)
//        print("gravityX:", deviceMotion.gravity.x)
//        print("gravityY:", deviceMotion.gravity.y)
//        print("gravityZ:", deviceMotion.gravity.z)
//        print("accX:", deviceMotion.userAcceleration.x)
//        print("accY:", deviceMotion.userAcceleration.y)
//        print("accZ:", deviceMotion.userAcceleration.z)

        attitudeX.append(deviceMotion.attitude.pitch)
        attitudeY.append(deviceMotion.attitude.roll)
        attitudeZ.append(deviceMotion.attitude.yaw)
        gyroX.append(deviceMotion.rotationRate.x)
        gyroY.append(deviceMotion.rotationRate.y)
        gyroZ.append(deviceMotion.rotationRate.z)
        gravityX.append(deviceMotion.gravity.x)
        gravityY.append(deviceMotion.gravity.y)
        gravityZ.append(deviceMotion.gravity.z)
        accX.append(deviceMotion.userAcceleration.x)
        accY.append(deviceMotion.userAcceleration.y)
        accZ.append(deviceMotion.userAcceleration.z)

        // add data for input CoreML
        if accX.count >= inputDataLength {
            getCoremlOutput()
            resetAll()
        }
    }

    func resetAll() {
        attitudeX.removeAll()
        attitudeY.removeAll()
        attitudeZ.removeAll()
        gyroX.removeAll()
        gyroY.removeAll()
        gyroZ.removeAll()
        gravityX.removeAll()
        gravityY.removeAll()
        gravityZ.removeAll()
        accX.removeAll()
        accY.removeAll()
        accZ.removeAll()
    }

    func getCoremlOutput(){
        // store sensor data in array for CoreML model
        let dataNum = NSNumber(value:inputDataLength)
        let attitudeXarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let attitudeYarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let attitudeZarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let gyroXarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let gyroYarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let gyroZarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let gravityXarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let gravityYarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let gravityZarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let accXarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let accYarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)
        let accZarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double)

        for i in 0..<50 {
            attitudeXarray[i] = attitudeX[i] as NSNumber
            attitudeYarray[i] = attitudeY[i] as NSNumber
            attitudeZarray[i] = attitudeZ[i] as NSNumber

            gyroXarray[i] = gyroX[i] as NSNumber
            gyroYarray[i] = gyroY[i] as NSNumber
            gyroZarray[i] = gyroZ[i] as NSNumber

            gravityXarray[i] = gravityX[i] as NSNumber
            gravityYarray[i] = gravityY[i] as NSNumber
            gravityZarray[i] = gravityZ[i] as NSNumber

            accXarray[i] = accX[i] as NSNumber
            accYarray[i] = accY[i] as NSNumber
            accZarray[i] = accZ[i] as NSNumber
        }

        // input data to CoreML model
        guard let output = try? model.prediction(input: activity_cml_hand2Input(accX: accXarray, accY: accYarray, accZ: accZarray, gravityX: gravityXarray, gravityY: gravityYarray, gravityZ: gravityZarray, gyroX: gyroXarray, gyroY: gyroYarray, gyroZ: gyroZarray, stateIn: currentState)) else {
                fatalError("Unexpected runtime error.")
        }

        classLabel = output.label
        getSound(labelName: classLabel)
        currentState = output.stateOut
        predictionCount += 1
    }
    
    func getSound(labelName: String){
        switch labelName {
        case "jump":
            Ch.shared.sePlaySound(name: "jump")
            preLabel = "jump"
        case "run":
            if preLabel != "run" || preLabel == "" {
                Ch.shared.bgmPlaySound(name: "gamebgm", rate: 0.7)
            } else if preLabel == "walk"{
                Ch.shared.changeRateBgm(rate: 0.7)
            }
            preLabel = "run"
        case "walk":
            if preLabel != "walk" || preLabel == "" {
                Ch.shared.bgmPlaySound(name: "gamebgm", rate: 0.4)
            } else if preLabel == "run" {
                Ch.shared.changeRateBgm(rate: 0.5)
            }
            preLabel = "walk"
        case "stop":
            if preLabel == "stop" {
                stopCnt += 1
                if stopCnt == 2 {
                    Ch.shared.stopBgm()
                    stopCnt = 0
                }
            }else if preLabel != "stop" {
                stopCnt = 0
            }

            preLabel = "stop"
            default:
              print("その他の値")
        }
    }

}
