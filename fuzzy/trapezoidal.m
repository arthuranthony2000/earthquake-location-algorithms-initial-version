function pertinence = trapezoidal(value, params)
a = params(1);
b = params(2);
c = params(3);
d = params(4);

pertinence = max(0, min([max(0, (value - a) / (b - a)), 1, max(0, (d - value) / (d - c))]));
end