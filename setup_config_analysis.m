function config = setup_config_analysis(type,addr,ftype,varargin)
% ('real',addr,ftype);
% ('fake',addr,ftype,config_sim,model);


switch type
    case 'real'
        config_main = varargin{1};

        filename = [addr.bhv filesep 'data_'  ftype  '_Learning'];
        load(filename);  %info_learning
        filename = [addr.bhv filesep 'data_'  ftype, '_Transfer'];
        load(filename);  %info_transfer
        filename = [addr.bhv filesep 'data_'  ftype, '_Estimation'];
        load(filename);  %info_estimation 
        
        addr        = addr.bhv;
        nametosave  = type;
        model       = [];
        
    case 'fake'
        config_sim  = varargin{1};
        model       = varargin{2};
        
        filename    = [config_sim.addr filesep config_sim.simtype ,'_level2', '_', ftype];
        load(filename);
        learning    = level2.(model.name).learning;
        transfer    = level2.(model.name).transfer.greedy;
        
        %-convert the level2 structure to level1 structure: remove stds
        fields = fieldnames(learning);
        for i = 1:length(fields)
            info_learning.(fields{i}) = learning.(fields{i}).mean;
        end
        
        fields = fieldnames(transfer);
        for i = 1:length(fields)
            info_transfer.(fields{i}) = transfer.(fields{i}).mean;
        end
        
        %convert it to 0 1...because it is average of simulation
        for i = 1:size(info_transfer.pref.first_left,1)
            for j = 1:size(info_transfer.pref.first_left,2)
                if      info_transfer.pref.first_left(i,j) > 0.5
                    info_transfer.pref.first_left(i,j) = 1;
                elseif  info_transfer.pref.first_left(i,j) < 0.5
                    info_transfer.pref.first_left(i,j) = 0;
                elseif  info_transfer.pref.first_left(i,j) == 0.5
                    info_transfer.pref.first_left(i,j) = 0;%2-randi(2);
                end
            end
        end
        
        for i = 1:size(info_transfer.pref.first_right,1)
            for j = 1:size(info_transfer.pref.first_right,2)
                if      info_transfer.pref.first_right(i,j) > 0.5
                    info_transfer.pref.first_right(i,j) = 1;
                elseif  info_transfer.pref.first_right(i,j) < 0.5
                    info_transfer.pref.first_right(i,j) = 0;
                elseif  info_transfer.pref.first_right(i,j) == 0.5
                    info_transfer.pref.first_right(i,j) = 1 - info_transfer.pref.first_left(i,j);
                end
            end
        end
        
        info_estimation = nan;
        nametosave = [type, '_', config_sim.simtype, '_', model.name];
        addr = [];
end

config.type            = type;
config.nametosave      = nametosave;
config.model           = model;
config.addr            = addr;
config.info_learning   = info_learning;
config.info_transfer   = info_transfer;
config.info_estimation = info_estimation;



