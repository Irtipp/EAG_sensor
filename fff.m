% DHT11TemperatureHumidity.mlx
% Author: Isaac Tipping
% Date: Oct 7, 2025

clc
clear
close all

% Connect to Arduino (adjust COM port if needed)
a = arduino("/dev/ttyACM0", "Uno", 'Libraries', 'Adafruit/DHTxx');

% Create DHT sensor object on digital pin D3
dhtSensor = addon(a, 'Adafruit/DHTxx', 'D3', 'DHT11');

% Initialize data storage
Time = [];
Temperature = [];
Humidity = [];

disp("Starting measurements...");
tic();

for i = 1:50
    % Read data from the sensor
    [tempC] = readTemperature(dhtSensor);
    
    % Store data
    Time(i) = toc();
    Temperature(i) = tempC;
  


    pause(1); % wait 1 second between readings
end

disp("Measurements complete.");

% Plot results
figure;
subplot(2,1,1);
plot(Time, Temperature, 'r-o');
title('Temperature over Time');
xlabel('Time [s]');
ylabel('Temperature [°C]');
grid on;

