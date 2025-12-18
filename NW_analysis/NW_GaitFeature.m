clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 


%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Incomplete_Left';  % If you want to analyse right foot, change to 'Right' 
target_move = 'Hip Flexion';

if strcmp(target_foot, 'Left')
    target_side = 'L';
else
    target_side = 'R';
end

if strcmp(target_move, 'Hip Flexion')
    target_joint = [target_side,'Hip'];
    target_axis = 'extension';
    filename_target_joint = '_HipEx.png';
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_NW_analysis\02_HipEx';
elseif strcmp(target_move, 'Knee Angle')
    target_joint = [target_side,'Knee'];
    target_axis = 'angle';
    filename_target_joint = '_Knee-NW.png';
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_NW_analysis\Knee';
elseif strcmp(target_move, 'Ankle Angle')
    target_joint = [target_side, 'Ankle'];
    target_axis = 'angle';
    filename_target_joint = '_Ankle.png';
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_NW_analysis\Ankle';
end

[nw_paths, filenames] = getSubjectDataNW(target_foot);

% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];

%%  data calculation for each procedure
uniform_length = 100;

if strcmp(target_foot, 'Nondisabled') || strcmp(target_foot, 'Incomplete_Left')
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
    
    %% ---- Each Gait Cycle Mode ----
    % fig = figure('Visible','off','Position',[680 458 560 420]);
    % [cfg1, ~] = plot_config(target_move);  
    % cfg1.setup_gait_cycle_axis(); hold on;
    % cfg1.add_normal_range(); hold on;  
    % cfg1.add_image_above(); hold on;
    %% ------------------------------

    for j = 1:length(current_nw_contact_frame)-1
        [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
            getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
            all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
            current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);
        current_cycle = current_nw_data.(target_joint).(target_axis)( ...  
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);
        
        %% --- Each Gait Cycle Mode ---
        % if j == 1
        %     plot(uniform_x_temp, resampled_cycle, '--', 'Color',[0.4,0.4,0.4] ,'LineWidth', 1, 'DisplayName','1st Trial'); hold on;
        % else 
        %     plot(uniform_x_temp, resampled_cycle, '--', 'Color',[0.4,0.4,0.4] ,'LineWidth', 1, 'HandleVisibility','off'); hold on;
        % end
        %% ----------------------------

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
                current_cycle = current_nw_data.(target_joint).(target_axis)( ... 
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                
                original_x = linspace(0, 1, length(current_cycle));
                uniform_x_temp = linspace(0, 1, uniform_length);
                resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);
                
                %% --- Each Gait Cycle Mode ---
                % if j == 1
                %     plot(uniform_x_temp, resampled_cycle, '-', 'Color',[0.4,0.4,0.4] ,'LineWidth', 1, 'DisplayName','2nd Trial'); hold on;
                % else 
                %     plot(uniform_x_temp, resampled_cycle, '-', 'Color',[0.4,0.4,0.4] ,'LineWidth', 1, 'HandleVisibility','off'); hold on;
                % end
                %% ----------------------------

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
    
    [min_stance_mean, min_stance_idx] = min(nw_mean_resampled(1:60));
    [max_stance_mean, max_stance_idx] = max(nw_mean_resampled(1:50));  %  for knee angle resampled(1:30)
    
    min_swing_idx = min_swing_idx + 70;
    max_swing_idx = max_swing_idx + 60;
    
    mean_stance = mean(nw_mean_resampled(1:50));

    % --- 20251016　麻痺側片脚立脚時の股関節角度の算出 mst(mid stance)
    mst_idx = round(mean_unaffected_footoff_timing * 100);
    if mst_idx < 1 || mst_idx > length(nw_mean_resampled)
        error('Index is out of bounds')
    end
    mst_joint_angle = nw_mean_resampled(mst_idx);
    displacement_mst2maxex = mst_joint_angle - min_stance_mean;
    
    % --- 20251017　麻痺側歩行周期70%での股関節角度の算出 flex_velo_max（股関節屈曲角度変化の最大値が健常者で60~70%）
    flex_velo_max_idx = 70;
    joint_angle_flex_velo_max = nw_mean_resampled(flex_velo_max_idx);
    displacement_maxex2flexvelomax = joint_angle_flex_velo_max - min_stance_mean;

    % --- 20251019　麻痺側立脚期最大伸展から遊脚期最大屈曲の角度変化量の算出
    displacement_maxex2maxflex = max_swing_mean - min_stance_mean;

    % --- 20241203　麻痺側立脚期の股関節屈曲角度が0°になるタイミングを算出
    abs_nw_mean_resampled = abs(nw_mean_resampled(1:55));
    [~, zero_timing_idx] = min(abs_nw_mean_resampled);  % 一番0degに近いindexを取得
    zero_timing = nw_uniform_x(zero_timing_idx) * 100;

    %  -- plot
    fig = figure('Visible','off','Position',[600 400 560 420]);
    [cfg1, ~] = plot_config(target_move);  
    cfg1.setup_gait_cycle_axis(); hold on;
    cfg1.add_normal_range(); hold on;  
    cfg1.add_image_above(); hold on;
    Phase_Support(mean_unaffected_footoff_timing, mean_unaffected_contact_timing, mean_affected_footoff_timing); hold on;
    % 
    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off'); hold on;
    
    %% ----平均値と標準偏差のプロット
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    %% ----------------------------

    %% 股関節最大伸展角度とそのタイミングの算出 
    % --遊脚期
    % plot([min_swing_idx/100,min_swing_idx/100],[0,10], '--r'); hold on;
    % text(min_swing_idx/100, min_swing_mean+2, sprintf('MIN %d%%: %.2fdeg', min_swing_idx, min_swing_mean), "FontSize",14,'Color',[0.8, 0.4, 0],...
    %     'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % plot([max_swing_idx/100,max_swing_idx/100],[20,60], '--r'); hold on;
    % text(max_swing_idx/100, max_swing_mean+2, sprintf('MAX %d%%: %.2fdeg', max_swing_idx, max_swing_mean), "FontSize",14,'Color',[0.8 0.4 0],...
    %     'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    
    % ---- 20251016　麻痺側単脚支持から股関節最大伸展の変化量を調べるため
    if mean_unaffected_footoff_timing < 0.1
        mst_idx_for_graph = 0.04;
    else
        mst_idx_for_graph = 0.1;
    end
    y_lim = ylim;
    plot([mst_idx_for_graph, 0.3], [mst_joint_angle, mst_joint_angle], '--b');
    text(mst_idx/100+0.05, mst_joint_angle+5, sprintf('%.2fdeg', mst_joint_angle), "FontSize",14,'Color','b',...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    plot([0.4,0.6],[min_stance_mean,min_stance_mean], '--b'); hold on;
    text(min_stance_idx/100, min_stance_mean-5, sprintf('%d%%: %.2fdeg', min_stance_idx, min_stance_mean), "FontSize",14,'Color','b',...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    text(1, y_lim(2), sprintf('Displacement: %.2f', displacement_mst2maxex), ...
        'EdgeColor','k','BackgroundColor','w', 'HorizontalAlignment','right','VerticalAlignment','top');
    text(1, y_lim(2)-(y_lim(2)-y_lim(1))*0.05, sprintf('0deg: %d%%', round(zero_timing)), ...
        'EdgeColor','k','BackgroundColor','w', 'HorizontalAlignment','right','VerticalAlignment','top');
    %--------- コメント：片麻痺と健常者の違いは分かるが、介入目的ごとの患者の違いが出なかった。

    %% ---- 20251017　麻痺側股関節最大伸展から歩行周期70%の股関節屈曲角度の変化量を調べるため
    % y_lim = ylim;
    % plot([0.6, 0.8], [joint_angle_flex_velo_max, joint_angle_flex_velo_max], '--b');
    % text(0.65, joint_angle_flex_velo_max+5, sprintf('%.2fdeg', joint_angle_flex_velo_max), "FontSize",14,'Color','b',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % plot([0.4, 0.6],[min_stance_mean, min_stance_mean], '--b'); hold on;
    % text(min_stance_idx/100, min_stance_mean-5, sprintf('%d%%: %.2fdeg', min_stance_idx, min_stance_mean), "FontSize",14,'Color','b',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % text(1, y_lim(2), sprintf('Displacement: %.2f', displacement_maxex2flexvelomax), 'EdgeColor','k','BackgroundColor','w', 'HorizontalAlignment','right','VerticalAlignment','top');
    % 
    % ---- 20251018  麻痺側股関節最大伸展から遊脚期の股関節最大屈曲の変化量を調べるため　（70%でないといけない理由の補強としたい）
    % y_lim = ylim;
    % plot([0.7, 1], [max_swing_mean, max_swing_mean], '--b');
    % text(max_swing_idx/100, max_swing_mean+5, sprintf('%.2fdeg', max_swing_mean), "FontSize",14,'Color','b',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % plot([0.4, 0.6],[min_stance_mean, min_stance_mean], '--b'); hold on;
    % text(min_stance_idx/100, min_stance_mean-5, sprintf('%d%%: %.2fdeg', min_stance_idx, min_stance_mean), "FontSize",14,'Color','b',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % text(1, y_lim(2), sprintf('Displacement: %.2f', displacement_maxex2maxflex), 'EdgeColor','k','BackgroundColor','w', 'HorizontalAlignment','right','VerticalAlignment','top');


    % --立脚期
    % plot([min_stance_idx/100,min_stance_idx/100],[-20,30], '--b'); hold on;
    % text(min_stance_idx/100, min_stance_mean-5, sprintf('%d%%: %.2fdeg', min_stance_idx, min_stance_mean), "FontSize",14,'Color','b',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','top', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % plot([max_stance_idx/100,max_stance_idx/100],[0,30], '--b'); hold on;
    % text(max_stance_idx/100, max_stance_mean+5, sprintf('%d%%: %.2fdeg', max_stance_idx, max_stance_mean), "FontSize",14,'Color','b',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor','w', 'EdgeColor','k'); hold on;
    % plot([0, 0.5],[mean_stance, mean_stance], '--', 'Color',NW_MEAN_COLOR, 'HandleVisibility','off'); hold on;
    % text(0.2, mean_stance, sprintf('Mean Knee Angle (Stance Phase): %.2fdeg', mean_stance), ...
    %     'Color', NW_MEAN_COLOR, 'VerticalAlignment','bottom');
    
    % legend('Location','northeast');
    
    if strcmp(target_foot, 'Nondisabled') || strcmp(target_foot, 'Incomplete_Left')
        save_filename = [filenames{p_idx}, filename_target_joint];
    else
        save_filename = [filenames{ceil(p_idx/2)}, filename_target_joint];
    end
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    set(fig, 'Visible', 'off');
end
clear all;
disp('Completely Processed!')