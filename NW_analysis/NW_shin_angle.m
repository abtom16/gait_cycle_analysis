clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right'
[nw_paths, filenames] = getSubjectData(target_foot);

save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\ShinAngle';
target_filename = '_shin-NW.png';


% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
DR_MEAN_COLOR = [0 0 0.7];
DR_RANGE_COLOR = [0.4 0.6 1];

%%  data calculation for each procedure
uniform_length = 100;

% NW
for p_idx = 1:2:length(nw_paths)
    all_nw_resampled_angles = [];
    all_unaffected_footoff_timing = [];
    all_unaffected_contact_timing = [];
    all_affected_footoff_timing = [];

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        foot_side='LFoot';
        knee_side = 'LKnee';
        current_unaffected_contact = nw_Rcontact_frame;
        current_unaffected_footoff = nw_Rcontact_end_frame;
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        foot_side='RFoot';
        knee_side = 'RKnee';
        current_unaffected_contact = nw_Lcontact_frame;
        current_unaffected_footoff = nw_Lcontact_end_frame;
    end

    for j = 1:length(current_nw_contact_frame)-1
        [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
            getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
            all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
            current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

        current_cycle_foot_x = current_nw_data.(foot_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_x = current_nw_data.(knee_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_z = current_nw_data.(knee_side).z( ...  
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
        
        shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
        shin_angle_deg = rad2deg(shin_angle_rad);
        shin_angle = 90 - shin_angle_deg;  % 地面と垂直を0degにしたい
       
        original_x = linspace(0, 1, length(shin_angle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, shin_angle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
    if strcmp(target_foot, 'Left') || strcmp(target_foot, 'Right')
        if p_idx + 1 <= length(nw_paths)
            current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
            [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
                detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
            
            if strcmpi(target_foot, 'Left')
                current_nw_contact_frame = nw_Lcontact_frame;
                current_nw_contact_end_frame = nw_Lcontact_end_frame;
                foot_side='LFoot';
                knee_side = 'LShank';
                current_unaffected_contact = nw_Rcontact_frame;
                current_unaffected_footoff = nw_Rcontact_end_frame;
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
                foot_side='RFoot';
                knee_side = 'RShank';
                current_unaffected_contact = nw_Lcontact_frame;
                current_unaffected_footoff = nw_Lcontact_end_frame;
            end
        
            for j = 1:length(current_nw_contact_frame)-1
                [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
                    getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
                    all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
                    current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

                current_cycle_foot_x = current_nw_data.(foot_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_shank_x = current_nw_data.(knee_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_shank_z = current_nw_data.(knee_side).z( ...  %
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
                
                shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
                shin_angle_deg = rad2deg(shin_angle_rad);
                shin_angle = 90 - shin_angle_deg;  % 地面と垂直を0degにしたい
        
                original_x = linspace(0, 1, length(shin_angle));
                uniform_x_temp = linspace(0, 1, uniform_length);
                resampled_cycle = interp1(original_x, shin_angle, uniform_x_temp);
                
                all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
            end
        end
    end
    mean_unaffected_footoff_timing = mean(all_unaffected_footoff_timing, 'omitnan');
    mean_unaffected_contact_timing = mean(all_unaffected_contact_timing, 'omitnan');
    mean_affected_footoff_timing = mean(all_affected_footoff_timing, 'omitnan');   

    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    abs_angles = abs(nw_mean_resampled);
    [min_val, shin_zero_timing] = min(abs_angles(1:40));
    shin_zero_timing = shin_zero_timing - 1;
    
    %  -- plot
    fig = figure('Visible','off', 'Position',[500 400 560 420]); 
    [cfg1, ~] = plot_config('Shin Angle');  %
    cfg1.setup_gait_cycle_axis();
    cfg1.add_image_above();
    hold on;
    %plot(uniform_x_temp,all_nw_resampled_angles, '-k');  % Display individual gait cycle as black lines to visualize their spread
    Phase_Support(mean_unaffected_footoff_timing, mean_unaffected_contact_timing, mean_affected_footoff_timing); hold on;
    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    
    % NW
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    %% 脛の角度が0になるタイミング
    
    plot([shin_zero_timing/100, shin_zero_timing/100], [-30, 30], '--b'); hold on;
    text(shin_zero_timing/100, min_val-5, sprintf('Vertical Timing: %d', shin_zero_timing), ...
        'FontSize',14, 'EdgeColor', 'k', 'BackgroundColor','w');
    
    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}];
    else
        save_filename = [filenames{ceil(p_idx/2)}, target_filename];
    end
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    
    set(fig, 'Visible', 'off');
end
