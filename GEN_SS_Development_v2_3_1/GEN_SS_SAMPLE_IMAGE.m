function SA_box=GEN_SS_SAMPLE_IMAGE(img_size, previous_BB, SA_multiplier)
% Create Search Area BB and Check that it is in Bounds
[SA_box, ~]=GenerateLargerBox(previous_BB, SA_multiplier);
SA_box_x_max=SA_box(1)+SA_box(3);
SA_box_y_max=SA_box(2)+SA_box(4);

% Check that SA is  within image bounds
if SA_box(1) < 1
    SA_box(1)=1;
end
if SA_box(2) < 1
    SA_box(2)=1;
end

if SA_box(1) > img_size(2) || SA_box_x_max > img_size(2)
    if SA_box(3)<img_size(2)
        SA_box(1)=img_size(2)-SA_box(3);
    else
        SA_box(1)=1;
        SA_box(3)=img_size(2);
    end
end
if SA_box(2) > img_size(1) || SA_box_y_max > img_size(1)
    if SA_box(4)<img_size(1)
        SA_box(2)=img_size(1)-SA_box(4);
    else
        SA_box(2)=1;
        SA_box(4)=img_size(1);
    end
end
end