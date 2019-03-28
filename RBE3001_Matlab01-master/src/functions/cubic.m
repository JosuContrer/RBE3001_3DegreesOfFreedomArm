%return coefficeitints of cubic polynomial
function A = cubic(t0, t1, v0, v1, p0, p1)
    M = [1 t0 t0^2 t0^3;
        0 1 (2*t0) (3*t0^2);
        1 t1 (t1^2) (t1^3);
        0 1 (2*t1) (3*t1^2)];
    
    A = M \ [p0; v0; p1; v1];
end