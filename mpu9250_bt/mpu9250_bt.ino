#include <M5Stack.h>
#include "utility/MPU9250.h"
#include <MadgwickAHRS.h>
#include "BluetoothSerial.h"

MPU9250 IMU;

Madgwick filter;  // 姿勢を計算するオブジェクトを作る
unsigned long microsPerReading, microsPrevious;

BluetoothSerial SerialBT;

void setup() {
    M5.begin();
    M5.Lcd.setCursor(0, 0, 2);
    M5.Lcd.fillScreen(BLACK);
    Serial.begin(115200);
    SerialBT.begin("M5Stack");

    Wire.begin();
    if (IMU.readByte(MPU9250_ADDRESS, WHO_AM_I_MPU9250) != 0x71) {
        M5.Lcd.print("cannnot find MPU9250");
        while (true) ;
    }
    IMU.initMPU9250();  // MPU9250を初期化する
    IMU.calibrateMPU9250(IMU.gyroBias, IMU.accelBias);  // キャリブレートする

    filter.begin(10);  // 10Hz  filterを初期化する

    microsPerReading = 1000000 / 10;
    microsPrevious = micros();
}

#define INTERVAL 5
float rolls[INTERVAL], pitchs[INTERVAL], yaws[INTERVAL];
int maidx = 0; // moving average index
bool once = true;

void loop() {
    if (micros() - microsPrevious >= microsPerReading) {
        while (!(IMU.readByte(MPU9250_ADDRESS, INT_STATUS) & 0x01)) ;
        IMU.readAccelData(IMU.accelCount);  // 加速度の生データーを取得する
        IMU.getAres();  // スケール値を取得する

        IMU.ax = (float)IMU.accelCount[0] * IMU.aRes - IMU.accelBias[0];
        IMU.ay = (float)IMU.accelCount[1] * IMU.aRes - IMU.accelBias[1];
        IMU.az = (float)IMU.accelCount[2] * IMU.aRes - IMU.accelBias[2];

        IMU.readGyroData(IMU.gyroCount);  // ジャイロの生データーを取得する
        IMU.getGres();  // スケール値を取得する

        IMU.gx = (float)IMU.gyroCount[0] * IMU.gRes;
        IMU.gy = (float)IMU.gyroCount[1] * IMU.gRes;
        IMU.gz = (float)IMU.gyroCount[2] * IMU.gRes;

        M5.Lcd.fillScreen(BLACK);
        M5.Lcd.setCursor(0, 5, 2);
        M5.Lcd.printf("%6.2f %6.2f %6.2f", IMU.ax, IMU.ay, IMU.az);

        M5.Lcd.setCursor(0, 40);
        M5.Lcd.printf("%6.2f %6.2f %6.2f", IMU.gx, IMU.gy, IMU.gz);
    
        filter.updateIMU(IMU.gx, IMU.gy, IMU.gz, IMU.ax, IMU.ay, IMU.az);

        rolls[maidx % INTERVAL] = filter.getRoll();
        pitchs[maidx % INTERVAL] = filter.getPitch();
        yaws[maidx % INTERVAL] = filter.getYaw();
        maidx++;

        float roll = 0.0;
        float pitch = 0.0;
        float yaw = 0.0;
        for (int i = 0; i < INTERVAL; i++) {
            roll += rolls[i];
            pitch += pitchs[i];
            yaw += yaws[i];
        }
        roll /= INTERVAL;
        pitch /= INTERVAL;
        yaw /= INTERVAL;

        M5.Lcd.setCursor(0, 75);
        M5.Lcd.printf("%6.2f %6.2f %6.2f", roll, pitch, yaw);
        Serial.printf("%6.2f, %6.2f, %6.2f\r\n", roll, pitch, yaw);
        SerialBT.printf("%6.2f, %6.2f, %6.2f\r\n", roll, pitch, yaw);

        microsPrevious = microsPrevious + microsPerReading;
    }
}
