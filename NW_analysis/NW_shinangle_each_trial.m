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
    'sub15_1';
    'sub15_2';
};
filename_right = {
    'sub9_1';
    'sub9_2';
    'sub13_1';
    'sub13_2';
    'sub16_1';
    'sub16_2';
};

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right' 
% Gaitdata関節角度、plot_configの変更忘れない！
if strcmp(target_foot, 'Left')
    nw_paths = nw_paths_left;
    filenames = filename_left;
else
    nw_paths = nw_paths_right;
    filenames = filename_right;
end

for p_idx=1:length(nw_paths)
    save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\ShinAngle\EachTrial';
    save_filename = [filenames{p_idx}, '-NW.fig'];
    
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
        shank_side = 'LShank';
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        foot_side='RFoot';
        shank_side = 'RShank';
    end
    whole_data = [];
    for j = 1:length(current_nw_contact_frame)-1
        current_cycle_foot_x = current_nw_data.(foot_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_x = current_nw_data.(shank_side).x( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_shank_z = current_nw_data.(shank_side).z( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));  
        
        shin_angle_rad = atan2(current_cycle_shank_z, current_cycle_shank_x - current_cycle_foot_x);
        shin_angle_deg = rad2deg(shin_angle_rad);
        shin_angle = 90 - shin_angle_deg;
        
        original_x = linspace(0, 1, length(shin_angle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, shin_angle, uniform_x_temp);

        whole_data = [whole_data, resampled_cycle'];
    end
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(whole_data, 2);
    nw_std_resampled = std(whole_data, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;

    abs_angles = abs(nw_mean_resampled);
    [min_val, min_idx] = min(abs_angles(1:40));
    min_idx = min_idx - 1;

    
    %  -- plot
    fig = figure;
    [cfg1, ~] = plot_config('Shin Angle');  %
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
    
    
    plot([min_idx/100, min_idx/100], [-30, 30], '--b'); hold on;
    text(min_idx/100, min_val-5, sprintf('Vertical Timing: %d', min_idx), ...
    'FontSize',14, 'EdgeColor', 'k', 'BackgroundColor','w');
     
    
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);

end
