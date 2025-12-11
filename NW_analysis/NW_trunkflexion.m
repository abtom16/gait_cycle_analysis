clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 


%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Nondisabled';  % If you want to analyse right foot, change to 'Right' 
config_str = 'Trunk Flexion';

[nw_paths, filenames] = getSubjectDataNW(target_foot);
if strcmp(target_foot, 'Nondisabled')
    iteration_setup = 1:length(nw_paths);
else
    iteration_setup = 1:2:length(nw_paths);
end

for p_idx = iteration_setup
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\TrunkFlexion';
    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}, '_trunkFlex.png'];
    else
        save_filename = [filenames{ceil(p_idx/2)}, '-trunkFlex.png'];
    end
    
    % color definition
    NW_MEAN_COLOR = [0 0.7 0.7];
    NW_RANGE_COLOR = [0.6 0.9 0.9];
    
    %%  data calculation for each procedure
    UNIFORM_LENGTH = 100;

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
    end
    
    whole_data = [];
    for j = 1:length(current_nw_contact_frame)-1
        current_cycle = current_nw_data.Trunk.flexion( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);
        whole_data = [whole_data, resampled_cycle'];
    end
    if strcmp(target_foot, 'Left') || strcmp(target_foot, 'Right')
        if p_idx+1 <= length(nw_paths)
            current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
            [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
                detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
            
            if strcmpi(target_foot, 'Left')
                current_nw_contact_frame = nw_Lcontact_frame;
                current_nw_contact_end_frame = nw_Lcontact_end_frame;
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
            end
            for j = 1:length(current_nw_contact_frame)-1
                current_cycle = current_nw_data.Trunk.flexion( ...  %
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                
                original_x = linspace(0, 1, length(current_cycle));
                uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
                resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);
                whole_data = [whole_data, resampled_cycle'];
            end
        end
    end
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(whole_data, 2);
    nw_std_resampled = std(whole_data, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;

    [min_swing_mean, min_swing_idx] = min(nw_mean_resampled(71:100));  % For Toe Clearance resampled(71:100)
    [max_swing_mean, max_swing_idx] = max(nw_mean_resampled(61:100));
    [min_stance_mean, min_stance_idx] = min(nw_mean_resampled(1:30));  % fpr trunk (1:40) else (1:50)
    [max_stance_mean, max_stance_idx] = max(nw_mean_resampled(20:50));  %  for knee angle resampled(1:30)
    
    max_stance_idx = max_stance_idx + 20;
    min_swing_idx = min_swing_idx + 70;
    max_swing_idx = max_swing_idx + 60;

    trunk_displacement = max_stance_mean - min_stance_mean;
    
    mean_trunk_flexion = mean(nw_mean_resampled);  %only for trunk flexion
    
    %  -- plot
    fig = figure('Visible','off');
    [cfg1, ~] = plot_config(config_str);  
    cfg1.setup_gait_cycle_axis(); hold on;
    cfg1.add_phase_backgrounds(); hold on;
    cfg1.add_normal_range(); hold on;  %
    cfg1.add_image_above(); hold on;
    
    yline(0, '-', 'Color', [0.5 0.5 0.5]); hold on;
    
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    
    %% 股関節最大伸展角度とそのタイミングの算出 
    % swing phase
    % plot([min_swing_idx/100,min_swing_idx/100],[0,10], '--r'); hold on;
    % text(min_swing_idx/100, min_swing_mean+2, sprintf('MIN %d%%: %.2fdeg', min_swing_idx, min_swing_mean), "FontSize",14,'Color',[0.8, 0.4, 0],...
    %     'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    plot([max_stance_idx/100,max_stance_idx/100],[10,70], '--r'); hold on;
    text(max_stance_idx/100, max_stance_mean+2, sprintf('MAX displacement %.2f at %d%%', trunk_displacement, max_stance_idx), "FontSize",14,'Color','b',...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    
    % average
    plot([0, 1],[mean_trunk_flexion, mean_trunk_flexion], '--', 'Color',NW_MEAN_COLOR, 'HandleVisibility','off'); hold on;
    text(0.2, mean_trunk_flexion, sprintf('Mean Trunk Flexion: %.2fdeg', mean_trunk_flexion), ...
        'Color', NW_MEAN_COLOR, 'VerticalAlignment','bottom');

    set(fig, 'Visible', 'off');
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
end
