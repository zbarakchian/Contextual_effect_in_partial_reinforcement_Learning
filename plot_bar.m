function plot_bar(varargin)

if nargin == 2
    value  = varargin{1};
    tit    = varargin{2};
else
    value  = varargin{1};
    tit    = varargin{2};
    yrange = varargin{3};
    
    ylim(yrange);

end

figure; 
bar(value);
title(strcat(tit));
