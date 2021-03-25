function colors = setup_colors()

%% Partial

%-scatter and error
%--------------------------------------------------------------------------
colors.Partial.scatter              = [200 200 200]/255; %[192,192,192]/255; %[.5 .5 .5];%[75,0,130]/255; %colors.real_er_color;%[47,79,79]/255;
colors.Partial.error                = [0.3 0.3 0.3]; %[.5 .5 .5];

%-real data
%--------------------------------------------------------------------------
colors.Partial.real.A1.face         = [76 153 0]   /255; %[220,20,60]   /255;
colors.Partial.real.A2.face         = [0 102 0]     /255; %[72,209,204]  /255;
colors.Partial.real.B.face          = [128 255 0]  /255;
colors.Partial.real.C.face          = [153 255 153]   /255; %[50,205,50]   /255;

    
%-fake data
%--------------------------------------------------------------------------
colors.Partial.fake.A1.face         = colors.Partial.real.A1.face;% + (1-colors.Partial.real.A1.face)*0.1; %[0 0 102]/255;
colors.Partial.fake.A2.face         = colors.Partial.real.A2.face; %[34,139,34]  /255; 
colors.Partial.fake.B.face          = colors.Partial.real.B.face;  %[255,255,0]  /255; 
colors.Partial.fake.C.face          = colors.Partial.real.C.face;  %[0,250,154]  /255;

colors.Partial.fake.A1.edge         = colors.Partial.fake.A1.face;
colors.Partial.fake.A2.edge         = colors.Partial.fake.A2.face;
colors.Partial.fake.B.edge          = colors.Partial.fake.B.face;
colors.Partial.fake.C.edge          = colors.Partial.fake.C.face;

%-model
%--------------------------------------------------------------------------
colors.Partial.model.A1.face        = [102 0 51]/255; %[0 0 0];
colors.Partial.model.B.face         = [153 0 76]/255; %[0 0 0];
colors.Partial.model.A2.face        = [51 0 102]/255; %[0 0 0];
colors.Partial.model.C.face         = [102 0 204]/255; %[0 0 0];

%% Complete

%-scatter and error
%--------------------------------------------------------------------------
colors.Complete.scatter             = colors.Partial.scatter;
colors.Complete.error               = colors.Partial.error;

%-real data
%--------------------------------------------------------------------------
colors.Complete.real.A1.face        = [204 102 0]   /255; %[220,20,60]   /255;
colors.Complete.real.A2.face        = [102 51 0]     /255; %[72,209,204]  /255;
colors.Complete.real.B.face         = [255,153,51]  /255;
colors.Complete.real.C.face         = [255 204 153]   /255; %[50,205,50]   /255;


%-fake data
%--------------------------------------------------------------------------
colors.Complete.fake.A1.face        = colors.Complete.real.A1.face; 
colors.Complete.fake.A2.face        = colors.Complete.real.A2.face; 
colors.Complete.fake.B.face         = colors.Complete.real.B.face;  
colors.Complete.fake.C.face         = colors.Complete.real.C.face;  

colors.Complete.fake.A1.edge        = colors.Complete.fake.A1.face;
colors.Complete.fake.A2.edge        = colors.Complete.fake.A2.face;
colors.Complete.fake.B.edge         = colors.Complete.fake.B.face;
colors.Complete.fake.C.edge         = colors.Complete.fake.C.face;

%-model
%--------------------------------------------------------------------------
colors.Complete.model.A1.face        = [51 0 51]/255; %[0 0 0];
colors.Complete.model.B.face         = [51 0 102]/255; %[0 0 0];
colors.Complete.model.A2.face        = [51 0 51]/255; %[0 0 0];
colors.Complete.model.C.face         = [51 0 102]/255; %[0 0 0];


%-pure simulation
%--------------------------------------------------------------------------
c = [0 0 0]; %[96 96 96]/255;%[0.5 0.5 0.5]
colors.Partial.puresim  = c;
colors.Complete.puresim = c;


%baseline: 229 204 255; ...
% colors2 = [ ...           
%             051 051 255
%             178 102 255; ...   
%             127 000 255; ...   
%             102 000 204; ...   
%             076 000 153; ...   
%           ]./255;
