clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Nondisabled';  % If you want to analyse right foot, change to 'Right'
[nw_paths, filenames] = getSubjectData(target_foot);

save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\ShinAngle\AngularVelo';
target_filename = '_shin-velo-NW.png';


% for lowpass filter
CUTOFF = 10;
FS = 60;
dt = 1 / FS;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
DR_MEAN_COLOR = [0 0 0.7];
DR_RANGE_COLOR = [0.4 0.6 1];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;

% NW
% for p_idx = 1:2:length(nw_paths) 
for p_idx = 1:length(nw_paths)
    all_nw_resampled_angles = [];
    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        foot_side='LFoot';
        shank_side = 'LShank';
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        foot_side='RFoot';
        shank_side = 'RShank';
    end

    for j = 1:length(current_nw_contact_frame)-1
        current_cycle_foot_x = current_nw_data.(foot_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_x = current_nw_data.(shank_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_z = current_nw_data.(shank_side).z( ...  
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
        
        shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
        shin_angle_deg = rad2deg(shin_angle_rad);
        shin_angle = 90 - shin_angle_deg;  % 地面と垂直を0degにしたい
        
        %% -- 角速度の算出(中心差分法) --
        angular_velo = zeros(length(shin_angle), 1);
        angular_velo(1) = (shin_angle(2) - shin_angle(1)) / dt;  %最初の点は、前進差分
        for  k = 2:length(shin_angle)-1
            angular_velo(k) = (shin_angle(k+1) - shin_angle(k-1)) / (2 * dt);
        end
        angular_velo(end) = (shin_angle(end) - shin_angle(end-1)) / dt;  %最後の点は、後進差分

        original_x = linspace(0, 1, length(angular_velo));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, angular_velo, uniform_x_temp);
        
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
                shank_side = 'LShank';
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
                foot_side='RFoot';
                shank_side = 'RShank';
            end
        
            for j = 1:length(current_nw_contact_frame)-1
                current_cycle_foot_x = current_nw_data.(foot_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_shank_x = current_nw_data.(shank_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_shank_z = current_nw_data.(shank_side).z( ...  %
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
                
                shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
                shin_angle_deg = rad2deg(shin_angle_rad);
                shin_angle = 90 - shin_angle_deg;  % 地面と垂直を0degにしたい
                
                %% -- 角速度の算出(中心差分法) --
                angular_velo = zeros(length(shin_angle), 1);
                angular_velo(1) = (shin_angle(2) - shin_angle(1)) / dt;  %最初の点は、前進差分
                for  k = 2:length(shin_angle)-1
                    angular_velo(k) = (shin_angle(k+1) - shin_angle(k-1)) / (2 * dt);
                end
                angular_velo(end) = (shin_angle(end) - shin_angle(end-1)) / dt;  %最後の点は、後進差分
        
                original_x = linspace(0, 1, length(angular_velo));
                uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
                resampled_cycle = interp1(original_x, angular_velo, uniform_x_temp);
                
                all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
            end
        end
    end
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    % abs_angles = abs(nw_mean_resampled);
    % [min_val, min_idx] = min(abs_angles(1:40));
    % min_idx = min_idx - 1;
    
    %  -- plot
    fig = figure('Visible','off');
    [cfg1, ~] = plot_config('Shin Angular Velo');  %
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
    
    %% 脛の角度が0になるタイミング
    
    % plot([min_idx/100, min_idx/100], [-30, 30], '--b'); hold on;
    % text(min_idx/100, min_val-5, sprintf('Vertical Timing: %d', min_idx), ...
    %     'FontSize',14, 'EdgeColor', 'k', 'BackgroundColor','w');
    
    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}, target_filename];
    else
        save_filename = [filenames{ceil(p_idx/2)}, target_filename];
    end
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    
    set(fig, 'Visible', 'off');
end

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