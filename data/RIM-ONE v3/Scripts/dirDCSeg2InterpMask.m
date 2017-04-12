function dirDCSeg2InterpMask( imgDir, dcSegDir, outDir, expertStr )
% This function converts the segmentations of DCSeg contained in a
% directory to interpolated binary masks. It saves the results in outDir.
%   imgDir: the directory containing the original image files
%   dcSegDir: the directory containing the DCSeg text files (it can be the
%       same as imgDir). It will try to use any txt file that matches an
%       image file name as a DCSeg segmentation.
%   outDir: the directory to save the results to (it will be created if it
%       doesn't exist)
%   expertStr: (optional; can be empty string '' or empty array [])
%       this can be used to change the user name by another string, for
%       example 'exp1'. In this case, all the segmentations in the dcSegDir
%       should have been carried out by the same user. If left blank or
%       empty, the user name will not be changed.

files = dir(fullfile(imgDir, '*.jpg'));
mkdir(outDir)
for i = 1:length(files)
    imgName = files(i).name;
    disp(imgName);
    segs = dir(fullfile(dcSegDir, [imgName(1:end-4) '*.txt']));
    if ~isempty(segs)
        for j = 1:length(segs)
            segstr = segs(j).name;
            try
                [ ~, mask ] = DCSeg2InterpMask( fullfile(imgDir, imgName), fullfile(dcSegDir, segstr));
                
                if ~isempty(expertStr) && ~strcmpi(expertStr, '')
                    pos = strfind(segstr, '-');    % the last position will be the last '-', i.e., just before the user name
                    posExt = strfind(segstr, '.');  % the last position will be the last '.', i.e., just before the extension
                    % Concatenates the segmentation file name (without the user
                    % name) with the expertStr and the file extension
                    segstr = [segstr(1:pos(end)) expertStr segstr(posExt(end):end)];
                end
            
                save(fullfile(outDir, [segstr(1:end-4) '.mat']), 'mask');
                imwrite(mask, fullfile(outDir, [segstr(1:end-4) '.png']));
            catch err
                disp(err)
            end
        end
    end
end


end