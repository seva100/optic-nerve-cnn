function [ arrayNames ] = convert_gs_to_image( inDir, outDir )


imgNames = dir(inDir);

arrayNames = [];

posCount = 1;
for i=1:2:length(imgNames)
    if (~imgNames(i).isdir)
%         load(fullfile(inDir, ['gs' num2str(posCount)]));
        img = imread(fullfile(inDir, imgNames(i + 1).name));
        fid = fopen(fullfile(inDir, imgNames(i).name));
        e = textscan(fid, '%s %s', 1);
        e = textscan(fid, '%s', 1, 'Delimiter', '\n');
        centro = textscan(fid, '%d %d', 1, 'Delimiter', '\n');
%         e = textscan(fid, '%s', 1, 'Delimiter', '\n');
        puntos = textscan(fid, '%d %d', 16, 'Delimiter', '\n');
%         imwrite(BW, fullfile(outDir, ['Im' num2str(posCount, '%03d') '-exp' num2str(expNum) '.bmp']));
        X1=interp([puntos{1}; puntos{1}(1)], 50);
        Y1=interp([puntos{2}; puntos{2}(1)], 50);
%         [~, ~, ~, BW2, ~, ~] = roifill(double(BW), X1, Y1);
        [~, ~, ~, BW2, ~, ~] = roifill(zeros(size(img(:,:,1))), X1(1:16*50), Y1(1:16*50));
	%[~, ~, ~, BW2, ~, ~] = roifill(zeros(size(img(:,:,1))), puntos{1}, puntos{2});
        extension = substr(imgNames(i).name, -4);
        imwrite(BW2, fullfile(outDir, strrep(imgNames(i).name, extension, '_mask.bmp')));
        posCount = posCount + 1;
    end
end

end

convert_gs_to_image('Normal', 'Normal segmentation');
convert_gs_to_image('Glaucoma and glaucoma suspicious', 'Glaucomatous segmentation');
