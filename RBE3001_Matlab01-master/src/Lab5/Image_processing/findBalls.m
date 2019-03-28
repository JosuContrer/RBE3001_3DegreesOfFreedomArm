function balls = findBalls(im)
%filter images to find balls
imOG = im;

%Extract color channels.
red = im(:,:,1); % Red channel
green = im(:,:,2); % Green channel
blue = im(:,:,3); % Blue channel

%Filter image to only leave the colors of the balls
[mask, im] = createMask3(im);
figure(8)
imshow(im);

im = rgb2gray(im);
im = edge(im, 'Canny');
im = imfill(im, 'holes');
im = imfilter(im, [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9]);
im = imfilter(im, [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9]);

%find circles
[centers, radii, metric] = imfindcircles(im,[20 30],'ObjectPolarity','bright','Sensitivity',0.925);

%show images
figure (2)
imshow(im);

figure(3)
imshow(imOG);

viscircles(centers, radii,'EdgeColor','b');
% Displays the color of the balls and create object for each ball
imColor = imOG;
numBalls = size(centers,1);
balls(1:numBalls) = ball;
%Make object for each ball and identify color
for i = 1:numBalls
    x = centers(i,1);
    y = centers(i,2);
    pixel = coordinates_to_pixel_num(x,y)
  
    if green(pixel) > blue(pixel) && red(pixel) > blue(pixel)
        imColor = insertObjectAnnotation(imColor, 'rectangle',[(x-30) (y-30) 60 60], 'YELLOW');
        balls(i) = balls(i).makeBall(i, centers(i, 1), centers(i, 2), radii(i), 'y');
    elseif red(pixel) > green(pixel) && red(pixel) > blue(pixel)
        pause(1);
%        balls(i) = balls(i).makeBall(0, centers(i, 1), centers(i, 2), radii(i), 'r'); %all red balls have id '0'
%       imColor = insertObjectAnnotation(imColor, 'rectangle',[(x-30) (y-30) 60 60], 'IGNORE');
    elseif  green(pixel) > red(pixel) && green(pixel) > blue(pixel)
        imColor = insertObjectAnnotation(imColor, 'rectangle',[(x-30) (y-30) 60 60], 'GREEN');
        balls(i) = balls(i).makeBall(i, centers(i, 1), centers(i, 2), radii(i), 'g');
      
    elseif blue(pixel) > green(pixel) && blue(pixel) > red(pixel)
        imColor = insertObjectAnnotation(imColor, 'rectangle',[(x-30) (y-30) 60 60], 'BLUE');
        balls(i) = balls(i).makeBall(i, centers(i, 1), centers(i, 2), radii(i), 'b');
    end   
end
figure(4)
imshow(imColor);


end