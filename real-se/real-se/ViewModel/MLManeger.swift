//
//  MLManeger.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/28.
//

import Foundation
import CoreMotion
import simd
import CoreML
import Combine

class MLManeger: ObservableObject{

    @Published var classLabel = "hello"
    let motionManager = CMMotionManager()
    var attitude = SIMD3<Double>.zero
    var gyro = SIMD3<Double>.zero
    var gravity = SIMD3<Double>.zero
    var acc = SIMD3<Double>.zero
    let model = iPhoneModel()

    let inputDataLength = 50
    var compAccArray = [Double]()
    var predictionCount = 0

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
        print("attitudeX:", deviceMotion.attitude.pitch)
        print("attitudeY:", deviceMotion.attitude.roll)
        print("attitudeZ:", deviceMotion.attitude.yaw)
        print("gyroX:", deviceMotion.rotationRate.x)
        print("gyroY:", deviceMotion.rotationRate.y)
        print("gyroZ:", deviceMotion.rotationRate.z)
        print("gravityX:", deviceMotion.gravity.x)
        print("gravityY:", deviceMotion.gravity.y)
        print("gravityZ:", deviceMotion.gravity.z)
        print("accX:", deviceMotion.userAcceleration.x)
        print("accY:", deviceMotion.userAcceleration.y)
        print("accZ:", deviceMotion.userAcceleration.z)

        attitude.x = deviceMotion.attitude.pitch
        attitude.y = deviceMotion.attitude.roll
        attitude.z = deviceMotion.attitude.yaw
        gyro.x = deviceMotion.rotationRate.x
        gyro.y = deviceMotion.rotationRate.y
        gyro.z = deviceMotion.rotationRate.z
        gravity.x = deviceMotion.gravity.x
        gravity.y = deviceMotion.gravity.y
        gravity.z = deviceMotion.gravity.z
        acc.x = deviceMotion.userAcceleration.x
        acc.y = deviceMotion.userAcceleration.y
        acc.z = deviceMotion.userAcceleration.z

        // add data for input CoreML
        compAccArray.append(getCompositeData(sensorData: &acc))
        if compAccArray.count >= inputDataLength {
            getCoremlOutput()
            compAccArray.removeAll()
        }
    }

    // 合成加速度
    func getCompositeData(sensorData:inout SIMD3<Double>) -> Double{
        let compData = sqrt((sensorData.x * sensorData.x) + (sensorData.y * sensorData.y) + (sensorData.z * sensorData.z))

        return compData
    }

    func getCoremlOutput(){
        print("---------------------------------------------------------")
        // store sensor data in array for CoreML model
        let dataNum = NSNumber(value:inputDataLength)
        let mlarray = try! MLMultiArray(shape: [dataNum], dataType: MLMultiArrayDataType.double )

        for (index, data) in compAccArray.enumerated(){
            mlarray[index] = data as NSNumber
        }

        // input data to CoreML model
        guard let output = try? model.prediction(input:
            iPhoneModelInput(input1: mlarray)) else {
                fatalError("Unexpected runtime error.")
        }
        classLabel = output.classLabel
        predictionCount += 1
    }

}
