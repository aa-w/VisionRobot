function CamProcess(vid,event)
       tic    
       
       imageData = peekdata(vid, 1);
       
       imageHandle = get(gca,'Children');
       
       set(imageHandle, 'CData',imageData);
       
       toc
end
