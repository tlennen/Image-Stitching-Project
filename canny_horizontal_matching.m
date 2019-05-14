function y = canny_horizontal_matching(image_A,image_B,threshold,name,min_edges)
    A = edge(image_A,'Canny');
    B = edge(image_B,'Canny');
    % call for edge detected image
    rows = size(A,1);
    search_order = round(rows*.2):round(rows*.8);
    search_order = search_order(randperm(length(search_order)));
    % We are limiting the range of the stitching to get better quality
    % images (No point in stiching the first pixels of the image).
    % We are also randomizing the order to create "unique" photos.
    for i=search_order
        matched_edges = 0;
        total_edges = 0;
        % count total and matched edge points
        for j=1:rows
            if A(j,i)==1 || B(j,i)==1
                total_edges = total_edges + 1;
                if A(j,i)==B(j,i)
                    matched_edges = matched_edges + 1;
                end
            end
        end
        % check if edge points meet thresholds for stitching
        if total_edges*threshold<=matched_edges && total_edges>min_edges
            AB = image_A;
            AB(:,i+1:end) = image_B(:,i+1:end);
            figure;
            imshow(AB);
            imwrite(AB,strcat(name,'horizontal-canny.jpg'));
            % Save stitched image
            A(:,i+1:end) = B(:,i+1:end);
            imshow(A);
            imwrite(A,strcat(name,'edge-horizontal-canny.jpg'));
            % Save stitched edge image.
            disp("Match!");
            y = 1;
            break; % end function
        end
    end
    y=0;
end