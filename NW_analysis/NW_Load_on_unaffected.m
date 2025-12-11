clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right'
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\Load-on-unaffected';
[nw_paths, filenames] = getSubjectData(target_foot);    
% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
DR_MEAN_COLOR = [0 0 0.7];
DR_RANGE_COLOR = [0.4 0.6 1];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;

for p_idx = 1:2:length(nw_paths) 
% for p_idx = 1:length(nw_paths)
    all_nw_resampled_angles = [];
    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        unaffected_contact_frame = nw_Rcontact_frame;
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        unaffected_foot_side='RFoot';
        thigh_side = 'CoM';
    else  
        unaffected_contact_frame = nw_Lcontact_frame;
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        unaffected_foot_side='LFoot';
        thigh_side = 'CoM';
    end
    
    for j = 1:length(current_nw_contact_end_frame)-1
        current_cycle_foot_y = current_nw_data.(unaffected_foot_side).y(unaffected_contact_frame(j));
        current_cycle_thigh_y = current_nw_data.(thigh_side).y( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1)); 
        
        hip_sway = current_cycle_thigh_y - current_cycle_foot_y;
        hip_sway = hip_sway * 100;
        
        if strcmp(target_foot, 'Right')
            hip_sway = -hip_sway;
        elseif strcmp(target_foot, 'Nondisabled')
            hip_sway = -hip_sway;
        end
        original_x = linspace(0, 1, length(hip_sway));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, hip_sway, uniform_x_temp);
        
        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
    
    if p_idx+1 <= length(nw_paths)
        current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
        [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
            detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
        if strcmpi(target_foot, 'Left')
            unaffected_contact_frame = nw_Rcontact_frame;
            current_nw_contact_frame = nw_Lcontact_frame;
            current_nw_contact_end_frame = nw_Lcontact_end_frame;
            unaffected_foot_side='RFoot';
            thigh_side = 'CoM';
        else  % only case for Right
            unaffected_contact_frame = nw_Lcontact_frame;
            current_nw_contact_frame = nw_Rcontact_frame;
            current_nw_contact_end_frame = nw_Rcontact_end_frame;
            unaffected_foot_side='LFoot';
            thigh_side = 'CoM';
        end

        for j = 1:length(current_nw_contact_end_frame)-1
            current_cycle_foot_y = current_nw_data.(unaffected_foot_side).y(unaffected_contact_frame(j));
            current_cycle_thigh_y = current_nw_data.(thigh_side).y( ...
                current_nw_contact_frame(j):current_nw_contact_frame(j+1)); 

            hip_sway = current_cycle_thigh_y - current_cycle_foot_y;
            hip_sway = hip_sway * 100;

            if strcmp(target_foot, 'Right')
                hip_sway = -hip_sway;
            end
            original_x = linspace(0, 1, length(hip_sway));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, hip_sway, uniform_x_temp);

            all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
        end
    end
    
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    [min_val_stance, min_idx_stance] = min(nw_mean_resampled(50:100));
    min_idx_stance = min_idx_stance + 50;
    
    %  -- plot
    fig = figure('Visible','off');
    [cfg1, ~] = plot_config('Load on Unaffected');  %
    cfg1.setup_gait_cycle_axis();
    cfg1.add_image_above();
    hold on;
    %plot(uniform_x_temp,all_nw_resampled_angles, '-k');  % Display individual gait cycle as black lines to visualize their spread
    Phase_Support; hold on;
    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    
    % NW
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;    
    
    % Minimam of Hip Sway
    plot([min_idx_stance/100, min_idx_stance/100], [-30, 30], '--b'); hold on;
    text(min_idx_stance/100, min_val_stance-3, sprintf('Min Timing %d%%: %.2fcm', min_idx_stance, min_val_stance), ...
        'FontSize',14, 'HorizontalAlignment','right','EdgeColor', 'k', 'BackgroundColor','w');

    
    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}, '_CoM_y-NW.png']; 
    else
        save_filename = [filenames{ceil(p_idx/2)}, '_CoM_y-NW.png']; 
    end
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    set(fig, 'Visible', 'off');
end

clear all;

function Phase_Support
    ax = gca;
    y_lim_current = ax.YLim;
    
    % --- 背景色の描画 ---
    % 両脚支持相1 (DS1: Initial Double Support) - 0%~10%
    bg_ds1 = fill([0, 0.1, 0.1, 0], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                  [0.5 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
    
    % 麻痺側片脚支持相 (Affected Single Support) - 10%~50%
    bg_affected_ss = fill([0.1, 0.5, 0.5, 0.1], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                          [0 0 1], 'EdgeColor', 'none','FaceAlpha', 0.05, 'HandleVisibility', 'off');   % 麻痺の時は、麻痺側の色を[0 0 1]
    
    % 両脚支持相2 (DS2: Terminal Double Support) - 50%~60%
    bg_ds2 = fill([0.5, 0.6, 0.6, 0.5], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                  [0.5 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
    
    % 健側片脚支持相 (Non-Affected Single Support) - 60%~100%
    bg_non_affected_ss = fill([0.6, 1.0, 1.0, 0.6], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                              [1 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.05,'HandleVisibility', 'off'); 
    
    % 全ての背景をグラフの底面に送る
    uistack(bg_ds1, 'bottom');
    uistack(bg_affected_ss, 'bottom');
    uistack(bg_ds2, 'bottom');
    uistack(bg_non_affected_ss, 'bottom');
    
    % --- テキストラベルの描画 ---
    % Y軸のテキスト位置を、グラフの最大値に合わせる
    text_y_top = y_lim_current(2) - (y_lim_current(2)-y_lim_current(1))*0.05;
    
    % 相の名前のテキスト
    text_ds1 = text(0.05, text_y_top, 'Double Support', 'FontSize', 12, 'Color', [0.7 0.4 0.4], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90); 
    text_affected_ss = text(0.15, text_y_top, 'Affected Single', 'FontSize', 12, 'Color', [0.9 0.75 0.5], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90);
    text_ds2 = text(0.55, text_y_top, 'Double Support', 'FontSize', 12, 'Color', [0.7 0.4 0.4], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90); 
    text_non_affected_ss = text(0.65, text_y_top, 'Non-Affected Single', 'FontSize', 12, 'Color', [0.9 0.75 0.5],  ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90);

    uistack(text_ds1, 'bottom');
    uistack(text_affected_ss, 'bottom');
    uistack(text_ds2, 'bottom');
    uistack(text_non_affected_ss, 'bottom');
end