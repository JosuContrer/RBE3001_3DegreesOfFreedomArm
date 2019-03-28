function Pdot = difkin(q, qDot)
    Pdot = jacob0(q(1), q(2), q(3)) * [qDot(1); qDot(2); qDot(3)];
end