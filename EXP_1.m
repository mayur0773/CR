clc;
clear;
close all;
fs = 1000;
fPrimary = 100;
fSecondary = 200;
N = 1000;
t = (0:N-1)/fs;
threshold = 0.5;
primarySignal1 = zeros(1,N);
noise1 = 0.2*randn(1,N);
receivedSignal1 = primarySignal1 + noise1;
energy1 = mean(receivedSignal1.^2)
if energy1 < threshold
    decision1 = 'CHANNEL FREE';
    secondarySignal1 = sin(2*pi*fSecondary*t);
else
    decision1 = 'CHANNEL OCCUPIED';
    secondarySignal1 = zeros(1,N);
end
primarySignal2 = sin(2*pi*fPrimary*t);
noise2 = 0.2*randn(1,N);
receivedSignal2 = primarySignal2 + noise2;
energy2 = mean(receivedSignal2.^2);
if energy2 > threshold
    decision2 = 'CHANNEL OCCUPIED';
    secondarySignal2 = zeros(1,N);
else
    decision2 = 'CHANNEL FREE';
    secondarySignal2 = sin(2*pi*fSecondary*t);
end
if energy1 < threshold
    disp('Secondary User : Spectrum Access Granted')
else
    disp('Secondary User : Spectrum Occupied')
end
if energy2 > threshold
    disp('Secondary User : Spectrum Occupied')
else
    disp('Secondary User : Spectrum Access Granted')
end
figure('Name','CASE 1 : Energy < Threshold','NumberTitle','off');
subplot(5,1,1)
plot(t,primarySignal1,'b','LineWidth',1.5)
grid on
title('Primary User Signal (Absent)')
ylabel('Amplitude')
subplot(5,1,2)
plot(t,noise1,'m')
grid on
title('AWGN Channel')
ylabel('Amplitude')
subplot(5,1,3)
plot(t,receivedSignal1,'r')
grid on
title('Received Signal')
ylabel('Amplitude')
subplot(5,1,4)
bar([energy1 threshold])
set(gca,'XTickLabel',{'Measured Energy','Threshold'})
grid on
title('Energy Detection')
ylabel('Energy')
subplot(5,1,5)
plot(t,secondarySignal1,'g','LineWidth',1.5)
grid on
title('Secondary User Transmission')
xlabel('Time (s)')
ylabel('Amplitude')
figure('Name','CASE 2 : Energy > Threshold','NumberTitle','off');
subplot(5,1,1)
plot(t,primarySignal2,'b','LineWidth',1.5)
grid on
title('Primary User Signal (Present)')
ylabel('Amplitude')
subplot(5,1,2)
plot(t,noise2,'m')
grid on
title('AWGN Channel')
ylabel('Amplitude')
subplot(5,1,3)
plot(t,receivedSignal2,'r')
grid on
title('Received Signal')
ylabel('Amplitude')
subplot(5,1,4)
bar([energy2 threshold])
set(gca,'XTickLabel',{'Measured Energy','Threshold'})
grid on
title('Energy Detection')
ylabel('Energy')
subplot(5,1,5)
plot(t,secondarySignal2,'k','LineWidth',1.5)
grid on
title('Secondary User Blocked')
xlabel('Time (s)')
ylabel('Amplitude')
selectedSNR = [0 5 10 20];
tBER = 0:1/1000:0.1;
cleanSignal = sin(2*pi*50*tBER);
signalPower = mean(cleanSignal.^2);
figure('Name','SNR Noise and BER Analysis','NumberTitle','off');
for i = 1:length(selectedSNR)
    snrLinear = 10^(selectedSNR(i)/10);
    noisePower = signalPower/snrLinear;
    noise = sqrt(noisePower)*randn(size(cleanSignal));
    received = cleanSignal + noise;
    subplot(5,1,i)
    plot(tBER,received,'LineWidth',0.8)
    hold on
    plot(tBER,cleanSignal,'--','LineWidth',0.8)
    grid on
    ylabel('Amplitude')
    if selectedSNR(i) == 0
        title('SNR = 0 dB : Very High Noise Effect')
    elseif selectedSNR(i) == 5
        title('SNR = 5 dB : Moderate Noise Effect')
    elseif selectedSNR(i) == 10
        title('SNR = 10 dB : Low Noise Effect')
    else                                                                                                                                                                                                                                        
        title('SNR = 20 dB : Very Low Noise Effect')
    end
    legend('Received','Clean','Location','eastoutside')
    hold off
end
SNRdB = 0:0.1:20;
SNRlinear = 10.^(SNRdB/10);
BER = 0.5*erfc(sqrt(SNRlinear));
importantSNR = [0 5 10 20];
importantBER = 0.5*erfc(sqrt(10.^(importantSNR/10)));
importantBER(importantBER < 1e-12) = 1e-12;
subplot(5,1,5)
semilogy(SNRdB,BER,'LineWidth',1)
hold on
semilogy(importantSNR,importantBER, 'o','MarkerSize',5,'LineWidth',1)
grid on
grid minor
xlabel('SNR (dB)')
ylabel('BER')
title('SNR vs BER Performance')
xlim([0 20])
ylim([1e-12 1])
xticks([0 5 10 15 20])
hold off
