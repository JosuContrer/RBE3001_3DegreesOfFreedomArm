function T = interp(origin,destination,numPoints)
    difference = destination - origin;
    inter = difference/numPoints;
    T = zeros(numPoints,3);
    for x = 1:numPoints
        Y= origin + (x*inter)
        T(x,1) = Y(1);
        T(x,2) = Y(2);
        T(x,3) = Y(3);
    end
            