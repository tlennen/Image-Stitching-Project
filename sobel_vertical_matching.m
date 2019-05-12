function y = sobel_vertical_matching(image_A,image_B,threshold,name,min_edges)
    A = edge(image_A,'Canny');
    B = edge(image_B,'Canny');
    rows = size(A,1);
    columns = size(A,2);
    search_order = round(rows*.2):round(rows*.8);
    search_order = search_order(randperm(length(search_order)));
    % We are limiting the range of the stitching to get better quality
    % images (No point in stiching the first pixels of the image).
    % We are also randomizing the order to create "unique" photos.
    for i=search_order
        matched_edges = 0;
        total_edges = 0;
        for j=1:columns
            if A(i,j)==1 || B(i,j)==1
                total_edges = total_edges + 1;
                if A(i,j)==B(i,j)
                    matched_edges = matched_edges + 1;
                end
            end
        end
        if total_edges*threshold<=matched_edges && total_edges>min_edges
            AB = image_A;
            AB(i*2+1:end,:) = image_B(i*2+1:end,:);
            figure;
            imshow(AB);
            imwrite(AB,name,strcat(num2str(threshold),'threshold-sobel.jpg'));
            A(i+1:end,:) = B(i+1:end,:);
            imshow(A);
            imwrite(A,strcat(name,strcat(num2str(threshold),'threshold-sobel.jpg')));
            disp("Match!");
            y = 1;
            break; % end function
        end
    end
    y=0;
end