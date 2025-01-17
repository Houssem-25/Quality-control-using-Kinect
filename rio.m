clear all;
close all;


fileX = 'data/master2_Root_SB_01_cam0_01_rec3d_X.ipl';
fileY = 'data/master2_Root_SB_01_cam0_01_rec3d_Y.ipl';
fileZ = 'data/master2_Root_SB_01_cam0_01_rec3d_Z.ipl';

%I = imread('../master2/master_Root_SB_02_cam0_02_corrected.jpg');

% Ouverture des fichiers des acquisition kinect
fidX = fopen(fileX, 'r'); % 'r' - read is the default
fidY = fopen(fileY, 'r'); % 'r' - read is the default
fidZ = fopen(fileZ, 'r'); % 'r' - read is the default

% Parsing des fichiers
if fidX ~= -1
    InputTextX=textscan(fidX,'%s'); % Read strings delimited by a carriage return
    valX=InputTextX{1};
end
if fidY ~= -1
    InputTextY=textscan(fidY,'%s'); % Read strings delimited by a carriage return
    valY=InputTextY{1};
end
if fidZ ~= -1
    InputTextZ=textscan(fidZ,'%s'); % Read strings delimited by a carriage return
    valZ=InputTextZ{1};
end

% Saut de l'en-tete, recuperation des valeurs et stockage sous forme matricielle
i=0;j=0;
for k=16:size(valX)-1
    j=mod((k-16),640)+1;
    if j == 1
        i = i+1;
    end
    % Conversion string to number
    x = str2num(valX{k});
    y = str2num(valY{k});
    z = str2num(valZ{k});
    
    % Stockage sous forme matricielle
    imX(i,j) = x;
    imY(i,j) = y;
    imZ(i,j) = z;
end
% Fin du parsing, les valeurs ont ete recuperees
fclose(fidX);
fclose(fidY);
fclose(fidZ);

% Stockage des valeurs sous forme vectorielle
vecX = reshape(imX,307200,1);
vecY = reshape(imY,307200,1);
vecZ = reshape(imZ,307200,1);


figure();
for i=1:16:307200
    if(vecX(i)~=0 && vecY(i)~=0 && vecZ(i)~=0)
        plot3(vecX(i),vecY(i),vecZ(i),'.');
        hold on
    end
end
xlabel('X'); ylabel('Y'), zlabel('Z');
box on;

%% **********************************************************************
% Selection ROI


j=1;
for i=1:size(vecX)
    % A ajouter les conditions pour la fonction 'if'
    if( vecX(i)>-200 && vecX(i)<=450 && vecY(i)>1100 && vecY(i)<1900 && vecZ(i)>-100 && vecZ(i)<500 )
    
        roiX(j)=vecX(i); 
        roiY(j)=vecY(i); 
        roiZ(j)=vecZ(i); 
        j=j+1;
    end
end

%% On regarde si le resultat convient
figure();
plot3(roiX,roiY,roiZ,'.');
xlabel('X'); ylabel('Y'), zlabel('Z');
box on;
 
%% Si le resultat est correct, on sauvegarde les donnees selectionnees
save('roiX.mat','roiX');
save('roiY.mat','roiY');
save('roiZ.mat','roiZ');
