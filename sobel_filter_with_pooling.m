function [pool_A,pool_B] = sobel_filter_with_pooling(image_A,image_B)
   A = edge(image_A,'sobel');
   B = edge(image_B,'sobel');
   pool_A = zeros(floor(size(A,1)/2),floor(size(A,2)/2));
   pool_B = zeros(floor(size(A,1)/2),floor(size(A,2)/2));
   % Max pooling with a 2x2 filter
   for i=1:2:size(A,1)-2
       for j=1:2:size(A,2)-2
           x = floor(i/2)+1;
           y = floor(j/2)+1;
           pool_A(x,y) = max(max(max(A(i,j),A(i+1,j)),A(i+1,j+1)),A(i,j+1));
           if pool_A(x,y) <0.4 % threshold for sobel
               pool_A(x,y) = 0;
           end
           pool_B(x,y) = max(max(max(B(i,j),B(i+1,j)),B(i+1,j+1)),B(i,j+1));
           if pool_B(x,y) <0.4
               pool_B(x,y) = 0;
           end
       end
   end
end