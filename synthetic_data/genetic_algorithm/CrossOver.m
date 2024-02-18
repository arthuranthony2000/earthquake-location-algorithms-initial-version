function [children_1, children_2] = CrossOver(parent_1, parent_2)
    sigma = rand(size(parent_1));
    children_1 = sigma.*parent_1 + (1-sigma).*parent_2;
    children_2 = sigma.*parent_2 + (1-sigma).*parent_1;
end