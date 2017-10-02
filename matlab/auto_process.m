files = dir('C:\Users\nancy\OneDrive\Documents\HMC\Clay-Wolkin\isp\images\*.dng');

for i = 1:L
    filename = strcat('images\', files(i).name);
    dng_process(filename,1,1,1,1,1);
end