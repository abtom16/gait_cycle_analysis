clc;
addpath(genpath(fullfile(pwd,'..', '..')));

filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_assist-002.xlsx";
log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\6人目2回目.xlsx";

%% 
sync_frame = 455;  
%%

data = GaitData(filepath, '時系列データ 11m');
assist_log = readmatrix(log_path);


% frame = assist_log(:,1)+sync_frame;
frame = assist_log(:,1);
log_data = assist_log(:,7);

[Rcontact_frame, ~, Lcontact_frame, ~] = detectValidFootContacts(data.RFootContact(sync_frame:end), data.LFootContact(sync_frame:end));


figure;
%
[cfg, export_filename] = plot_config('Hip Flexion');
%

cfg.add_phase_backgrounds()
cfg.setup_gait_cycle_axis()
cfg.add_gait_event_markers()
cfg.add_image_above()
cfg.add_normal_range()

%
Rangle_data = data.RHip.extension(sync_frame:end);
Langle_data = data.LHip.extension(sync_frame:end);

時刻で同期しないといけないかも

uniform_length = 100;
for i = 1:length(Rcontact_frame)-1
    Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
    Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
    Runiform_x = linspace(0, 1, uniform_length);
    Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
    % plot(Runiform_x, Rresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
end
for i = 1:length(Lcontact_frame)-1
    Lcurrent_cycle = Langle_data(Lcontact_frame(i):Lcontact_frame(i+1));
    Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
    Luniform_x = linspace(0, 1, uniform_length);
    Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
    % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
end

right_label = 'Right Average';
left_label = 'Left Average ＊Paralyzed side';

Rmean_resampled = mean(Rresampled_angles, 2);
plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
Lmean_resampled = mean(Lresampled_angles, 2);
plot(Luniform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;

assist_start_positions = [];
assist_end_positions = [];

for i = 1:length(Rcontact_frame)-1
    start_frame = Rcontact_frame(i);
    end_frame = Rcontact_frame(i+1);

    % この周期のログデータ取得
    in_range_idx = (frame >= start_frame) & (frame <= end_frame);
    if sum(in_range_idx) == 0
        continue;
    end

    cycle_frame = frame(in_range_idx);
    cycle_log = log_data(in_range_idx);

    % 差分を見て変化点を検出（立ち上がり＝1、立ち下がり＝-1）
    diff_log = diff([0; cycle_log]);  % 先頭に0追加して揃える
    on_indices = find(diff_log == 1);
    off_indices = find(diff_log == -1);

    % 始まりと終わりの時刻（フレーム）を取得
    if ~isempty(on_indices)
        on_frame = cycle_frame(on_indices(1));
        norm_on = (on_frame - start_frame) / (end_frame - start_frame);
        assist_start_positions(end+1) = norm_on;
    end
    if ~isempty(off_indices)
        off_frame = cycle_frame(off_indices(end));
        norm_off = (off_frame - start_frame) / (end_frame - start_frame);
        assist_end_positions(end+1) = norm_off;
    end
end

% 平均開始・終了タイミングを算出
mean_on = mean(assist_start_positions);
mean_off = mean(assist_end_positions);

% プロットに追加（縦線として表示）
y_range = ylim;
plot([mean_on mean_on], y_range, '--r', 'DisplayName', 'Mean Assist Start', 'LineWidth', 2);
plot([mean_off mean_off], y_range, '--g', 'DisplayName', 'Mean Assist End', 'LineWidth', 2);
legend('Location','best');

%% ------  測定区間バージョン -----
%%%  11mでグラフ導出したものと変化ありませんでした

% data_5m = GaitData(filepath, '時系列データ 5m');
% [Rcontact_frame_5m, ~, Lcontact_frame_5m, ~] = detectValidFootContacts(data_5m.RFootContact, data_5m.LFootContact);
% 
% figure;
% [cfg, export_filename] = plot_config('Hip Flexion');
% 
% cfg.add_phase_backgrounds()
% cfg.setup_gait_cycle_axis()
% cfg.add_gait_event_markers()
% cfg.add_image_above()
% cfg.add_normal_range()
% 
% Rangle_data = data_5m.RHip.extension;
% Langle_data = data_5m.LHip.extension;
% 
% uniform_length = 100;
% for i = 1:length(Rcontact_frame_5m)-1
%     Rcurrent_cycle = Rangle_data(Rcontact_frame_5m(i):Rcontact_frame_5m(i+1));
%     Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
%     Runiform_x = linspace(0, 1, uniform_length);
%     Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
%     % plot(Runiform_x, Rresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
% end
% for i = 1:length(Lcontact_frame_5m)-1
%     Lcurrent_cycle = Langle_data(Lcontact_frame_5m(i):Lcontact_frame_5m(i+1));
%     Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
%     Luniform_x = linspace(0, 1, uniform_length);
%     Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
%     % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
% end
% 
% right_label = 'Right Average';
% left_label = 'Left Average ＊Paralyzed side';
% 
% Rmean_resampled = mean(Rresampled_angles, 2);
% plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
% Lmean_resampled = mean(Lresampled_angles, 2);
% plot(Luniform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;