function cars = findCars(im)
%filter images to find balls
imOG = im;

%Extract color channels.
red = im(:,:,1); % Red channel
green = im(:,:,2); % Green channel
blue = im(:,:,3); % Blue channel

%Filter image to only leave the colors of the balls
im = insertShape(im,'FilledRectangle',[0 0 1000 130],'Color', 'white','Opacity',1)

%Filter image to only leave the colors of the balls
[mask, im] = carMask(im);
im = rgb2gray(im);
im = edge(im, 'Canny');
im = imfill(im, 'holes');
im = imfilter(im, [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9]);
im = imfilter(im, [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9]);

SE = strel('sphere',3);
im = imerode(im, SE);
im = imerode(im, SE);

figure
imshow(im);


%find circles
[centers, radii, metric] = imfindcircles(im,[15 30],'ObjectPolarity','bright','Sensitivity',0.925);

%show images
figure
imshow(im);

figure()
imshow(imOG);
hold on
viscircles(centers, radii,'EdgeColor','b');
% Displays the color of the balls and create object for each ball
imColor = imOG;
numBalls = size(centers,1);
cars(1:numBalls) = ball;
bases(1:numBalls) = base;
%Make object for each ball and identify color
for i = 1:numBalls
    x = centers(i,1);
    y = centers(i,2);
    pixel = coordinates_to_pixel_num(x,y)
  
    if red(pixel) > green(pixel) && red(pixel) > blue(pixel)
        imColor = insertObjectAnnotation(imColor, 'rectangle',[(x-30) (y-30) 60 60], 'CAR');
        cars(i) = cars(i).makeBall(i, centers(i, 1), centers(i, 2), radii(i), 'c');
        bases(i) = bases(i).makeBase(centers(i, 1), centers(i, 2), 0, 'S');
        cars(i).base = bases(i);
    end   
end
figure()
imshow(imColor);
figure()

end