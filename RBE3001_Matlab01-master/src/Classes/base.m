classdef base
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pixelRadius %radius of ball in pixles
        pixelCenter %center in pixel coordinates
        worldCenter
        worldRadius
        size
    end
    
    methods
        function obj = makeBase(obj, pixelX, pixelY, pixelRadius, size)
            if nargin == 5
                [obj.pixelCenter] = [pixelX, pixelY];
                [obj.pixelRadius] = pixelRadius;
                [obj.size] = size;
            else
                error("not enough input arguments");
            end
        end
        
        function obj = getWorldDim(obj, cameraParams, R, t, t0check)
            obj.worldCenter = pointsToWorld(cameraParams, R, t, obj.pixelCenter);
            obj.worldCenter(1) = (-1*obj.worldCenter(1)) + 104;
            obj.worldCenter(2) = -1*(obj.worldCenter(2) + 100);
            %[obj.worldCRadius] = pointsToWorld(cameraParams, R, t, [obj.pixelRadius]);
        end
    end
    
end

