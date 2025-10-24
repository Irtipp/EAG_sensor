% Parameters
Fs = 44100;       % Sampling rate
nBits = 16;       % Bits per sample
nChannels = 1;    % Mono
duration = 5;     % Recording duration in seconds

% Create audiorecorder object
recObj = audiorecorder(Fs, nBits, nChannels);

disp('Start speaking.');
recordblocking(recObj, duration); % Record for full duration
disp('End of recording.');

% Get the audio data as a numeric array
audioData = getaudiodata(recObj);

% Time vector
t = (0:length(audioData)-1)/Fs;

% ---- Plot waveform ----
figure;
subplot(2,1,1);
plot(t, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Captured Audio Signal');
grid on;

% ---- RMS calculation ----
rms_amplitude = rms(audioData);
disp(['RMS Amplitude: ', num2str(rms_amplitude)]);

% ---- Convert to dB ----
epsilon = 1e-12; % small number to avoid log(0)
audio_dB = 20*log10(abs(audioData) + epsilon);

% Optional: Smooth the dB signal
windowSize = 500;
audio_dB_smooth = movmean(audio_dB, windowSize);

% ---- Plot dB over time ----
subplot(2,1,2);
plot(t, audio_dB_smooth);
xlabel('Time (s)');
ylabel('Amplitude (dB)');
title('Smoothed Audio Signal in Decibels');
grid on;

% ---- Optional: Play back the recording ----
% play(recObj);

disp('Playing recorded audio...');
play(recObj);