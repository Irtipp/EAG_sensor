% Temperature and Noise Level
% Author: Isaac Tipping, John Aufderhar, Luke Taylor
% Date: Oct 24, 2025
clc
clear
close all
% Connect to Arduino
a = arduino("/dev/ttyACM0", "Uno", 'Libraries', 'Adafruit/DHTxx');

% Create DHT sensor object on digital pin D3
dhtSensor = addon(a, 'Adafruit/DHTxx', 'D3', 'DHT11');

% Initialize data storage
Time = [];
Temperature = [];
Humidity = [];
disp("Starting measurements...");
tic();

% Parameters
Fs = 44100;       % Sampling rate
nBits = 16;       % Bits per sample
nChannels = 1;    % Mono
duration = 10;     % Recording duration in seconds

% Create audiorecorder object
recObj = audiorecorder(Fs, nBits, nChannels);
disp('Start speaking.');
record(recObj);

%Temperature readings
for i = 1:10
    % Read data from the sensor
    [tempC] = readTemperature(dhtSensor);
    
    % Store data
    Time(i) = toc();
    Temperature(i) = tempC;
  
    pause(1); % wait 1 second between readings
end

stop(recObj);
disp('End of recording.');

% Get the audio data as a numeric array
audioData = getaudiodata(recObj);
% Time vector
t = (0:length(audioData)-1)/Fs;
figure;
subplot(2,1,1);
% ---- RMS calculation ----
rms_amplitude = rms(audioData);
disp(['RMS Amplitude: ', num2str(rms_amplitude)]);
% ---- Convert to dB ----
epsilon = 1e-12; % small number to avoid log(0)
audio_dB = 20*log10(abs(audioData) + epsilon);
% Optional: Smooth the dB signal
windowSize = 50000; 
audio_dB_smooth = movmean(audio_dB, windowSize);
% ---- Plot dB over time ----
plot(t, audio_dB_smooth);
xlabel('Time (t) [s]');
ylabel('Sound (s) [dB]')
title('Smoothed Audio Signal in Decibels');
grid on;
% ---- Optional: Play back the recording ----
% play(recObj);
%disp('Playing recorded audio...');
%play(recObj);
%disp("Measurements complete.");

% Plot temp
subplot(2,1,2)
plot(Time, Temperature, 'r-o');
title('Temperature over Time');
xlabel('Time (t) [s]');
ylabel('Temperature (T) [degC]');
legend('Temp (t) DegC]')
grid on;
