clc;
clear;
close all;

codeword = [1 0 1 0 1 0 1];
disp('Original Hamming Codeword:');
disp(codeword);

data = [codeword(3) codeword(5) codeword(6) codeword(7)];
disp('Original Data Bits:');
disp(data);

error_position = 5;
received = codeword;

received(error_position) = ...
    1 - received(error_position);

fprintf('\nError Introduced at Position = %d\n', error_position);
disp('Received Codeword with Error:');
disp(received);
s1 = mod(received(1)+received(3)+received(5)+received(7),2);
s2 = mod(received(2)+received(3)+received(6)+received(7),2);
s3 = mod(received(4)+received(5)+received(6)+received(7),2);
fprintf('\nSyndrome = %d%d%d\n',s3,s2,s1);


error_detected = s1 + 2*s2 + 4*s3;
fprintf('Detected Error Position = %d\n', error_detected);


corrected = received;
if error_detected ~= 0
    corrected(error_detected) = 1 - corrected(error_detected);
    disp('Error Corrected Successfully');
else
    disp('No Error Detected');
end
disp('Corrected Codeword:');
disp(corrected);


decodedData = [corrected(3) corrected(5) corrected(6) corrected(7)];
disp('Decoded Data Bits:');
disp(decodedData);



receivedData = [received(3) received(5) received(6) received(7)];
errorsBefore = sum(data ~= receivedData);
BER_before = errorsBefore/length(data);


errorsAfter = sum(data ~= decodedData);
BER_after = errorsAfter/length(data);
fprintf('BER Before Error Correction = %.2f\n',...
        BER_before);
fprintf('BER After Error Correction  = %.2f\n',...
        BER_after);


bitAxis = 0:7;
originalPlot = [codeword codeword(end)];
errorPlot = [received received(end)];
correctedPlot = [corrected corrected(end)];
figure('Name','Hamming Error Correction', 'NumberTitle','off');




subplot(3,1,1)
stairs(bitAxis,originalPlot, 'LineWidth',1.5);
grid on
xlim([0 7])
ylim([-0.2 1.2])
xticks(0:7)
yticks([0 1])
xlabel('Bit Position')
ylabel('Amplitude')
title('Original Signal : 1 0 1 0 1 0 1')
subplot(3,1,2)
stairs(bitAxis,errorPlot, 'LineWidth',1.5)
grid on
xlim([0 7])
ylim([-0.2 1.2])
xticks(0:7)
yticks([0 1])
xlabel('Bit Position')
ylabel('Amplitude')
title(['Received Signal with Error at Position ', num2str(error_position)])
subplot(3,1,3)
stairs(bitAxis,correctedPlot, 'LineWidth',1.5)
grid on
xlim([0 7])
ylim([-0.2 1.2])
xticks(0:7)
yticks([0 1])
xlabel('Bit Position')
ylabel('Amplitude')
title('Corrected Signal : 1 0 1 0 1 0 1')
sgtitle('Channel Coding and Error Correction');

figure('Name','BER Analysis', 'NumberTitle','off');


xCurve = linspace(0,1,100);

BERcurve = BER_before*(1-xCurve).^2;

plot(xCurve,BERcurve, 'LineWidth',1.2);
hold on
plot(0,BER_before,'o', 'MarkerSize',7, 'LineWidth',1.2);


plot(1,BER_after,'o',  'MarkerSize',7,  'LineWidth',1.2);
grid on
xlabel('Error Correction Process')

ylabel('Bit Error Rate (BER)')
title('BER Before and After Hamming Error Correction')
xlim([0 1])
ylim([0 0.30])
xticks([0 0.25 0.5 0.75 1])
xticklabels({'Before Correction', '','','','After Correction'});


text(0.02,BER_before+0.015, sprintf('BER = %.2f',BER_before), 'FontWeight','bold');
text(0.98,BER_after+0.015,...
    sprintf('BER = %.2f',BER_after), 'HorizontalAlignment','right',  'FontWeight','bold');
hold off


fprintf('Original Codeword  : ');
fprintf('%d ',codeword);
fprintf('\n');
fprintf('Received Codeword  : ');
fprintf('%d ',received);
fprintf('\n');
fprintf('Corrected Codeword : ');
fprintf('%d ',corrected);
fprintf('\n');
fprintf('Error Position     : %d\n',...
        error_detected);
fprintf('BER Before Correction = %.2f\n',...
        BER_before);
fprintf('BER After Correction  = %.2f\n', BER_after);