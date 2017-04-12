function printTestResult( p, testStr )
%PRINTTESTRESULT Print the result of a t-test according to its p-value.
% Parameters:
%   p: the p-value of the t-test
%   testStr: the string to be showed with the result of the test

if p >= 0.05
    disp(['No significant differences have been found between ' testStr ' (two-sample t-test, p = ' num2str(p, '%0.5f') ')' ]);
else
    if p < 0.0001
        pstr = '0.0001';
    elseif p < 0.001
        pstr = '0.001';
    elseif p < 0.01
        pstr = '0.01';
    elseif p < 0.05
        pstr = '0.05';
    end
    disp(['Significant differences have been found between ' testStr ' (two-sample t-test, p < ' pstr ')' ]);
end

end

