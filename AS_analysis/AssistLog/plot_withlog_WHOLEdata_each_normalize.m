clc;
addpath(genpath(fullfile(pwd,'..', '..')));

%%  Appologies if it's hard to look
% filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_assist1.xlsx";
% log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\4人目1回目.xlsx"; 
% sync_frame = 192;  

% filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_assist2.xlsx";
% log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\4人目2回目.xlsx"; 
% sync_frame = 224;
%
% filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_assist-001.xlsx";
% log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\5人目1回目.xlsx"; 
% sync_frame = 228;
% filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_assist-002.xlsx";
% log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\5人目2回目.xlsx"; 
% sync_frame = 211;
% 
% filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_assist-001.xlsx";
% log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\6人目1回目.xlsx"; 
% sync_frame = 152;
filepath = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_assist-002.xlsx";
log_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\assist_log\6人目2回目.xlsx"; 
sync_frame = 455;
%%

figure_dirs = make_fig_directories(filepath);
save_dir = figure_dirs.withLOG_eachstep;
if ~exist(save_dir,'dir')
    error('Save directory does not exist');
end
data = GaitData(filepath, '時系列データ 11m');
assist_log = readmatrix(log_path);



data_len = length(data.RFootContact(sync_frame:end));

log_time = assist_log(1:data_len,4);   %%  log dataのA行データ番号はフレーム数ではなかった。　タイムスタンプから時間を導出していたので、この時間を使用 
log_data = assist_log(1:data_len,7);

[Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame] = detectValidFootContacts(data.RFootContact(sync_frame:end), data.LFootContact(sync_frame:end));

%
Rangle_data = data.RHip.extension(sync_frame:end);
Langle_data = data.LHip.extension(sync_frame:end);
% 

Rcontact_frame_time = Rcontact_frame * 1/60;
Lcontact_frame_time = Lcontact_frame * 1/60;
time = (1:length(Rangle_data)) * 1/60 ;

% angle plot Rangle
normalize_figure_Rside = fullfile(save_dir, '(Normalize)Right_side');
normalize_figure_Lside = fullfile(save_dir, '(Normalize)Left_side');
if ~exist(normalize_figure_Rside, 'dir')
    mkdir(normalize_figure_Rside);
end
if ~exist(normalize_figure_Lside, 'dir')
    mkdir(normalize_figure_Lside);
end

% Right side
% for i=1: length(Rcontact_frame_time)-1
%     figure('Visible','off');
%     [cfg, ~] = plot_config('Hip Flexion');
%     cfg.add_phase_backgrounds()
%     cfg.setup_gait_cycle_axis()
%     cfg.add_gait_event_markers()
%     cfg.add_normal_range()
%     cfg.add_image_above() ;hold on;
%     idx_angle = (time>= Rcontact_frame_time(i)) & (time < Rcontact_frame_time(i+1));
%     idx_log = (log_time>= Rcontact_frame_time(i)) & (log_time < Rcontact_frame_time(i+1));
% 
%     plot(time(idx_angle), Rangle_data(idx_angle),'DisplayName','Right Leg', 'Color', [1, 0.5, 0], 'LineWidth',5); hold on;
%     ylabel('Hip Flexion  [deg]');
%     y_lim = [-15,45];
%     ylim(y_lim);
%     add_phase_backgrounds(Rcontact_frame,Rcontact_end_frame,y_lim); hold on;
%     text(Rcontact_frame_time(i)-0.1, max(ylim)-0.1, 'Flexion', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
%     annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
%     text(Rcontact_frame_time(i)-0.1, min(ylim), 'Extension', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
%     annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
% 
%     % Log
%     yyaxis right
%     plot(log_time(idx_log), log_data(idx_log)*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2);
%     ylabel('Assist Signal');
%     yticks([0 0.8]);
%     yticklabels({'0', '1'});
%     ylim([0 1]);
% 
%     % Common
%     title(sprintf('Step %d Right side (%.2f-%.2f sec)', i, Rcontact_frame_time(i), Rcontact_frame_time(i+1)));
%     xlim([Rcontact_frame_time(i), Rcontact_frame_time(i+1)]);
%     xlabel('Time [s]');
%     legend('Location','best');
% 
%     filename = sprintf('step_%02d.jpeg', i);
%     save_file = fullfile(normalize_figure_Rside, filename);
%     saveas(gcf, save_file);
% end

% Left side
num_segments = length(Lcontact_frame) - 1;
onsets = [];
offsets = [];
for i=1: length(Lcontact_frame_time)-1
    % figure('Visible','off');
    figure;
    [cfg, ~] = plot_config('Hip Flexion');
    cfg.add_phase_backgrounds()
    cfg.setup_gait_cycle_axis()
    cfg.add_gait_event_markers()
    cfg.add_normal_range()
    cfg.add_image_above() ;hold on;

    for j = 1:num_segments
        % 論理インデックス：この区間に相当するログの範囲
        idx_log = (time >= Lcontact_frame_time(j)) & (time < Lcontact_frame_time(j+1));
        
        % 該当データを抽出（モーターの0/1信号）
        segment_data = log_time(idx_log);
        
        % 長さを100にリサンプリング（interpolation）
        resampled = interp1(...
            linspace(0, 1, length(segment_data)), ...
            double(segment_data), ...
            linspace(0, 1, 100), ...
            'nearest');  % 最近傍 or 'linear'
        
        % 差分をとって立ち上がり/立ち下がりを検出
        diff_data = diff(resampled);
        onset_idx = find(diff_data == 1);   % 0→1
        offset_idx = find(diff_data == -1); % 1→0
    
        % 保存（複数あれば全部保存）
        onsets = [onsets, onset_idx];
        offsets = [offsets, offset_idx];
    end

% 平均タイミング（0〜100のうちの何番目か）
    mean_onset  = mean(onsets);
    mean_offset = mean(offsets);
    mean_range  = mean_offset - mean_onset;
    assistlog_wave = zeros(1, 100);
    assistlog_wave(mean_onset:mean_offset) = 0.8;
    % Log
    yyaxis right
    plot(linspace(0, 100, 100), assistlog_wave, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2); hold on;
    ylabel('Assist Signal');
    yticks([0 0.8]);
    yticklabels({'0', '1'});
    ylim([0 1]);

    idx_angle = (time>= Lcontact_frame_time(i)) & (time < Lcontact_frame_time(i+1));
    
        
    plot(time(idx_angle), Langle_data(idx_angle),'DisplayName','Left Leg', 'Color', [0, 0, 1], 'LineWidth',2); hold on;
    % ylabel('Hip Flexion  [deg]');
    % y_lim = [-15,45];
    % ylim(y_lim);
    % add_phase_backgrounds(Lcontact_frame,Lcontact_end_frame,y_lim); hold on;
    % text(Lcontact_frame_time(i)-0.1, max(ylim)-0.1, 'Flexion', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    % annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    % text(Lcontact_frame_time(i)-0.1, min(ylim), 'Extension', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    % annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    

    
    % Common
    title(sprintf('Step %d Left side (%.2f-%.2f sec)', i, Lcontact_frame_time(i), Lcontact_frame_time(i+1)));
    xlim([Lcontact_frame_time(i), Lcontact_frame_time(i+1)]);
    xlabel('Time [s]');
    legend('Location','best');
    
    % filename = sprintf('step_%02d.jpeg', i);
    % save_file = fullfile(normalize_figure_Lside, filename);
    % saveas(gcf, save_file);
end

disp('Completely Processed!')
