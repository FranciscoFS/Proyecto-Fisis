info = dicominfo('IM-0005-0001.dcm');
dxdy = info.PixelSpacing;
dz = info.SliceThickness;
nRows = info.Rows;
nCols = info.Columns;
nPlanes = info.SamplesPerPixel;
inicio = 1;
fin = 40;

nFrames = fin-inicio; % Aqui el número de imágenes a ver

X = repmat(int16(0), [nRows, nCols, nFrames]);
X1 = repmat(int16(0), [nRows, nCols, nFrames]);
X2 = repmat(int16(0), [nRows, nCols, nFrames]);
X3 = repmat(int16(0), [nRows, nCols, nFrames]);

for p = inicio:fin    
im = dicomread(sprintf('IM-0004-%04d.dcm', p));
im = mat2gray(im);
%otsu = graythresh(im);
%im2 = imbinarize(im,otsu);
im2= imbinarize(im,'adaptive','Sensitivity',0.6);
%im3 = imbinarize(im,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);

%bw1 = I>500;
%bw2 = I>300;
bw1 = im>0.36;
bw2 = im>0.2203;
bw3=bw2-bw1;
bw4 = bwareaopen(bw3,1500);
bw4=imclearborder(bw4,1);
se = strel('disk',1);
bw4 = imclose(bw4,se);
se = strel('disk',1);
bw5 = imdilate(bw4, se);
bw5 = imfill(bw5,'holes');

%X(:,:,p-inicio+1) = bw1;
X1(:,:,p-inicio+1) = bw3;
X2(:,:,p-inicio+1) = bw4;
X3(:,:,p-inicio+1) = bw5;
end


%Con rotula
%X4 = bwareaopen(X3,10000,26);
%Sin rotula
%X5 = bwareaopen(X3,40000,26);

%porte = size(im);
%save('femur_final.mat');

% subplot(2,2,1), imshow(im,[])
% subplot(2,2,2), imshow(bw1)
% subplot(2,2,3), imshow(bw2)
% subplot(2,2,4), imshow(bw3)