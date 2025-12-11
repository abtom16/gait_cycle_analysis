clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Left';  % If you want to analyse right foot, change to 'Right'
[nw_paths, filenames] = getSubjectDataNW(target_foot);

save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\03_ShinAngle\angle-angularvelo';
target_filename = '_shin-anglevelo-NW.png';


% for lowpass filter
CUTOFF = 10;
FS = 60;
dt = 1 / FS;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
NW_MEAN_COLOR_LEFT = [0.5 0.5 0.5];
NW_RANGE_COLOR_LEFT = [0.8 0.8 0.8];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;

if strcmp(target_foot, 'Nondisabled')
    iteration_setup = 1:length(nw_paths);
else
    iteration_setup = 1:2:length(nw_paths);
end

for p_idx = iteration_setup
    all_nw_resampled_angles = [];
    all_nw_resampled_angle_velos = [];
    all_unaffected_contact_timing = [];
    all_unaffected_footoff_timing = [];
    all_affected_footoff_timing = [];

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        current_unaffected_contact = nw_Rcontact_frame;
        current_unaffected_footoff = nw_Rcontact_end_frame;
        foot_side='LFoot';
        shank_side = 'LKnee';
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        current_unaffected_contact = nw_Lcontact_frame;
        current_unaffected_footoff = nw_Lcontact_end_frame;
        foot_side='RFoot';
        shank_side = 'RKnee';
    end

    for j = 1:length(current_nw_contact_frame)-1
        %% -- 健側の離地のタイミングを算出（単脚支持期のスタート）--
        %{
            frames_in_current_cycle：
            現在の歩行周期内でcurrent_unaffected_toeoffがある場合
            該当するフレームをtrueとする
            unaffected_toeoff：
            該当するフレームがtrueであるフレーム数を取得する        
        %}
        [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
            getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
            all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
            current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

        current_cycle_foot_x = current_nw_data.(foot_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_x = current_nw_data.(shank_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_z = current_nw_data.(shank_side).z( ...  
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
        
        shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
        shin_angle_deg = rad2deg(shin_angle_rad);
        shin_angle = 90 - shin_angle_deg;  % 地面と垂直を0degにしたい
        
        original_x = linspace(0, 1, length(shin_angle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, shin_angle, uniform_x_temp);
        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];

        %% -- 角速度の算出(中心差分法) --
        angular_velo = zeros(length(shin_angle), 1);
        angular_velo(1) = (shin_angle(2) - shin_angle(1)) / dt;  %最初の点は、前進差分
        for  k = 2:length(shin_angle)-1
            angular_velo(k) = (shin_angle(k+1) - shin_angle(k-1)) / (2 * dt);
        end
        angular_velo(end) = (shin_angle(end) - shin_angle(end-1)) / dt;  %最後の点は、後進差分
    
        original_x_velo = linspace(0, 1, length(angular_velo));
        resampled_cycle_velo = interp1(original_x_velo, angular_velo, uniform_x_temp);
        all_nw_resampled_angle_velos = [all_nw_resampled_angle_velos, resampled_cycle_velo'];
    end
    if strcmp(target_foot, 'Left') || strcmp(target_foot, 'Right')
        if p_idx + 1 <= length(nw_paths)
            current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
            [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
                detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
            
            if strcmpi(target_foot, 'Left')
                current_nw_contact_frame = nw_Lcontact_frame;
                current_nw_contact_end_frame = nw_Lcontact_end_frame;
                current_unaffected_contact = nw_Rcontact_frame;
                current_unaffected_footoff = nw_Rcontact_end_frame;
                foot_side='LFoot';
                shank_side = 'LKnee';
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
                current_unaffected_contact = nw_Lcontact_frame;
                current_unaffected_footoff = nw_Lcontact_end_frame;
                foot_side='RFoot';
                shank_side = 'RKnee';
            end
        
            for j = 1:length(current_nw_contact_frame)-1
                [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
                    getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
                    all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
                    current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

                current_cycle_foot_x = current_nw_data.(foot_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_shank_x = current_nw_data.(shank_side).x( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_shank_z = current_nw_data.(shank_side).z( ...  %
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
                
                shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
                shin_angle_deg = rad2deg(shin_angle_rad);
                shin_angle = 90 - shin_angle_deg;  % 地面と垂直を0degにしたい
                
                original_x = linspace(0, 1, length(shin_angle));
                uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
                
                resampled_cycle = interp1(original_x, shin_angle, uniform_x_temp);
                all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];

                %% -- 角速度の算出(中心差分法) --
                angular_velo = zeros(length(shin_angle), 1);
                angular_velo(1) = (shin_angle(2) - shin_angle(1)) / dt;  %最初の点は、前進差分
                for  k = 2:length(shin_angle)-1
                    angular_velo(k) = (shin_angle(k+1) - shin_angle(k-1)) / (2 * dt);
                end
                angular_velo(end) = (shin_angle(end) - shin_angle(end-1)) / dt;  %最後の点は、後進差分
        
                original_x_velo = linspace(0, 1, length(angular_velo));
                uniform_x_temp_velo = linspace(0, 1, UNIFORM_LENGTH);
                resampled_cycle_velo = interp1(original_x_velo, angular_velo, uniform_x_temp);
                
                all_nw_resampled_angle_velos = [all_nw_resampled_angle_velos, resampled_cycle_velo'];
            end
        end
    end
    mean_unaffected_footoff_timing = mean(all_unaffected_footoff_timing, 'omitnan');
    mean_unaffected_contact_timing = mean(all_unaffected_contact_timing, 'omitnan');
    mean_affected_footoff_timing = mean(all_affected_footoff_timing, 'omitnan');

    %% -- shin angle --
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    abs_angles = abs(nw_mean_resampled);
    [min_val, shin_zero_timing] = min(abs_angles(1:40));
    shin_zero_timing = shin_zero_timing - 1;
    shin_zero_timing = shin_zero_timing / 100;  %　indexで範囲を入力しているが、横軸は0～1の小数で算出しているため100分の1にする必要がある 


    %% -- shin angular velo --
    nw_uniform_x_velo = uniform_x_temp;
    nw_mean_resampled_velo = mean(all_nw_resampled_angle_velos, 2);
    nw_std_resampled_velo = std(all_nw_resampled_angle_velos, 1, 2);
    nw_std_max_velo = nw_mean_resampled_velo + nw_std_resampled_velo;
    nw_std_min_velo = nw_mean_resampled_velo - nw_std_resampled_velo;
    
    %  -- plot
    fig = figure('Visible','off', 'Position',[600 400 560 420]);
    [cfg1, ~] = plot_config('Shin Angle');  %
    cfg1.setup_gait_cycle_axis();
    cfg1.add_image_above();
    hold on;
    Phase_Support(mean_unaffected_footoff_timing, mean_unaffected_contact_timing, mean_affected_footoff_timing); hold on;
    Shin_Minus_Background(mean_unaffected_footoff_timing, shin_zero_timing); hold on;

    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');

    yyaxis left
    ylim([-45, 45]);
    ylabel('Shin Angle [deg]');
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR_LEFT, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR_LEFT, ...
        'DisplayName','Shin Angle[deg]', 'LineWidth', 1.5); hold on;


    % NW
    yyaxis right
    ylim([-180, 180]);
    h = ylabel('Shin Angular Velocity [deg/s]', 'Color','k');
    set(h, 'Position', get(h, 'Position') + [0.05, 0, 0]);
    fill_x_nw_velo = [nw_uniform_x_velo, fliplr(nw_uniform_x_velo)];
    fill_y_nw_velo = [nw_std_min_velo', fliplr(nw_std_max_velo')];
    fill(fill_x_nw_velo, fill_y_nw_velo, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x_velo, nw_mean_resampled_velo, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Shin Angular Velocity[deg/s]', 'LineWidth', 1.5); hold on;
    
    if mean_unaffected_footoff_timing < shin_zero_timing
        mean_unaffected_footoff_idx = round(mean_unaffected_footoff_timing * 100);
        shin_zero_idx = round(shin_zero_timing * 100);
        analysis_data = nw_mean_resampled_velo(mean_unaffected_footoff_idx:shin_zero_idx);
        [shin_velo_min, shin_velo_min_idx] = min(analysis_data);
        shin_velo_min_idx = shin_velo_min_idx + mean_unaffected_footoff_idx - 1;
        shin_velo_min_timing = shin_velo_min_idx / 100;
        xline(shin_velo_min_timing, '-b','HandleVisibility','off');
        text(shin_velo_min_timing, -100, sprintf('Min %.2f[deg/s] at %d%%', shin_velo_min, round(shin_velo_min_idx)), ...
            'FontSize',14, 'EdgeColor','k', 'BackgroundColor','w', 'HorizontalAlignment','center');
    end

    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}, target_filename];
    else
        save_filename = [filenames{ceil(p_idx/2)}, target_filename];
    end
    
    legend('Location','northeast');
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    
    set(fig, 'Visible', 'off');
end

function Shin_Minus_Background(mean_unaffected_footoff_timing, shin_zero_timing)
    ax = gca;
    y_lim_current = ax.YLim;
    if mean_unaffected_footoff_timing < shin_zero_timing
        bg_highlight = fill([mean_unaffected_footoff_timing, shin_zero_timing, shin_zero_timing, mean_unaffected_footoff_timing], ...
            [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], [0, 0, 1], 'FaceAlpha',0.2,'EdgeColor', 'b', 'HandleVisibility', 'off');
        uistack(bg_highlight, 'bottom');
    end
end
