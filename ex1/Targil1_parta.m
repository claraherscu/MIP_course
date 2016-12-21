clc;
clear;

%Loop through the directory
files = dir('D:\Github\PhD-Research\Targil_1_data\data\*CTce_ThAb.nii.gz');
figure;
j=1;
for file = files'
    
    disp(['Loading ' file.name]);
    %Loading the nifity file 
    niistruct=load_untouch_nii_gzip(['D:\Github\PhD-Research\Targil_1_data\data\' file.name]);
    
        %when the values are between 1300 to 150 it will put 1 otherwise 0
    labels_to_plot = zeros(1,71);
    for i = 150:5:500
        temp_image = (niistruct.img <1300 & niistruct.img>i); 

        %Connected dots 
        %Label connected components in binary image.
        labels = bwlabeln(temp_image,26);

        %Finding the max in 3d matrix
        number_of_labels = max(labels(:));
        
        labels_to_plot((i-145)/5) = number_of_labels;
    end
    
    
    %[abs_min_y, abs_min_x] = min(labels_to_plot); 
    inverted_labels = labels_to_plot*-1;
    [all_min_y, all_min] = findpeaks(inverted_labels);
    all_min_y = all_min_y*-1;
    
    [local_min_y, local_min_x ] = min(all_min_y(1:3)); 
    
    abs_min_y= all_min_y(local_min_x);
    abs_min_x = all_min(local_min_x);
    
    %Plotting
    x = [150:5:500];
    subplot(2,3,j);
    j=j+1;
    plot(x,labels_to_plot);
    title(file.name);
    hold on; 
    plot(x(abs_min_x),abs_min_y,'r*');
    
    
    
    hold off;
   
    temp_image = (niistruct.img <1300 & niistruct.img>x(abs_min_x));
    
    %Dilate function and erode function are morphology operations to clear
    %up the flowing voids (falses) 
    SE = strel('cube',10);
    dilated_image = imdilate(temp_image,SE);
    temp_image = imerode(dilated_image,SE);
    
    %Saving (creating) the new Nifity files, aka segmentation 
    niistruct.img = temp_image;     
    new_file_name = strrep(file.name, 'CTce_ThAb', 'BoneSeg');
    save_untouch_nii_gzip(niistruct,['D:\Github\PhD-Research\Targil_1_data\data\' new_file_name]);
end






