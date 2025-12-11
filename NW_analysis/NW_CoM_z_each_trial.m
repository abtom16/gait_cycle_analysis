clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 
% nw_paths_left_archive = {    
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal2.xlsx"
%     };
nw_paths_left = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\Modified_sub10_nw-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\Modified_sub10_nw-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_nw-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_nw-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_nw-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_nw-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\Modified_nw-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub16\Modified_nw-002.xlsx";
    };
%  Take Care! Paretic side is Right
% nw_paths_right_archive = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
%     };
nw_paths_right = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\Modified_nw-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\Modified_nw-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\Modified_nw-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\Modified_nw-002.xlsx";
    };
%% -- save_filename
filename_left = {
    'sub4_1';
    'sub4_2';
    'sub5_1';
    'sub5_2';
    'sub6_1';
    'sub6_2';
    'sub7_1';
    'sub7_2';
    'sub8_1';
    'sub8_2';
    'sub10_1';
    'sub10_2';
    'sub11_1';
    'sub11_2';
    'sub12_1';
    'sub12_2';
    'sub16_1';
    'sub16_2';
};
filename_right = {
    'sub9_1';
    'sub9_2';
    'sub13_1';
    'sub13_2';
    'sub15_1';
    'sub15_2';
};

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Left';  % If you want to analyse right foot, change to 'Right' 
% Gaitdata関節角度、plot_configの変更忘れない！
if strcmp(target_foot, 'Left')
    nw_paths = nw_paths_left;
    filenames = filename_left;
else
    nw_paths = nw_paths_right;
    filenames = filename_right;
end

for p_idx=1:length(nw_paths)
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\CoM_z\EachTrial';
    save_filename = [filenames{p_idx}, '-NW.png'];
    
    % color definition
    NW_MEAN_COLOR = [0 0.7 0.7];
    NW_RANGE_COLOR = [0.6 0.9 0.9];
    DR_MEAN_COLOR = [0 0 0.7];
    DR_RANGE_COLOR = [0.4 0.6 1];
    
    %%  data calculation for each procedure
    uniform_length = 100;
    
    % NW
    all_nw_resampled_angles = [];
    all_CoM_vertical_excursions = [];

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

    for j = 1:length(current_nw_contact_frame)-1
        current_cycle = current_nw_data.CoM.z( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        % current_cycle_norm = lowpass(current_cycle_norm, CUTOFF, FZ);
        current_cycle_norm = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
        current_cycle_norm = current_cycle_norm * 100;

        original_x = linspace(0, 1, length(current_cycle_norm));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle_norm, uniform_x_temp);
        
        max_stance_angle_per_cycle = max(resampled_cycle(10:40));
        min_stance_angle_per_cycle = min(resampled_cycle(1:20));
        current_CoM_vertical_excursion = max_stance_angle_per_cycle - min_stance_angle_per_cycle;

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
        all_CoM_vertical_excursions = [all_CoM_vertical_excursions, current_CoM_vertical_excursion];
    end

    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    [min_nw_stance, minidx_nw_stance] = min(nw_mean_resampled(1:30));
    [max_nw_stance, maxidx_nw_stance] = max(nw_mean_resampled(10:40));
    maxidx_nw_stance = maxidx_nw_stance + 10;
    minidx_nw_stance_xaxis = minidx_nw_stance / 100;
    maxidx_nw_stance_xaxis = maxidx_nw_stance / 100;
    
    mean_CoM_vertical_excursion = mean(all_CoM_vertical_excursions);
    std_CoM_vertical_excursion = std(all_CoM_vertical_excursions);
    
    [min_nw_mean_50_100, min_idx_50_100] = min(nw_mean_resampled(51:90));
    [max_nw_mean_50_100, max_idx_50_100] = max(nw_mean_resampled(51:90));
    %  -- plot
    fig = figure('Visible','off');
    [cfg1, ~] = plot_config('CoM Vertical');  %
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
    %% 重心最高点と最小点の算出 
    plot([nw_uniform_x(1),nw_uniform_x(50)],[max_nw_stance,max_nw_stance], '--b'); hold on;
    plot([nw_uniform_x(1),nw_uniform_x(50)],[min_nw_stance,min_nw_stance], '--b'); hold on;
    text(minidx_nw_stance_xaxis, min_nw_stance-0.2, sprintf('Min%d%%', minidx_nw_stance), "FontSize",12,'Color','b',...
        'HorizontalAlignment','left', 'VerticalAlignment','top', 'BackgroundColor', 'w'); hold on;
    text(maxidx_nw_stance_xaxis, max_nw_stance+0.3, sprintf('Vertical CoM Excursion\n %.2f ± %.2f cm at %d%%', mean_CoM_vertical_excursion, std_CoM_vertical_excursion,maxidx_nw_stance), ...
        "FontSize",12,'Color','b', 'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor', 'w'); hold on;
    
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