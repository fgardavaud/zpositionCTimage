
% Z-position histogram reconstruction for smartstep/smartview images during CT interventional procedures


% created by : François Gardavaud
% version: v2 with structures
% date of version: 29/08/2019

%% console and workspace cleaning
% /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\
% You can delete those line if you wante to skip dicominfo generation in
% thecase you have already open your dicom files in a previous running
% without any modification
% /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\
clc;
clear all;
close all hidden;

% disabling alerts
warning('off','all');


%% Opening image files and retrieving common DICOM fields


% /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\
% The CT smartstep/smartview images have to be placed in one and unique image folder.
% No sub-folder will be take into account.
% /!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\/!\


% test to know if reading images and retrieving DICOM information
% already done previously to save calculation time.
test_debug = exist('info_dicom');
if test_debug==0
    % % Dialog box for selecting the root folder of images
    ImageStackDirectory = fct_uipickfiles('prompt','Select your smartstep CT images folder','out','ch');
    ImageStackDirectory = [ImageStackDirectory filesep];
    
    tic;
    fprintf('\n \n File Opening \n');
    
    % Structured retrieval of the list of files in the image directories
    fileList = dir(ImageStackDirectory);
    
    % Creating the name list of image files
    ImageList={};
    cnt=1;
    
    for i=1:size(fileList,1)
        % Removal of hidden files specific to Mac/Linux systems
        % starting with an. (., ... and .DS_Store)
        if ~strncmp(fileList(i,1).name,'.',1)
            ImageList{cnt,1}=fileList(i,1).name;
            cnt=cnt+1;
        end
    end
    %end
    
    % Reading DICOM information
    info_dicom=dicominfo(strcat(char(ImageStackDirectory), filesep, char(ImageList(1))));
    % collimation width recovery
    Collimation= getfield(info_dicom,'TotalCollimationWidth');
    
end


%% cutting of images according to the acquired series to build the matrix number_image, position

for i=1:length(ImageList)
    rootPath(i,:) = strsplit(char(ImageList(i)),'-');
end

% counting the number of series in the root folder
series_number=unique(rootPath(:,2));

groupNb = zeros(3,0);
for i = 1 : length(series_number)
    % groupe number research
    groupIndices =contains(rootPath(:, 2), series_number(i));
    if i >1
        groupNb(i) = groupNb(i-1)+ size(rootPath(groupIndices, :),1);
    else
        groupNb(i) = size(rootPath(groupIndices, :),1);
    end
end

% counter to know the number of images per series
structureline =1;
for j=1:length(series_number)
    if j==1
        partial_ImageList = ImageList(1:groupNb(j));
    else
        partial_ImageList = ImageList(groupNb(j-1)+1:groupNb(j));
    end
    % reading of images from the current series
    for i=1:size(partial_ImageList,1)
        
        % Retrieving the InstanceNumber and SliceLocation for each
        % image
        info_dicom=dicominfo(strcat(char(ImageStackDirectory), filesep, char(partial_ImageList(i))));
        
        examDetails(structureline).series_num = info_dicom.SeriesNumber;
        examDetails(structureline).slice_number = info_dicom.InstanceNumber;
        examDetails(structureline).slice_position = info_dicom.SliceLocation;
        structureline =structureline+1;
    end
    
end


%% transition from image possiblities to acquisition positions
% each smartstep acquisition consists of 3 images. It is therefore necessary to
% take image 2 then 5 then 8... to be in the center of each
% smartstep achieved


cnt=1;
for i=1:3:length(examDetails)
    pos_smartstep(cnt,:) = examDetails(i+1).slice_position;
    cnt=cnt+1;
end

%% definition of the histograms bins
min_range=min([examDetails.slice_position]);
max_range=max([examDetails.slice_position]);
range = abs(min_range - max_range);

nb_bin = range / Collimation;
nb_bin_abs_sup = ceil(nb_bin);
nb_bin_abs_inf = floor(nb_bin);

%% display of histograms for the positions of all images
% acquired in smartstep mode
figure
% hist_z_colli_inf=histogram(slice_position_total(:,end),nb_bin_abs_inf);
hist_z_colli_inf=histogram([examDetails.slice_position],nb_bin_abs_inf)
title('histogram of the z-positions of all images. the bin is equivalent to a collimation rounded down');

figure
hist_z_colli_sup=histogram([examDetails.slice_position],nb_bin_abs_sup);
title('histogram of the z-positions of all images. the bin is equivalent to a collimation rounded up');

%% display of histograms of the positions of all acquisitions
% in smartstep (1 position for 3 images)
figure
hist_z_colli_inf=histogram(pos_smartstep(:,end),nb_bin_abs_inf);
title('histogram of the z-positions of all smartstep/smartview positions. the bin is equivalent to a collimation rounded down');

figure
hist_z_colli_sup=histogram(pos_smartstep(:,end),nb_bin_abs_sup);
title('histogram of the z-positions of all smartstep/smartview positions. the bin is equivalent to a collimation rounded up');

