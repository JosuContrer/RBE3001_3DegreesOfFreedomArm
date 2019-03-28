function pixelNum = coordinates_to_pixel_num(x_coord,y_coord)
    x_coord = floor(x_coord);
    y_coord = floor(y_coord);
    pixelNum = y_coord + (483*(x_coord - 1));
end
