#include <SFE_BMP180.h>
#include <Wire.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
// #include <BLEService.h>

#define SERVER_NAME			"BMP180_BLE_Sensor"

#define SERVICE_UUID 		"bff0a4e6-6aa8-47b0-b6d8-9c2145b6fd93"
#define TEMPERATURE_UUID 	"f5b019d8-747c-44ba-b1e1-6e8ae03d9501"
#define PRESSURE_UUID 		"4890fbd4-320c-4295-b833-bd5132a057b1"
#define NAME_UUID 			"3ac44097-e190-4b13-a835-e452baa630ee"
#define RECIEVE_UUID 		"6de451b9-902f-4a84-b1fc-b8834e4f792d"

SFE_BMP180 measure;

bool deviceConnected;
// bool oldDeviceConnected;
BLEServer* pServer;
// BLEService* pService;
BLECharacteristic* pTemperatureChar;
BLEDescriptor TempDescriptor(BLEUUID((uint16_t)0x2902));

BLECharacteristic* pPressureChar;
BLEDescriptor PressDescriptor(BLEUUID((uint16_t)0x2903));

BLECharacteristic* pSensorNameChar;
BLEDescriptor NameDescriptor(BLEUUID((uint16_t)0x2904));

BLECharacteristic* pRecievedDataChar;
BLEDescriptor RecvDescriptor(BLEUUID((uint16_t)0x2905));


class EspServerCallbacks : public BLEServerCallbacks {

	void onConnect(BLEServer* pServer) {
		deviceConnected = true;
	};

	void onDisconnect(BLEServer* pServer) {
		deviceConnected = false;
	};

};

class EspCharacteristicCallbacks : public BLECharacteristicCallbacks {
	void onRead(BLECharacteristic* pCharacteristic) {
		Serial.println("Characteristic was read!\n");
	};
	void onWrite(BLECharacteristic* pCharacteristic) {
		Serial.println("Characteristic was written:");
		Serial.println(pCharacteristic->getValue().c_str());
	};
};

void setup()
{
	Serial.begin(115200);

	if (measure.begin()) {
		Serial.println("BMP180 init success!\n");
	}
	else {
		Serial.println("BMP180 init failed!\n\n");
		while(1); // Pause forever.
	}

	Serial.println("Starting BLE work...\n");

	BLEDevice::init(SERVER_NAME);
	pServer = BLEDevice::createServer();
	pServer->setCallbacks(new EspServerCallbacks());

	BLEService* pService = pServer->createService(SERVICE_UUID);

	pTemperatureChar = pService->createCharacteristic(TEMPERATURE_UUID, BLECharacteristic::PROPERTY_NOTIFY);
	TempDescriptor.setValue("Temperature");
	pTemperatureChar->addDescriptor(&TempDescriptor);

	pPressureChar = pService->createCharacteristic(PRESSURE_UUID, BLECharacteristic::PROPERTY_NOTIFY);
	PressDescriptor.setValue("Pressure");
	pPressureChar->addDescriptor(&PressDescriptor);

	pSensorNameChar = pService->createCharacteristic(NAME_UUID, BLECharacteristic::PROPERTY_READ);
	NameDescriptor.setValue("Name");
	pSensorNameChar->addDescriptor(&NameDescriptor);

	pRecievedDataChar = pService->createCharacteristic(RECIEVE_UUID, BLECharacteristic::PROPERTY_WRITE);
	RecvDescriptor.setValue("Recieved Data");
	pRecievedDataChar->addDescriptor(&RecvDescriptor);

	pService->start();
	BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
	pAdvertising->addServiceUUID(SERVICE_UUID);
	// pAdvertising->setScanResponse(true);
	// // pAdvertising->setMinPreferred(0x06);
	// // pAdvertising->setMinPreferred(0x12);
	// BLEDevice::startAdvertising();
	pServer->getAdvertising()->start();

	pSensorNameChar->setValue("Sensor name is BMP180");
	pRecievedDataChar->setCallbacks(new EspCharacteristicCallbacks());

	Serial.println("BLE started successfully!\n");
}

void loop()
{
	char status;
	double T, P, P_mmHg;

	if (deviceConnected) {
		status = measure.startTemperature();
		if (status == 0) {
			Serial.println("startTemperature failed!\n\n");
			while(1); // Pause forever.
		}

		// Wait for the measurement to complete:
		delay(status);

		status = measure.getTemperature(T);
		if (status == 0) {
			Serial.println("getTemperature failed!\n\n");
			while(1); // Pause forever.
		}

		status = measure.startPressure(3);
		if (status == 0) {
			Serial.println("startPressure failed!\n\n");
			while(1); // Pause forever.
		}
		
		// Wait for the measurement to complete:
		delay(status);

		status = measure.getPressure(P, T);
		if (status == 0) {
			Serial.println("getPressure failed!\n\n");
			while(1); // Pause forever.
		}
		P_mmHg = P*0.750063755419211;
		// Print out the measurement results:
		// Temperature
		Serial.print("temperature: ");
		Serial.print(T, 2);
		Serial.print(" °C\n");

		// Pressure
		Serial.print("absolute pressure: ");
		Serial.print(P, 2);
		Serial.print(" mbar, ");
		Serial.print(P_mmHg, 2);
		Serial.println(" mmHg\n");

		pTemperatureChar->setValue(T);
		pTemperatureChar->notify();
		pPressureChar->setValue(P_mmHg);
		pPressureChar->notify();
	}
	else {
		// delay(1000);
		pServer->startAdvertising();
		Serial.println("Waiting for connection...");
	}
	delay(5000);  // Pause for 5 seconds.
}
