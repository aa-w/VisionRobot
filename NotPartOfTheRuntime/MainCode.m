cam = videoinput('winvideo', 1,'YUY2_320x240'); 

triggerconfig(cam,'manual'); %%sets the Frames Per Trigger function to higher frame rate

set(cam,'TimerPeriod',0.1);

set(cam,'FramesPerTrigger',Inf);

%%set(cam,'TimerFcn',@SetVideoObject);

figure,imshow(uint8(zeros(240, 320, 3)));

set(cam,'ReturnedColorspace','rgb')
cam.FrameGrabInterval = 5; %%an image is grabbed every 5 from the webcam

start(cam); %%grabs cam feed

while(cam.FramesAcquired <= 50)
    imagesnapshot = getsnapshot(cam); %%object stores data
    
    %%image processing
    reddiff = imsubtract(imagesnapshot(:,:,1),rgb2gray(imagesnapshot)); %%subtracts all red
    greendiff = imsubtract(imagesnapshot(:,:,2),rgb2gray(imagesnapshot)); %%subtracts all green
    bluediff = imsubtract(imagesnapshot(:,:,3),rgb2gray(imagesnapshot)); %%subtracts all blue

    
    reddiff = medfilt2(reddiff,[3,3]); %%removes noise from the background, makes it easier to detect
    bluediff = medfilt2(bluediff,[3,3]);
    greendiff = medfilt2(greendiff,[3,3]);
    
    reddiff = im2bw(reddiff,0.18); %%converts the results to binary data
    bluediff = im2bw(bluediff,0.18);
    greendiff = im2bw(greendiff,0.18);
    
    reddiff = bwareaopen(reddiff,300); %%gets rid of all pixles less than 300px to make it easier to recgonise
    bluediff = bwareaopen(bluediff,300);
    greendiff = bwareaopen(greendiff,300);
    
    %%create different image types
    bwr = bwlabel(reddiff,8);
    bwb = bwlabel(bluediff,8);
    bwg = bwlabel(greendiff,8);

    
    redregions = regionprops(bwr,'BoundingBox','Centroid');
    blueregions = regionprops(bwb,'BoundingBox','Centroid');
    greenregions = regionprops(bwg,'BoundingBox','Centroid');
    
    imshow(imagesnapshot); %%displays background image for debugging - just basic capture for overlay
    
    hold on
    
    for object = 1:length(redregions)
        
        bbr = redregions(object).BoundingBox;
        bcr = redregions(object).Centroid;
        
        rectangle('Position',bbr,'EdgeColor','r','LineWidth',2) %%draws a red rectangle around the object detected
        
        plot(bcr(2),'-m+')
        
    end %%for loop close
    
    hold off
    
    hold on
    
    for object = 1:length(blueregions)
        
        bbb = blueregions(object).BoundingBox;
        bcb = blueregions(object).Centroid;
    
        rectangle('Position',bbb,'EdgeColor','b','LineWidth',2) %%draws a blue rectangle around the object detected
        
        plot(bcb(2),'-m+')
        
    end %%for loop close
    
    hold off
    
    hold on
    
    for object = 1:length(greenregions)
        
        bbg = greenregions(object).BoundingBox;
        bcg = greenregions(object).Centroid;
    
        rectangle('Position',bbg,'EdgeColor','b','LineWidth',2) %%draws a green rectangle around the object detected
        
        plot(bcg(2),'-m+')
        
    end %%for loop close
    
    hold off
    
end %%while loop ended

stop(cam);

flushdata(cam); %%clears cam data from memory

