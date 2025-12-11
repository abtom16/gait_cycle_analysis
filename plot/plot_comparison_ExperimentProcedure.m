clc;
addpath(genpath(fullfile(pwd,'..', '..')));

%%  this program is for robomech. nw means Normal Walking. dr means During Rehabilitation  %%

nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal0.xlsx";
dr_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_handling1.xlsx";
as_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_assist1.xlsx";

% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
% dr_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_handling_ver2-001.xlsx";

% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
% dr_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_handling_ver3-002.xlsx";
% % 
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
% dr_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_handle1.xlsx";
% 
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
% dr_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_hundle2.xlsx";

% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
% dr_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_handle3.xlsx";


savepath = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\02_forRobomech';

nw_data = GaitData(nw_path, '時系列データ 5m');
dr_data = GaitData(dr_path, '時系列データ 5m');
as_data = GaitData(as_path, '時系列データ 5m');

[nw_Rcontact_frame, nw_Rcontact_end_frame, nw_Lcontact_frame, nw_Lcontact_end_frame] = detectValidFootContacts(nw_data.RFootContact, nw_data.LFootContact);
[dr_Rcontact_frame, dr_Rcontact_end_frame, dr_Lcontact_frame, dr_Lcontact_end_frame] = detectValidFootContacts(dr_data.RFootContact, dr_data.LFootContact);
[as_Rcontact_frame, as_Rcontact_end_frame, as_Lcontact_frame, as_Lcontact_end_frame] = detectValidFootContacts(as_data.RFootContact, as_data.LFootContact);

figure;

[cfg, ~] = plot_config('Hip Flexion');
cfg.add_phase_backgrounds()
cfg.setup_gait_cycle_axis()
% cfg.add_gait_event_markers()
cfg.add_normal_range()
cfg.add_image_above() ;hold on;

uniform_length = 100;
%%  normal walking
for j = 1:length(nw_Lcontact_frame)-1
    nw_current_cycle = nw_data.LHip.extension(nw_Lcontact_frame(j):nw_Lcontact_frame(j+1));
    nw_original_x = linspace(0, 1, length(nw_current_cycle));
    nw_uniform_x = linspace(0, 1, uniform_length);
    nw_resampled_angles(:, j) = interp1(nw_original_x, nw_current_cycle, nw_uniform_x);
    % plot(nw_uniform_x, nw_resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
end

nw_mean_resampled = mean(nw_resampled_angles, 2);
nw_std_resampled = std(nw_resampled_angles, 1, 2);
nw_std_max = nw_mean_resampled + nw_std_resampled;
nw_std_min = nw_mean_resampled - nw_std_resampled;

plot(nw_uniform_x, nw_mean_resampled, '--','Color',[0 0.7 0.7], 'DisplayName', 'Normal Walking', ...
    'LineWidth', 1.5); hold on;  %  [0 0.7 0.7] is cyan

% -visualize variance of step
plot(nw_uniform_x, nw_std_max, '--', 'Color',[0 0.7 0.7], 'HandleVisibility','off'); hold on;
plot(nw_uniform_x, nw_std_min, '--','Color',[0 0.7 0.7], 'HandleVisibility','off'); hold on;
for k=1:99
    bg_cyan = fill([nw_uniform_x(k), nw_uniform_x(k+1), nw_uniform_x(k+1), nw_uniform_x(k)], ...
        [nw_std_min(k), nw_std_min(k+1),nw_std_max(k+1),nw_std_max(k)], [0.6, 0.9, 0.9], ...
        'FaceAlpha', 0.3,'EdgeColor','none','HandleVisibility','off'); hold on;
end
% -

ylim([-15, 45]);  %

%% during rehabilitation
for j = 1:length(dr_Lcontact_frame)-1
    dr_current_cycle = dr_data.LHip.extension(dr_Lcontact_frame(j):dr_Lcontact_frame(j+1));
    dr_original_x = linspace(0, 1, length(dr_current_cycle));
    dr_uniform_x = linspace(0, 1, uniform_length);
    dr_resampled_angles(:, j) = interp1(dr_original_x, dr_current_cycle, dr_uniform_x);
    % plot(dr_uniform_x, dr_resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
end
dr_mean_resampled = mean(dr_resampled_angles, 2);
dr_std_resampled = std(dr_resampled_angles, 1, 2);
dr_std_max = dr_mean_resampled + dr_std_resampled;
dr_std_min = dr_mean_resampled - dr_std_resampled;

plot(dr_uniform_x, dr_mean_resampled, '-b', 'DisplayName', 'During Rehabilitation', 'LineWidth', 2); hold on;
plot(dr_uniform_x, dr_std_max, '-b', 'HandleVisibility','off'); hold on;
plot(dr_uniform_x, dr_std_min, '-b', 'HandleVisibility','off'); hold on;
for k=1:99
    bg_blue = fill([dr_uniform_x(k), dr_uniform_x(k+1), dr_uniform_x(k+1), dr_uniform_x(k)], ...
        [dr_std_min(k), dr_std_min(k+1), dr_std_max(k+1),dr_std_max(k)], [0.4, 0.6, 1], ...
        'FaceAlpha', 0.3,'EdgeColor','none','HandleVisibility','off'); hold on;
end
legend('Location', 'northeast');

%%  assist walking
for j = 1:length(as_Lcontact_frame)-1
    as_current_cycle = as_data.LHip.extension(as_Lcontact_frame(j):as_Lcontact_frame(j+1));
    as_original_x = linspace(0, 1, length(as_current_cycle));
    as_uniform_x = linspace(0, 1, uniform_length);
    as_resampled_angles(:, j) = interp1(as_original_x, as_current_cycle, as_uniform_x);
end
as_mean_resampled = mean(as_resampled_angles, 2);
as_std_resampled = std(as_resampled_angles, 1, 2);
as_std_max = as_mean_resampled + as_std_resampled;
as_std_min = as_mean_resampled - as_std_resampled;

plot(as_uniform_x, as_mean_resampled, '-','Color',[0.6 0 0], 'DisplayName', 'Assist Walking', 'LineWidth', 2); hold on;
plot(as_uniform_x, as_std_max, '-','Color',[0.6 0 0], 'HandleVisibility','off'); hold on;
plot(as_uniform_x, as_std_min, '-','Color',[0.6 0 0], 'HandleVisibility','off'); hold on;
for k=1:99
    bg_brue = fill([as_uniform_x(k), as_uniform_x(k+1), as_uniform_x(k+1), as_uniform_x(k)], ...
        [as_std_min(k), as_std_min(k+1), as_std_max(k+1),as_std_max(k)], [1, 0.6, 0.6], ...
        'FaceAlpha', 0.3,'EdgeColor','none','HandleVisibility','off'); hold on;
end










%%  Right side
% for j = 1:length(nw_Rcontact_frame)-1
%     nw_current_cycle = nw_data.RKnee.angle(nw_Rcontact_frame(j):nw_Rcontact_frame(j+1));
%     nw_original_x = linspace(0, 1, length(nw_current_cycle));
%     nw_uniform_x = linspace(0, 1, uniform_length);
%     nw_resampled_angles(:, j) = interp1(nw_original_x, nw_current_cycle, nw_uniform_x);
%     % plot(nw_uniform_x, nw_resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
% end
% 
% nw_mean_resampled = mean(nw_resampled_angles, 2);
% plot(nw_uniform_x, nw_mean_resampled, '--','Color',[1, 0.5, 0], 'DisplayName', 'Normal Walking', 'LineWidth', 2); hold on;
% 
% for j = 1:length(dr_Rcontact_frame)-1
%     dr_current_cycle = dr_data.RKnee.angle(dr_Rcontact_frame(j):dr_Rcontact_frame(j+1));
%     dr_original_x = linspace(0, 1, length(dr_current_cycle));
%     dr_uniform_x = linspace(0, 1, uniform_length);
%     dr_resampled_angles(:, j) = interp1(dr_original_x, dr_current_cycle, dr_uniform_x);
%     % plot(dr_uniform_x, dr_resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
% end
% 
% dr_mean_resampled = mean(dr_resampled_angles, 2);
% plot(dr_uniform_x, dr_mean_resampled, '-','Color', [1, 0.5, 0],'DisplayName', 'During Rehabilitation', 'LineWidth', 2); hold on;
% legend('Location', 'best');