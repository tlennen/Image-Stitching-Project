function y = matches_images_folder(threshold,min_edges,type)
    % Read in all images
    myFolder = './images';
    if ~isdir(myFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    filePattern = fullfile(myFolder, '*.jpg');
    jpegFiles = dir(filePattern);
    count = 1;
    total = (length(jpegFiles)+1)*(length(jpegFiles))/2;
    % Select function type for parallel computing
    if type == 'canny'
    	funcs1 = {@canny_vertical_matching, @canny_horizontal_matching} ;   % let fun1, fun2 be two functions 
    end
    if type == 'sobel'
    	funcs1 = {@sobel_vertical_matching, @sobel_horizontal_matching} ;   % let fun1, fun2 be two functions 
    end
    % Run stitching algorithm on every image combination
    for i = 1:length(jpegFiles)
        firstImgName = jpegFiles(i).name;
        firstArr = imread(strcat('./images/',firstImgName));
        for j=i+1:length(jpegFiles)
          secondImgName = jpegFiles(j).name;
          secondArr = imread(strcat('./images/',secondImgName));
          name = strcat('./stitched/',firstImgName,'_plus_',secondImgName);
          arguments = {firstArr,secondArr,threshold,name,min_edges;firstArr,secondArr,threshold,name,min_edges} ;   % write the inputs of each function
          % use of parfor 
          % Runs horizontal and vertical image stitching in parallel
          parfor ii = 1:2
            funcs1{ii}(arguments{ii,:});
          end
          disp(strcat(strcat('Pairs processed: ', int2str(count)),strcat('/',int2str(total))));
          count=count+1;
        end
    end
end