function y = canny_vertical_matching(image_A,image_B,threshold,name,min_edges)
    A = edge(image_A,'Canny');
    B = edge(image_B,'Canny');
    % call for edge detected image
    columns = size(A,2);
    search_order = round(columns*.2):round(columns*.8);
    search_order = search_order(randperm(length(search_order)));
    % We are limiting the range of the stitching to get better quality
    % images (No point in stiching the first pixels of the image).
    % We are also randomizing the order to create "unique" photos.
    for i=search_order
        matched_edges = 0;
        total_edges = 0;
        % count total and matched edge points
        for j=1:columns
            if A(i,j)==1 || B(i,j)==1
                total_edges = total_edges + 1;
                if A(i,j)==B(i,j)
                    matched_edges = matched_edges + 1;
                end
            end
        end
        % check if edge points meet thresholds for stitching
        if total_edges*threshold<=matched_edges && total_edges>min_edges
            AB = image_A;
            AB(i+1:end,:) = image_B(i+1:end,:);
            figure;
            imshow(AB);
            imwrite(AB,strcat(name,'vertical-canny.jpg'))
            % Save stitched image
            BA = image_B;
            BA(i+1:end,:) = image_A(i+1:end,:);
            figure;
            imshow(BA);
            imwrite(BA,strcat(name,'other-vertical-canny.jpg'));
            % Save opposite stitched image
            edge_A = A;
            edge_A(i+1:end,:) = B(i+1:end,:);
            imshow(edge_A);
            imwrite(edge_A,strcat(name,'edge-vertical-canny.jpg'));
            % Save stitched edge image
            edge_B = B;
            edge_B(i+1:end,:) = A(i+1:end,:);
            imshow(edge_B);
            imwrite(edge_B,strcat(name,'other-edge-vertical-canny.jpg'));
            % Save stitched edge image
            disp("Match!");
            y = 1;
            break; % end function
        end
    end
    y=0;
end