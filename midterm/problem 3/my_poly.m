function y = my_poly(w, x, v)
%MY_POLY calculate y from w'x + v

y = (w(1) * (x^3)) + (w(2) * (x^2)) + (w(3) * x) + w(4) + v;
end

