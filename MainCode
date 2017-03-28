cam = videoinput('winvideo', 1,'YUY2_320x240'); 

triggerconfig(cam,'manual');
set(cam,'TimerPeriod',0.1);
set(cam,'TimerFcn',@CamProcess);
figure,imshow(uint8(zeros(240, 320, 3)));

set(cam,'FramesPerTrigger',Inf);
set(cam,'ReturnedColorspace','rgb')
cam.FrameGrabInterval = 5;

start(cam);

while(cam.FramesAcquired  <= 100)
    
    store = getsnapshot(cam);
    
    red_diff = imsubtract(store(:,:,1),rgb2gray(store));
    
    red_diff = medfilt2(red_diff,[3,3]);
    
    red_diff = im2bw(red_diff,0.18);
    
    red_diff = bwareaopen(red_diff,300);
    
    bw = bwlabel(red_diff,8);
    
    stats = regionprops(bw,'BoundingBox','Centroid');
    
    imshow(store);
    
    hold on
    
    for object = 1 : length(stats)
        
        redbb = stats(object).BoundingBox;
        
        redbc = stats(object).Centroid;
        
        rectangle('Position',redbb,'EdgeColor','r','LineWidth',2)
        
        plot(redbb(1),redbc(2),'-m+')
        
    end
    
    hold off
    
end

stop(cam);

flushdata(cam);

clear all;
