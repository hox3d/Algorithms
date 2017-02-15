%% Schroeder Reverberator
% This script will implement a basic schroeder reverberator.
% With all-pass filters, comb filters, and mixing matrix.

clear all;
close all;

%% Variables

%% File
[audio_in, Fs] = audioread('Z:\2016_2017\AudioRadio Projet\Sounds\96-enfants.wav');
audio_in = audio_in';

%% All-pass filter (processes it in stereo)
AP1_delay = 1024;
AP1_gain1 = -0.8;
AP1_gain2 = -AP1_gain1;

audio_out = zeros(2, length(audio_in));
audio_out_temp = zeros(2,1);
audio_temp = zeros(2,AP1_delay);

AP2_delay = 544;
AP2_gain1 = -0.5;
AP2_gain2 = -AP2_gain1;
audio_temp2 = zeros(2,AP2_delay);

AP3_delay = 785;
AP3_gain1 = -0.5;
AP3_gain2 = -AP2_gain1;
audio_temp3 = zeros(2,AP3_delay);

% All pass 1
for i=1+AP1_delay:length(audio_in)
    audio_out(:, i) = audio_in(:,i).*AP1_gain1 + audio_temp(:,AP1_delay);
    audio_out_temp = audio_out(:, i)*AP1_gain2;
    audio_temp = [(audio_in(:,i)+audio_out_temp),audio_temp(:,1:AP1_delay-1)];
end
audio_in2 = audio_out;

% All pass 2
for i=1+AP2_delay:length(audio_out)
    audio_out(:, i) = audio_in2(:,i).*AP2_gain1 + audio_temp2(:,AP2_delay);
    audio_out_temp = audio_out(:, i)*AP2_gain2;
    audio_temp2 = [(audio_in2(:,i)+audio_out_temp),audio_temp2(:,1:AP2_delay-1)];
end
audio_in3 = audio_out;

% All pass 3
for i=1+AP3_delay:length(audio_out)
    audio_out(:, i) = audio_in3(:,i).*AP3_gain1 + audio_temp3(:,AP3_delay);
    audio_out_temp = audio_out(:, i)*AP3_gain2;
    audio_temp3 = [(audio_in3(:,i)+audio_out_temp),audio_temp3(:,1:AP3_delay-1)];
end


%% Comb filters network
comb_delay1 = 2245;
comb_delay2 = 124;
comb_delay3 = 1552;
comb_delay4 = 584;

comb_coeffA1 = 0.8;
comb_coeffA2 = 0.4;
comb_coeffA3 = 0.6;
comb_coeffA4 = 0.9;

comb_coeffB1 = 0.5;
comb_coeffB2 = 0.5;
comb_coeffB3 = 0.5;
comb_coeffB4 = 0.5;

audio_in_comb = audio_out;

audio_comb_temp1 = zeros(2,comb_delay1);
audio_comb_temp2 = zeros(2,comb_delay2);
audio_comb_temp3 = zeros(2,comb_delay3);
audio_comb_temp4 = zeros(2,comb_delay4);

audio_outx1 = zeros(2,length(audio_in_comb));
audio_outx2 = zeros(2,length(audio_in_comb));
audio_outx3 = zeros(2,length(audio_in_comb));
audio_outx4 = zeros(2,length(audio_in_comb));

% comb 1
for i=1:length(audio_out)
    audio_outx1(:,i) = audio_in_comb(:,i) + audio_comb_temp1(:,comb_delay1).*comb_coeffA1;
    audio_comb_temp1 = [audio_outx1(:,i), audio_comb_temp1(:,1:comb_delay1-1)];
    audio_outx1(:,i) = audio_outx1(:,i)*comb_coeffB1;
end

% comb 2
for i=1:length(audio_out)
    audio_outx2(:,i) = audio_in_comb(:,i) + audio_comb_temp2(:,comb_delay2).*comb_coeffA2;
    audio_comb_temp2 = [audio_outx2(:,i), audio_comb_temp2(:,1:comb_delay2-1)];
    audio_outx2(:,i) = audio_outx2(:,i)*comb_coeffB2;
end

% comb 3
for i=1:length(audio_out)
    audio_outx3(:,i) = audio_in_comb(:,i) + audio_comb_temp3(:,comb_delay3).*comb_coeffA3;
    audio_comb_temp3 = [audio_outx3(:,i), audio_comb_temp3(:,1:comb_delay3-1)];
    audio_outx3(:,i) = audio_outx3(:,i)*comb_coeffB3;
end

% comb 4
for i=1:length(audio_out)
    audio_outx4(:,i) = audio_in_comb(:,i) + audio_comb_temp4(:,comb_delay4).*comb_coeffA4;
    audio_comb_temp4 = [audio_outx4(:,i), audio_comb_temp4(:,1:comb_delay4-1)];
    audio_outx4(:,i) = audio_outx4(:,i)*comb_coeffB4;
end
%% Mixing matrix

s1 = audio_outx1+audio_outx3;
s2 = audio_outx4+audio_outx2;

OutA = s1 + s2;
OutB = -OutA;
OutD = s1 - s2;
OutC = -OutD;





%sound(audio_out, Fs);
%sound(audio_in,Fs);