function blur = blurinessEstimtn(I)
%[isBlurring, blur, extent]
Threshold = 35;
MinZero = 0.05;
MaximumWidth = 256;
MaximumHeight = 256;

%I = imread(img_name);
[height, width, c] = size(I);
height = height-mod(height, 16);
width = width-mod(width, 16);

dr = min(height, width);

top = (height-dr)/2;
left =(width-dr)/2;

I = I(top+1:top+dr, left+1:left+dr, 1:3);
I = rgb2gray(I);
[blur,extent] = IsBlurredInner(I);

if(blur < MinZero)
    isBlurring = true;
    %blur;
    %extent;
else
    isBlurring = false;
    %blur;
    %extent;
end

end

function [conf, extent, blur] = IsBlurredInner(I)
if(~exist('Decomposition', 'var'))
    Decomposition = 3;
end;
if(isempty(Decomposition))
    Decomposition = 3;
end;

[h, w] = size(I);
Emax = zeros(h/16, w/16, 3);

    
for level = 1:Decomposition
    tmp = 2^level;
    win_size = 16/tmp;
    sh = h/tmp;
    sw = w/tmp;
    
    I(1:sh*2, 1:sw*2) = HaarWaveTran(I(1:sh*2, 1:sw*2), 'x');
    I(1:sh*2, 1:sw*2) = HaarWaveTran(I(1:sh*2, 1:sw*2), 'y');
    
    %figure;imshow(I);
    %Emapi
    Emap = calcEmap(I(1:sh*2, 1:sw*2));
    
    %Emaxi
	Emax(1:h/16, 1:w/16, level) = CalcEmax(Emap, win_size, level);
    
end;


[conf, extent] = DetectBlur(Emax);

end

function [blur, extent]= DetectBlur(I)
if(~exist('Threshold', 'var'))
    Threshold = 35;
end;
if(isempty(Threshold))
    Threshold = 35;
end;

Nedge = 0;
Nda = 0;
Nrg = 0;
Nbrg = 0;

[height, width, level] = size(I);


for k = 1: height
    for l = 1:width
        
        emax1 = I(k, l, 1);
        emax2 = I(k, l, 2);
        emax3 = I(k, l, 3);
        
        emax = max(max(emax1, emax2), emax3);
        if emax>Threshold
            Nedge = Nedge+1;
            if emax1 > emax2 && emax2 > emax3
                Nda = Nda+1;
            end;
            
            if emax1 < emax2 && emax2 <emax3
                Nrg = Nrg + 1;
                if emax1 < Threshold
                	Nbrg = Nbrg+1;
                end;
            end;
            if emax2 > emax1 && emax2 > emax3
                Nrg = Nrg+1;
                if emax1 < Threshold
                    Nbrg = Nbrg +1;
                end;
            end;
        end;
    end;
end;

if Nedge == 0
    per = 0;
else 
    per = double(Nda);
    per = per/double(Nedge);
end;

blur = per;
extent = double(Nbrg)/double(Nrg);

end


function Emax = CalcEmax(I, win_size, scale)

[h, w] = size(I);
scale = 16/(2^scale);
Emax = zeros(h/scale, w/scale);

k = 1;
    for i = 1:win_size: h-win_size+1
        l = 1;
        for j = 1:win_size:w-win_size+1
            win_M = I(i:i+win_size-1, j:j+win_size-1);
            Emax(k, l) = max(max(win_M));
            l = l+1;
        end
        k = k+1;
    end
    
end

function Emap = calcEmap(I)
[height, width] = size(I);

half_height = height/2;
half_width  = width/2;

Emap = zeros(half_height, half_width);

for y = 1:half_height
    for x = 1:half_width
        tmp = double(I(y, x+half_width))^2 ...
        +double(I(y+half_height, x))^2 ...
        +double(I(y+half_height, x+half_width))^2;
        Emap(y, x) = sqrt(tmp);
    end;
end;

end

function res = HaarWaveTran(I, direct)

if(direct == 'y')
    I = I';
end;

[h, w] = size(I);
res = zeros(h, w);

for j = 1:h
    k = 1;
    for i = 1:2:w-1
        res(j, k) = (I(j, i+1)+I(j, i))/2;
        res(j, k+w/2) = (I(j, i+1)-I(j, i));
        k = k+1;
    end;
end;

if(direct == 'y')
    res = res';
end;

end
