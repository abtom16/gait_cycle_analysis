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
};
filename_right = {
    'sub9_1';
    'sub9_2';
    'sub13_1';
    'sub13_2'
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
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\HipSway\EachTrial';
    save_filename = [filenames{p_idx}, '-NW.png'];
    
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
        foot_side='LFoot';
        thigh_side = 'LThigh';
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        foot_side='RFoot';
        thigh_side = 'RThigh';
    end
    whole_data = [];
    for j = 1:length(current_nw_contact_frame)-1
        current_cycle_foot_y = current_nw_data.(foot_side).y(current_nw_contact_frame(j));
        current_cycle_thigh_y = current_nw_data.(thigh_side).y( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1)); 
        
        hip_sway = current_cycle_thigh_y - current_cycle_foot_y;
        hip_sway = hip_sway * 100;  % Scaling m → cm

        if strcmp(target_foot, 'Left')
            hip_sway = -hip_sway;
        end

        original_x = linspace(0, 1, length(hip_sway));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, hip_sway, uniform_x_temp);

        whole_data = [whole_data, resampled_cycle'];
    end
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(whole_data, 2);
    nw_std_resampled = std(whole_data, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;

    [min_val_stance, min_idx_stance] = min(nw_mean_resampled(1:50));
    
    %  -- plot
    fig = figure('Visible','off');
    [cfg1, ~] = plot_config('Hip Sway');  %
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
    
    
    plot([min_idx_stance/100, min_idx_stance/100], [-30, 30], '--b'); hold on;
    text(min_idx_stance/100, min_val_stance-5, sprintf('Vertical Timing: %d', min_idx_stance), ...
    'FontSize',14, 'EdgeColor', 'k', 'BackgroundColor','w');
    %% Minimam of Hip Sway

    plot([min_idx_stance/100, min_idx_stance/100], [-30, 30], '--b'); hold on;
    text(min_idx_stance/100, min_val_stance-3, sprintf('Min Timing %d%%: %.2fcm', min_idx_stance, min_val_stance), ...
        'FontSize',14, 'EdgeColor', 'k', 'BackgroundColor','w');
     
    set(fig, 'Visible', 'off');
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);

end
