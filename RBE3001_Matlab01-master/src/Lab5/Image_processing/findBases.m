function bases = findBases(im)
    imOG = im;
    
    %Filter image to only leave the colors of the balls
    im = insertShape(im,'FilledRectangle',[0 0 1000 130],'Color', 'white','Opacity',1);
    
    [mask, im] = createMaskBase(im);
    
    im = rgb2gray(im);
    histeq(im, 3);
    
    figure(5)
    imshow(im);
    im = imbinarize(im);
    
    SE = strel('square', 1)
    im = imerode(im, SE);
    
    im = imfill(im, 'holes');
    
    im = imerode(im, SE);
    im = imerode(im, SE);
    
    im = imfill(im, 'holes');
    
    %find circles
    [centers, radii, metric] = imfindcircles(im,[37 66],'ObjectPolarity','bright','Sensitivity',0.85);

    %show images
    figure (6)
    imshow(im);

    hold on
    viscircles(centers, radii,'EdgeColor','b');
    % Displays the color of the balls and create object for each ball
    imBases = imOG;
    numBases = size(centers,1);
    bases(1:numBases) = base;
    %Make object for each ball and identify color
    for i = 1:numBases
        x = centers(i,1);
        y = centers(i,2);
        
        radius = radii(i) + (371 - y) * .054;
        
        if radius < 35
            imBases = insertObjectAnnotation(imBases, 'rectangle',[(x-30) (y-30) 60 60], 'IGNORE');
        elseif radius >= 35 && radius < 55
            imBases = insertObjectAnnotation(imBases, 'rectangle',[(x-30) (y-30) 60 60], 'SMALL');
            bases(i) = bases(i).makeBase(centers(i, 1), centers(i, 2), radius, 'S');
%         elseif radius >= 49 && radius < 57
%             imBases = insertObjectAnnotation(imBases, 'rectangle',[(x-30) (y-30) 60 60], 'MEDIUM');
%             bases(i) = bases(i).makeBase(centers(i, 1), centers(i, 2), radius, 'M');
        elseif radius >= 55
            imBases = insertObjectAnnotation(imBases, 'rectangle',[(x-30) (y-30) 60 60], 'LARGE');
            bases(i) = bases(i).makeBase(centers(i, 1), centers(i, 2), radius, 'L');
        end 
    end
    figure(7)
    imshow(imBases);

end