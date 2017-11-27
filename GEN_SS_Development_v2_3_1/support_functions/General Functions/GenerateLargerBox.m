function [box_out, ture_here]=GenerateLargerBox(box, s)
%     s=1.5;
    x1 = box(1) - box(3)*(s-1);
    y1 = box(2) - box(4)*(s-1);
    x1 = max(0.0, x1);
    y1 = max(0.0, y1);
	w1 = box(3)*(s*2-1);
	h1 = box(4)*(s * 2 -1);
    box_out=[x1, y1, w1, h1];
    ture_here=[box(1)-x1,box(2)-y1,box(3),box(4)];
end