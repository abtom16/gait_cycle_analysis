clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Incomplete_Left';  % If you want to analyse right foot, change to 'Right'
[nw_paths, filenames] = getSubjectDataNW(target_foot);

save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_NW_analysis\04_TLAAngle';
target_filename = '_tla-NW.png';


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

if strcmp(target_foot, 'Nondisabled') || strcmp(target_foot, 'Incomplete_Left')
    iteration_setup = 1:length(nw_paths);
else 
    iteration_setup = 1:2:length(nw_paths);
end
% NW
for p_idx = iteration_setup
    all_nw_resampled_angles = [];
    all_unaffected_footoff_timing = [];
    all_unaffected_contact_timing = [];
    all_affected_footoff_timing = [];

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left') || strcmp(target_foot, 'Incomplete_Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        foot_side='LFoot';
        hip_side = 'LHip';
        current_unaffected_contact = nw_Rcontact_frame;
        current_unaffected_footoff = nw_Rcontact_end_frame;
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        foot_side='RFoot';
        hip_side = 'RHip';
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
        current_cycle_hip_x = current_nw_data.(hip_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_hip_z = current_nw_data.(hip_side).z( ...  
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
        
        tla_angle_rad = atan2(current_cycle_hip_z, current_cycle_hip_x - current_cycle_foot_x);
        tla_angle_deg = rad2deg(tla_angle_rad);
        tla_angle = 90 - tla_angle_deg;  % 地面と垂直を0degにしたい
       
        original_x = linspace(0, 1, length(tla_angle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, tla_angle, uniform_x_temp);

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
                hip_side = 'LHip';
                current_unaffected_contact = nw_Rcontact_frame;
                current_unaffected_footoff = nw_Rcontact_end_frame;
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
                foot_side='RFoot';
                hip_side = 'RHip';
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
                current_cycle_hip_x = current_nw_data.(hip_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_hip_z = current_nw_data.(hip_side).z( ...  %
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
                
                tla_angle_rad = atan2(current_cycle_hip_z, current_cycle_hip_x - current_cycle_foot_x);
                tla_angle_deg = rad2deg(tla_angle_rad);
                tla_angle = 90 - tla_angle_deg;  % 地面と垂直を0degにしたい
        
                original_x = linspace(0, 1, length(tla_angle));
                uniform_x_temp = linspace(0, 1, uniform_length);
                resampled_cycle = interp1(original_x, tla_angle, uniform_x_temp);
                
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
    
    [max_val, max_idx] = max(nw_mean_resampled);
    
    %  -- plot
    fig = figure('Visible','off', 'Position',[500 400 560 420]); 
    [cfg1, ~] = plot_config('TLA Angle');  %
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
    
    %% TLAの最大角度
    plot([max_idx/100-0.2, max_idx/100+0.2], [max_val, max_val], '--b'); hold on;
    text(max_idx/100, max_val+3, sprintf('MAX %.2f deg (at %d%%)', max_val, round(max_idx)), ...
        'FontSize',14,'HorizontalAlignment','Right', 'VerticalAlignment','bottom','EdgeColor', 'k', 'BackgroundColor','w');
    
    if strcmp(target_foot, 'Nondisabled') || strcmp(target_foot, 'Incomplete_Left')
        save_filename = [filenames{p_idx}, target_filename];
    else
        save_filename = [filenames{ceil(p_idx/2)}, target_filename];
    end
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    
    set(fig, 'Visible', 'off');
end
