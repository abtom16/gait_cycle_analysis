%% -- Non-Disabled 
nw_paths = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1107asari_normal.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1205_abe.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub3.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub4.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub5.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub6.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub7.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub9.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub10.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub11.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub12.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub13.xlsx";
};

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Left';  % If you want to analyse right foot, change to 'Right' 
% Gaitdata関節角度、plot_configの変更忘れない！
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\ToeClearance';
save_filename = 'sub4_ToeClearance-NW.png';


% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NORMAL_MEAN_COLOR = [0 0.7 0.7];
NORMAL_RANGE_COLOR = [0.5 0.5 0.5];

%%  data calculation for each procedure
uniform_length = 100;

% NW
all_nw_resampled_angles = [];
for p_idx = 1:length(nw_paths)   
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
        current_cycle = current_nw_data.LToe.z( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle = current_cycle - min(current_cycle(1:20));
        current_cycle = current_cycle * 100;
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
end
fig = figure;
[cfg1, ~] = plot_config('Toe Clearance');  %
cfg1.setup_gait_cycle_axis(); hold on;
cfg1.add_phase_backgrounds(); hold on;
% cfg1.add_normal_range(); hold on;  %
cfg1.add_image_above(); hold on;
%plot(uniform_x_temp,all_nw_resampled_angles, '-k');  % Display individual gait cycle as black lines to visualize their spread
nw_uniform_x = uniform_x_temp;
nw_mean_resampled = mean(all_nw_resampled_angles, 2);
nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
nw_std_max = nw_mean_resampled + nw_std_resampled;
nw_std_min = nw_mean_resampled - nw_std_resampled;
[min_swing_mean, min_swing_idx] = min(nw_mean_resampled(61:100));
[max_swing_mean, max_swing_idx] = max(nw_mean_resampled(61:100));

[min_stance_mean, min_stance_idx] = min(nw_mean_resampled(1:60));
[max_stance_mean, max_stance_idx] = max(nw_mean_resampled(1:30));  %  for knee angle resampled(1:30)

min_swing_idx = min_swing_idx + 60;
max_swing_idx = max_swing_idx + 60;

yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
%  -- plot
% NW
fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
fill(fill_x_nw, fill_y_nw, NORMAL_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
    'DisplayName','Range of Non-Disabled participants'); hold on;
plot(nw_uniform_x, nw_mean_resampled, '-', 'Color', [0.5 0.5 0.5],...
    'HandleVisibility', 'off', 'LineWidth', 1.5); hold on;

legend('Location','northwest')
% save_fullfile = fullfile(save_folder, save_filename);
% saveas(fig, save_fullfile);