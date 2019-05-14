% Extra Credit MATLAB Project for CSE185
% By Tyler Lennen and Charles Chung

% The purpose of this project is to see if we can use edge detection to
% combine two random photos and see if they can create one "visually
% pleasing" photo, where the edges match.

% Stage 1, using Canny edge detector to match an inverted photo with its
% original photo. We assume for now that they are the same size.


test_image1 = 'black_arrow.tif';

I = imread(test_image1);
imwrite(I,test_image1);
inverseGrayImage = uint8(255) - I;
A = edge(I,'Canny');
imshow(A);
figure;
B = edge(inverseGrayImage,'Canny');
imshow(B);
% The image edges are the exact same so we can attempt our test
imwrite(inverseGrayImage, strcat('inverted_',test_image1));
name = strcat('./stitched',test_image1,'_plus_',strcat('inverted_',test_image1));
canny_vertical_matching(I,inverseGrayImage,.8,name,2);
% The phase is a success!


% Stage 2, getting two completely different images to match up.

% This segment of code takes in new datasets of images and converts them to
% a universal grayscale format. It also renames all the files as numbers.
% For this project, all images are 500 by 500.

myFolder = './new_images';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  % converts images to grayscale and resize to 500 by 500
  if size(imageArray,3)==3
     imageArray = rgb2gray(imresize(imageArray,[500, 500])); 
  else
     imageArray = imresize(imageArray,[500, 500]); 
  end
  imwrite(imageArray,strcat('./images/',strcat(strcat('image-',num2str(k))),'.jpg'));
  imshow(imageArray);  % Display image.
  drawnow; % Force display to update immediately.
end

% Function for matching images with canny, check stitched folder to see the output
% images.
matches_images_folder(0.5,10,'canny');

% matches_images_folder(0.7,10,'canny');
% The line above produces no results, which means that the threshold is too
% high and it fails.

% Stage 3 Sobel filters with pooling

% Function for matching images with sobel, check stitched folder to see the output
% images.
matches_images_folder(0.6,10,'sobel');

% matches_images_folder(0.8,10,'sobel');
% The line above produces no results, which means that the threshold is too
% high and it fails.