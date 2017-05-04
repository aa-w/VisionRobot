cam = videoinput('winvideo', 1,'YUY2_320x240'); %Defines the input source type using a handle

triggerconfig(cam,'manual'); %%sets the Frames Per Trigger function to higher frame rate
set(cam,'TimerPeriod',0.1); %Manually sets the amount of time between frames, for better debugging and faster feedback
set(cam,'FramesPerTrigger',Inf); 
figure,imshow(uint8(zeros(240, 320, 3)));

set(cam,'ReturnedColorspace','rgb') %%sets the color space of the camera source using the handle
cam.FrameGrabInterval = 5; %%an image is grabbed every 5 from the webcam

start(cam); %%grabs cam feed

%timer for the while loop
CloseTime = datenum(clock + [0, 0, 0, 0, 1, 0]); %set time using the system clock to base from

while(datenum(clock)  < CloseTime)
    imagesnapshot = getsnapshot(cam); %%object stores data
    
    %%image processing
    reddiff = imsubtract(imagesnapshot(:,:,1),rgb2gray(imagesnapshot)); %%subtracts all red
    reddiff = medfilt2(reddiff,[3,3]); %%removes noise from the background, makes it easier to detect
    reddiff = im2bw(reddiff,0.18); %%converts the results to binary data
    reddiff = bwareaopen(reddiff,300); %%gets rid of all pixles less than 300px to make it easier to recgonise
    bwr = bwlabel(reddiff,8);
    redregions = regionprops(bwr,'BoundingBox','Centroid');
    
    bluediff = imsubtract(imagesnapshot(:,:,3),rgb2gray(imagesnapshot)); %%subtracts all blue from the image
    bluediff = medfilt2(bluediff,[3,3]);
    bluediff = im2bw(bluediff,0.18);
    bluediff = bwareaopen(bluediff,300);
    bwb = bwlabel(bluediff,8); %create different image types
    blueregions = regionprops(bwb,'BoundingBox','Centroid');
    
    imshow(imagesnapshot); %%displays background image for debugging - just basic capture for overlay
    
    hold on %Holds the current axes on the image to place the red elements
    for object = 1:length(redregions) %runs on each element of the red binarized image
        bbr = redregions(object).BoundingBox; %draws a rectangle around the edges of each object
        bcr = redregions(object).Centroid; %Gets the center of each object
        rectangle('Position',bbr,'EdgeColor','r','LineWidth',2) %Draws a rectangle around each object
        plot(bcr(2),'-m+') %Plots the result on to the original imagesnapshot
    end %%for loop close
    hold off %Resumes
    
    hold on %Holds the current axes on the image to place the Blue elements
    for object = 1:length(blueregions) %Repeats object drawing process used for the red object but witht the blue binarized image
        bbb = blueregions(object).BoundingBox;
        bcb = blueregions(object).Centroid;
        rectangle('Position',bbb,'EdgeColor','b','LineWidth',2) %%draws a blue rectangle around the object detected
        plot(bcb(2),'-m+')
        
    end %%for loop close
    hold off
    
end %while loop ended

stop(cam);
flushdata(cam); %%clears cam data from memory
close all;
