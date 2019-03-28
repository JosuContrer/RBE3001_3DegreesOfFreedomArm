classdef ball
    
    properties
        color %color pf ball
        pixelRadius %radius of ball in pixles
        pixelCenter %center in pixel coordinates
        worldCenter
        worldRadius
        base
        id
    end
    
    methods
        function obj = makeBall(obj, id, pixelX, pixelY, pixelRadius, color)
            if nargin == 6
                [obj.id] = id;
                [obj.pixelCenter] = [pixelX, pixelY];
                [obj.pixelRadius] = pixelRadius;
                [obj.color] = color;
            else
                error("not enough input arguments");
            end
        end
        
        function obj = getWorldDim(obj, cameraParams, R, t, tcheck0)

            xy = pointsToWorld(cameraParams, R, t, obj.pixelCenter);
            coordinates = tcheck0 * [xy(1); xy(2); 0; 1];
            obj.worldCenter = [coordinates(1) coordinates(2)];
            %[obj.worldCRadius] = pointsToWorld(cameraParams, R, t, [obj.pixelRadius]);
        end
    end
    
end
