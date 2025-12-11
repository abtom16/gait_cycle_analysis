clc;
addpath(genpath(fullfile(pwd,'..', '..')));

%%  this program is for checking the diffence between each experiment procedure. nw means Normal Walking. dr means During Rehabilitation. as means Assist Walking %%
% sub1 
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_handle1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_handle2.xlsx";
%     };
% as_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_assist1.xlsx"
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_assist2.xlsx"
%     };
% 


% sub3
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal2.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_handle2.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_handle3.xlsx";
%     };
% as_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_assist3.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_assist4.xlsx";
%     };

% sub4
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal2.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_handling1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_handling2.xlsx";
%     };
% as_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_assist1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_assist2.xlsx";
%     };

% sub5
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-002.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_handling_ver2-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_handling_ver2-002.xlsx";
%     };
% as_paths =  {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_assist-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_assist-002.xlsx";
%     };

% sub6
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-002.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_handling_ver3-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_handling_ver3-002.xlsx";
%     };
% as_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_assist-001.xlsx"
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_assist-002.xlsx"
%     };

% sub7
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW2.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_DR1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_DR2.xlsx";
%     };
% as_paths = {
% %     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_AS1.xlsx";
% %     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_AS1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_AS3.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_AS4.xlsx";
%     };

% sub8
nw_paths = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW2.xlsx";
    };
dr_paths = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_DR3.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_DR4.xlsx";
    };
% as_paths = {
%     % "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_AS1.xlsx";
%     % "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_AS2.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_AS3.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_AS4.xlsx";
%     };

% sub11
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_nw-001.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_nw-002.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_dr-003.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_dr-004.xlsx";
%     };

%  sub2  Take Care! Paretic side is Right
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_handle1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_hundle2.xlsx";
%     };
% as_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_assist5(change_pos).xlsx"
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_assist6(change_pos).xlsx"
%     };
% sub9
% nw_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW2.xlsx";
%     };
% dr_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_DR1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_DR2.xlsx";
%     };
% as_paths = {
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_AS1.xlsx";
%     "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_AS2.xlsx";
%     % "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_AS3.xlsx";
%     % "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_AS4.xlsx";
%     };

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Left';  % If you want to analyse right foot, change to 'Right'
% Analyse 'Hip' or 'Knee'
target_joint = 'Hip'; 
if strcmpi(target_foot, 'Left')
    jointLR_field = 'LKnee';
    foot_contact_field = 'LFootContact';
elseif strcmpi(target_foot, 'Right')
    jointLR_field = 'RKnee';
    foot_contact_field = 'RFootContact';
else
    error('target_foot must be ''Left'' or ''Right''.');
end

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
        current_cycle = current_nw_data.CoM.z( ...  % 元(jointLR_field).angle
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle = current_cycle - min(current_cycle);  %
        current_cycle = current_cycle * 100; % scaling for cm
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
end
% figure;
% [cfg1, ~] = plot_config('CoM Vertical');  %
% cfg1.add_phase_backgrounds();
% cfg1.setup_gait_cycle_axis();
% % cfg1.add_gait_event_markers()
% cfg1.add_normal_range();
% cfg1.add_image_above();
% hold on;
% plot(uniform_x_temp,all_nw_resampled_angles, '-k');

nw_uniform_x = uniform_x_temp;
nw_mean_resampled = mean(all_nw_resampled_angles, 2);
nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
nw_std_max = nw_mean_resampled + nw_std_resampled;
nw_std_min = nw_mean_resampled - nw_std_resampled;
% DR
all_dr_resampled_angles = [];
for p_idx = 1:length(dr_paths)
    current_dr_data = GaitData(dr_paths{p_idx}, '時系列データ 5m');
    [dr_Rcontact_frame, dr_Rcontact_end_frame,dr_Lcontact_frame, dr_Lcontact_end_frame] = ...
        detectValidFootContacts(current_dr_data.RFootContact, current_dr_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_dr_contact_frame = dr_Lcontact_frame;
        current_dr_contact_end_frame = dr_Lcontact_end_frame;
    else  % only case for Right
        current_dr_contact_frame = dr_Rcontact_frame;
        current_dr_contact_end_frame = dr_Rcontact_end_frame;
    end

    for j = 1:length(current_dr_contact_frame)-1
        current_cycle = current_dr_data.CoM.z( ...  %
            current_dr_contact_frame(j):current_dr_contact_frame(j+1));
        current_cycle = current_cycle - min(current_cycle);  %
        current_cycle = current_cycle * 100; %  scaling for cm
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x_temp = linspace(0, 1, uniform_length);
        resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);

        all_dr_resampled_angles = [all_dr_resampled_angles, resampled_cycle'];
    end
end
dr_uniform_x = uniform_x_temp;
dr_mean_resampled = mean(all_dr_resampled_angles, 2);
dr_std_resampled = std(all_dr_resampled_angles, 1, 2);
dr_std_max = dr_mean_resampled + dr_std_resampled;
dr_std_min = dr_mean_resampled - dr_std_resampled;

[min_dr_stance, minidx_dr_stance] = min(dr_mean_resampled(1:40)); %% 2回重心が上下動し、麻痺側が接地した後すぐの最下点を知りたいため、歩行周期1～60％を指す立脚期のうち、1:40のデータを使用している。
[max_dr_stance, maxidx_dr_stance] = max(dr_mean_resampled(1:40));
minidx_dr_stance = minidx_dr_stance / 100;
maxidx_dr_stance = maxidx_dr_stance / 100;

% AS
% all_as_resampled_angles = [];
% for p_idx = 1:length(as_paths)
%     current_as_data = GaitData(as_paths{p_idx}, '時系列データ 5m');
%     [as_Rcontact_frame, as_Rcontact_end_frame,as_Lcontact_frame, as_Lcontact_end_frame] = ...
%         detectValidFootContacts(current_as_data.RFootContact, current_as_data.LFootContact);
% 
%     if strcmpi(target_foot, 'Left')
%         current_as_contact_frame = as_Lcontact_frame;
%         current_as_contact_end_frame = as_Lcontact_end_frame;
%     else  % only case for Right
%         current_as_contact_frame = as_Rcontact_frame;
%         current_as_contact_end_frame = as_Rcontact_end_frame;
%     end
% 
%     for j = 1:length(current_as_contact_frame)-1
%         current_cycle = current_as_data.(jointLR_field).angle( ...  %
%             current_as_contact_frame(j):current_as_contact_frame(j+1));
%         original_x = linspace(0, 1, length(current_cycle));
%         uniform_x_temp = linspace(0, 1, uniform_length);
%         resampled_cycle = interp1(original_x, current_cycle, uniform_x_temp);
% 
%         all_as_resampled_angles = [all_as_resampled_angles, resampled_cycle'];
%     end
% end
% as_uniform_x = uniform_x_temp;
% as_mean_resampled = mean(all_as_resampled_angles, 2);
% as_std_resampled = std(all_as_resampled_angles, 1, 2);
% as_std_max = as_mean_resampled + as_std_resampled;
% as_std_min = as_mean_resampled - as_std_resampled;

%%  color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];

DR_MEAN_COLOR = [0 0 0.7];
DR_RANGE_COLOR = [0.4 0.6 1];

AS_MEAN_COLOR = [0.6 0 0];
AS_RANGE_COLOR = [1 0.6 0.6];

%%  y lim
Y_LIM = [-15, 45];

%%  --- Graph1: NW vs DR ---
fig1 = figure;
[cfg1, ~] = plot_config('CoM Vertical');  %
cfg1.add_phase_backgrounds();
cfg1.setup_gait_cycle_axis();
% cfg1.add_gait_event_markers()
cfg1.add_normal_range();
cfg1.add_image_above();
hold on;

% NW
fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
    'HandleVisibility','off');
plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
    'DisplayName', 'Normal Walking', 'LineWidth', 1.5);
% DR
fill_x_dr = [dr_uniform_x, fliplr(dr_uniform_x)];
fill_y_dr = [dr_std_min', fliplr(dr_std_max')];
fill(fill_x_dr, fill_y_dr, DR_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
    'HandleVisibility','off');
plot(dr_uniform_x, dr_mean_resampled, '-', 'Color',DR_MEAN_COLOR, ...
    'DisplayName', 'During Rehabilitation', 'LineWidth', 2);

% 20250819 calcurating minimum of CoM-z Motion and maximum of CoM-z Motion

plot([nw_uniform_x(1),nw_uniform_x(50)],[max_dr_stance,max_dr_stance], '--b', 'HandleVisibility','off'); hold on;
plot([nw_uniform_x(1),nw_uniform_x(50)],[min_dr_stance,min_dr_stance], '--b', 'HandleVisibility','off'); hold on;
text(minidx_dr_stance, min_dr_stance, sprintf('Min%d%%: %.2fcm', minidx_dr_stance*100, min_dr_stance), "FontSize",12,'Color',DR_MEAN_COLOR,...
    'HorizontalAlignment','left', 'VerticalAlignment','top'); hold on;
text(maxidx_dr_stance, max_dr_stance, sprintf('Max%d%%: %.2fcm', maxidx_dr_stance*100, max_dr_stance), "FontSize",12,'Color',DR_MEAN_COLOR, ...
    'HorizontalAlignment','center', 'VerticalAlignment','bottom'); hold on;

legend('Location','northeast');


% %%  --- Graph2: NW vs AS ---
% fig2 = figure('Visible','off');
% [cfg2, ~] = plot_config('Knee Angle');  %
% cfg2.add_phase_backgrounds();
% cfg2.setup_gait_cycle_axis();
% % cfg2.add_gait_event_markers()
% cfg2.add_normal_range();
% cfg2.add_image_above();
% hold on;
% 
% % NW
% fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
% fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
% fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
%     'HandleVisibility','off');
% plot(nw_uniform_x, nw_mean_resampled, '--', 'Color',NW_MEAN_COLOR, ...
%     'DisplayName', 'Normal Walking', 'LineWidth', 1.5);
% % AS
% fill_x_as = [as_uniform_x, fliplr(as_uniform_x)];
% fill_y_as = [as_std_min', fliplr(as_std_max')];
% fill(fill_x_as, fill_y_as, AS_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
%     'HandleVisibility','off');
% plot(as_uniform_x, as_mean_resampled, '-', 'Color', AS_MEAN_COLOR, ...
%     'DisplayName', 'Assist Walking', 'LineWidth', 2);
% 
% legend('Location','northeast');
% 
% 
% %%  ---Graph3: DR vs AS ---
% fig3 = figure('Visible','off');
% [cfg3, ~] = plot_config('Knee Angle');  %
% cfg3.add_phase_backgrounds();
% cfg3.setup_gait_cycle_axis();
% % cfg3.add_gait_event_markers()
% cfg3.add_normal_range();
% cfg3.add_image_above();
% hold on;
% 
% % NW
% fill_x_dr = [dr_uniform_x, fliplr(dr_uniform_x)];
% fill_y_dr = [dr_std_min', fliplr(dr_std_max')];
% fill(fill_x_dr, fill_y_dr, DR_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
%     'HandleVisibility','off');
% plot(dr_uniform_x, dr_mean_resampled, '-', 'Color',DR_MEAN_COLOR, ...
%     'DisplayName', 'During Rehabilitation', 'LineWidth', 2);
% % AS
% fill_x_as = [as_uniform_x, fliplr(as_uniform_x)];
% fill_y_as = [as_std_min', fliplr(as_std_max')];
% fill(fill_x_as, fill_y_as, AS_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
%     'HandleVisibility','off');
% plot(as_uniform_x, as_mean_resampled, '-', 'Color', AS_MEAN_COLOR, ...
%     'DisplayName', 'Assist Walking', 'LineWidth', 2);
% 
% legend('Location','northeast');
% 
% %%  -- Graph4: standard deviation of each procedure
% fig4 = figure('Visible','off');
% plot(nw_uniform_x, nw_std_resampled, 'DisplayName', 'NW', 'Color',NW_MEAN_COLOR); hold on;
% plot(dr_uniform_x, dr_std_resampled, 'DisplayName', 'DR', 'Color',DR_MEAN_COLOR); hold on;
% plot(as_uniform_x, as_std_resampled, 'DisplayName','AS', 'Color',AS_MEAN_COLOR); hold on;
% title('Standard Deviation of During Rehabilitation');
% xlabel('Gait Cycle [%]', 'FontSize',16);
% ylabel('Std Dev [deg]', 'FontSize',16);
% legend(Location="best");

% save figure
savepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\03_forCoResearch\20250621データ共有会\sub8";
SAVE_DPI = 600;  % the image quality for conference submissions is often 600DPI

save_filename1 = fullfile(savepath, 'CoM-z_NW_vs_DR.png');
print(fig1, save_filename1, '-dpng', ['-r', num2str(SAVE_DPI)]);
% 
% save_filename2 = fullfile(savepath, 'Knee_NW_vs_AS.png');
% print(fig2, save_filename2, '-dpng', ['-r', num2str(SAVE_DPI)]);
% 
% save_filename3 = fullfile(savepath, 'Knee_DR_vs_AS.png');
% print(fig3, save_filename3, '-dpng', ['-r', num2str(SAVE_DPI)]);
% 
% save_filename4 = fullfile(savepath, 'Knee_std.png');
% print(fig4, save_filename4, '-dpng', ['-r', num2str(SAVE_DPI)]);

disp('Completely Processed!');
