function [images,ref]=structdatabase()
imagespath=dir('/Users/MIcky/Documents/MATLAB/elaborazione_delle_immagini/progetto/YaleB/');
ImagesPath=imagespath(4:end,:); 
images=struct;
% Importa le immagini all'interno di una struct contenente 38 sotto-struct
% ognuna delle quali contiene le 65 immagini del singolo soggetto. 
% Ciao <3
for i=1:size(ImagesPath,1)
    images(i).cartella=dir([ImagesPath(i).folder,'/',ImagesPath(i).name filesep '*pgm' ]);
for j=1:size(images(i).cartella,1)
    images(i).cartella(j).foto=imread([images(i).cartella(j).folder,'/', images(i).cartella(j).name]);
    images(i).cartella(j).thumb64=imresize(images(i).cartella(j).foto, [64 64]);
    images(i).cartella(j).doub64=im2double(images(i).cartella(j).thumb64);
    images(i).cartella(j).fft64=fft2(images(i).cartella(j).doub64);
    images(i).cartella(j).bwft=dither(abs(images(i).cartella(j).fft64));
end
end
% Scelgo un'immagine di riferimento caratteristica di ogni individuo.
% All'interno di una seconda struct ref si inseriscono le thumbnail, le
% matrici in double, la dct, la fft, e le 4 feature scelte.
ref=struct;
tot=64*64;
for i=1:size(images,2)
    ref(i).thumb64=images(i).cartella(7).thumb64;
    ref(i).doub64=im2double(ref(i).thumb64);
    ref(i).dct64=dct2(ref(i).doub64);
    % ref(i).dct16=dctmtx(size(ref(i).doub16,1))*ref(i).doub16*(dctmtx(size(ref(i).doub16,1))')
    ref(i).dft64=fft2(ref(i).doub64);
    ref(i).bwdft=dither(abs(ref(i).dft64));
    isto = imhist(ref(i).thumb64);
    ref(i).indice_grigio=round(mean((find(isto == max(isto))-1)));%indice valore massimo dell'istogramma
    ref(i).neroperc= round(sum(isto(1:128))/sum(isto(:))*100);
    ref(i).vardft64=mean(var(abs(ref(i).dft64)));
    % ref(i).vardftlog64=mean(var(log(abs(ref(i).dft64))));
    ref(i).percblack=(sum(sum(ref(i).bwdft))/tot)*100;
end
