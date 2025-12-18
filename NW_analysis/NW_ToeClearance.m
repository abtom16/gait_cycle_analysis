clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 


%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Incomplete_Left';  % If you want to analyse right foot, change to 'Right' 
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_NW_analysis\ToeClearance';

[nw_paths, filenames] = getSubjectDataNW(target_foot);

if strcmp(target_foot, 'Left')
    target_side = 'L';
else
    target_side = 'R';
end

target_joint = [target_side,'Toe'];
target_axis = 'z';
filename_target_joint = '_ToeClearance.png';



% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];

%%  data calculation for each procedure
uniform_length = 100;

% NW
if strcmp(target_joint, 'Nondisabled')
    iteration_setup = 1:length(nw_paths);
else
    iteration_setup = 1:2:length(nw_paths);
end

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
        current_unaffected_contact = nw_Rcontact_frame;
        current_unaffected_footoff = nw_Rcontact_end_frame;
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        current_unaffected_contact = nw_Lcontact_frame;
        current_unaffected_footoff = nw_Lcontact_end_frame;
    end

    for j = 1:length(current_nw_contact_frame)-1
        [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
            getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
            all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
            current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

        current_cycle = current_nw_data.(target_joint).(target_axis)( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        toe_min = min(current_nw_data.(target_joint).(target_axis));
        current_cycle = current_cycle - toe_min;
        current_cycle = current_cycle * 100;  % Scaling m -> cm

        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
    if strcmp(target_foot, 'Left') || strcmp(target_foot, 'Right')
        if p_idx+1 <= length(nw_paths)            
            current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
            [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
                detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
            if strcmpi(target_foot, 'Left')
                current_nw_contact_frame = nw_Lcontact_frame;
                current_nw_contact_end_frame = nw_Lcontact_end_frame;
                current_unaffected_contact = nw_Rcontact_frame;
                current_unaffected_footoff = nw_Rcontact_end_frame;
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
                current_unaffected_contact = nw_Lcontact_frame;
                current_unaffected_footoff = nw_Lcontact_end_frame;
            end
        
            for j = 1:length(current_nw_contact_frame)-1
                [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
                    getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
                    all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
                    current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);
                current_cycle = current_nw_data.(target_joint).(target_axis)( ...  %
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                
                toe_min = min(current_nw_data.(target_joint).(target_axis));
                current_cycle = current_cycle - toe_min;
                current_cycle = current_cycle * 100;  % Scaling m -> cm

                original_x = linspace(0, 1, length(current_cycle));
                uniform_x_temp = linspace(0, 1, uniform_length);
                resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);
        
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
    [min_swing_mean, min_swing_idx] = min(nw_mean_resampled(71:100));  % For Toe Clearance resampled(71:100)
    [max_swing_mean, max_swing_idx] = max(nw_mean_resampled(61:100));
    
    [min_stance_mean, min_stance_idx] = min(nw_mean_resampled(1:50));
    [max_stance_mean, max_stance_idx] = max(nw_mean_resampled(1:50));  %  for knee angle resampled(1:30)
    
    min_swing_idx = min_swing_idx + 70;
    max_swing_idx = max_swing_idx + 60;
    
    mean_stance = mean(nw_mean_resampled(1:50));
    
    %  -- plot
    fig = figure('Visible','off', 'Position', [600 400 560 420]);
    [cfg1, ~] = plot_config('Toe Clearance');  
    cfg1.setup_gait_cycle_axis(); hold on;
    cfg1.add_normal_range(); hold on;  
    cfg1.add_image_above(); hold on;
    Phase_Support(mean_unaffected_footoff_timing, mean_unaffected_contact_timing, mean_affected_footoff_timing)
    
    yline(0, '-', 'Color', [0.5 0.5 0.5]); hold on;
    
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    %% 股関節最大伸展角度とそのタイミングの算出 
    plot([min_swing_idx/100,min_swing_idx/100],[0,10], '--r'); hold on;
    text(min_swing_idx/100, min_swing_mean-1, sprintf('MIN %d%%: %.2fcm', min_swing_idx, min_swing_mean), "FontSize",14,'Color',[0.8, 0.4, 0],...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    plot([max_swing_idx/100,max_swing_idx/100],[5,15], '--r'); hold on;
    text(max_swing_idx/100, max_swing_mean+1, sprintf('MAX %d%%: %.2fcm', max_swing_idx, max_swing_mean), "FontSize",14,'Color',[0.8 0.4 0],...
        'HorizontalAlignment','right', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    
    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}, filename_target_joint];
    else
        save_filename = [filenames{ceil(p_idx/2)}, filename_target_joint];
    end
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    set(fig, 'Visible', 'off');
end
