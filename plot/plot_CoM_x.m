clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal2.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal2.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-002.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-002.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW2.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW2.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\Modified_sub10_nw-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub10\Modified_sub10_nw-002.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_nw-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_nw-002.xlsx";
%     };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_nw-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_nw-002.xlsx";
%     };


%  Paretic side is Right
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
%     };
nw_paths = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW2.xlsx";
    };
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\Modified_nw-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250728\sub13\Modified_nw-002.xlsx";
%     };



%% -- Non-Disabled 
% nw_paths = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1107asari_normal.xlsx";
% nw_paths = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1205_abe.xlsx";
% nw_paths = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub13.xlsx";

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right' 
% Gaitdata関節角度、plot_configの変更忘れない！
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\CoM_x';
save_filename = 'sub9_Com-X-NW.png';


% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];

%%  data calculation for each procedure
uniform_length = 100;

% NW
all_nw_resampled_angles = [];
all_nw_nonaffected_steplen = [];
for p_idx = 1:length(nw_paths)   
    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        current_nonaffected_steplen = readmatrix(nw_paths{p_idx}, 'Sheet', '歩容特性','Range','C2:C2');
        footside = 'LFoot';
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        current_nonaffected_steplen = readmatrix(nw_paths{p_idx}, 'Sheet', '歩容特性','Range','D2:D2');
        footside = 'RFoot';
    end
    
    all_nw_nonaffected_steplen = [current_nonaffected_steplen, current_nonaffected_steplen];
    for j = 1:length(current_nw_contact_frame)-1
        current_cycle = current_nw_data.CoM.x( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_foot_x = current_nw_data.(footside).x(current_nw_contact_frame(j));
        current_cycle = current_cycle - current_foot_x;
        current_cycle = current_cycle * 100;
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
end
nonaffected_steplen = mean(all_nw_nonaffected_steplen, 2) * 100;

nw_uniform_x = uniform_x_temp;
nw_mean_resampled = mean(all_nw_resampled_angles, 2);
nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
nw_std_max = nw_mean_resampled + nw_std_resampled;
nw_std_min = nw_mean_resampled - nw_std_resampled;

diff_CoMx_nonaffectedfoot = abs(nw_mean_resampled - nonaffected_steplen);
[~, CoM_over_nonaffectedfoot_idx] = min(diff_CoMx_nonaffectedfoot);
CoM_over_nonaffectedfoot_timing = CoM_over_nonaffectedfoot_idx / 100;

%  -- plot
fig = figure('Visible','off');
[cfg, ~] = plot_config('CoM Forward');  %
cfg.setup_gait_cycle_axis(); hold on;
cfg.add_phase_backgrounds(); hold on;
% cfg1.add_normal_range(); hold on;  %
cfg.add_image_above(); hold on;
yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');  % 足部位置
text(0, 0, 'Foot x', 'FontSize', 12,'HorizontalAlignment','left', 'VerticalAlignment','bottom');
yline(nonaffected_steplen, '-', 'Color',[1, 0.5, 0], 'HandleVisibility','off'); %　健側足部位置
text(0, nonaffected_steplen, 'Non Affected Step Length', 'FontSize',12,'HorizontalAlignment','left', 'VerticalAlignment','bottom');

% NW
fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
    'HandleVisibility','off'); hold on;
plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
    'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;


%% 健側歩幅の記載
plot([CoM_over_nonaffectedfoot_timing, CoM_over_nonaffectedfoot_timing],[20, 80],'--r','LineWidth',1.5, 'HandleVisibility','off');
text(CoM_over_nonaffectedfoot_timing, nonaffected_steplen, sprintf('%d%%', CoM_over_nonaffectedfoot_idx), ...
    'FontSize',14, 'HorizontalAlignment','right', 'VerticalAlignment','bottom');

set(fig, 'Visible', 'off');

save_fullfile = fullfile(save_folder, save_filename);
saveas(fig, save_fullfile);


