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
figure_Rside = fullfile(save_dir, 'Right_side');
figure_Lside = fullfile(save_dir, 'Left_side');
if ~exist(figure_Rside, 'dir')
    mkdir(figure_Rside);
end
if ~exist(figure_Lside, 'dir')
    mkdir(figure_Lside);
end

% Right side
for i=1: length(Rcontact_frame_time)-1
    figure('Visible','off');
    idx_angle = (time>= Rcontact_frame_time(i)) & (time < Rcontact_frame_time(i+1));
    idx_log = (log_time>= Rcontact_frame_time(i)) & (log_time < Rcontact_frame_time(i+1));
        
    plot(time(idx_angle), Rangle_data(idx_angle),'DisplayName','Right Leg', 'Color', [1, 0.5, 0], 'LineWidth',5); hold on;
    ylabel('Hip Flexion  [deg]');
    y_lim = [-15,45];
    ylim(y_lim);
    add_phase_backgrounds(Rcontact_frame,Rcontact_end_frame,y_lim); hold on;
    text(Rcontact_frame_time(i)-0.1, max(ylim)-0.1, 'Flexion', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(Rcontact_frame_time(i)-0.1, min(ylim), 'Extension', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % Log
    yyaxis right
    plot(log_time(idx_log), log_data(idx_log)*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2);
    ylabel('Assist Signal');
    yticks([0 0.8]);
    yticklabels({'0', '1'});
    ylim([0 1]);
    
    % Adding time of starting Assist 
    diff_log = diff(current_log_data);
    assist_start_idx = find(diff_log == 1);
    assist_start_time = current_log_time(assist_start_idx);
    assist_end_idx = find(diff_log == -1);
    assist_end_time = current_log_time(assist_end_idx);
   
    assist_start_str = sprintf('%.2fs', assist_start_time);
    text_assist_start = text(assist_start_time, ax.YAxis(2).Limits(2)*0.8, assist_start_str, ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
             'Color', [0 1 0], 'FontSize', 14, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);

    assist_end_str = sprintf('%.2fs', assist_end_time);
    text_assist_end = text(assist_end_time+0.03, ax.YAxis(2).Limits(2)*0.8, assist_end_str, ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
        'Color', [0 1 0], 'FontSize', 14, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);
    % ---

    % Common
    title(sprintf('Step %d Right side (%.2f-%.2f sec)', i, Rcontact_frame_time(i), Rcontact_frame_time(i+1)));
    xlim([Rcontact_frame_time(i), Rcontact_frame_time(i+1)]);
    xlabel('Time [s]');
    legend('Location','northeast');
    
    filename = sprintf('step_%02d.jpeg', i);
    save_file = fullfile(figure_Rside, filename);
    saveas(gcf, save_file);
end

% Left side
for i=1: length(Lcontact_frame_time)-1
    figure('Visible','off');
    idx_angle = (time>= Lcontact_frame_time(i)) & (time < Lcontact_frame_time(i+1));
    idx_log = (log_time>= Lcontact_frame_time(i)) & (log_time < Lcontact_frame_time(i+1));
    current_log_data = log_data(idx_log);
    current_log_time = log_time(idx_log);

    plot(time(idx_angle), Langle_data(idx_angle),'DisplayName','Left Leg', 'Color', [0, 0, 1], 'LineWidth',2); hold on;
    ylabel('Hip Flexion  [deg]', 'FontSize',16);
    ax = gca;
    ax.YAxis(1).FontSize = 14;
    y_lim = [-15,45];
    ylim(y_lim);
    add_phase_backgrounds(Lcontact_frame(i),Lcontact_end_frame(i),Lcontact_frame(i+1),y_lim); hold on;
    %[cfg,~] = plot_config('Hip Flexion');  %if you want to add normal range to this figure, you have to interpolate normal range for the time scale

    text(Lcontact_frame_time(i)-0.1, max(ylim)-0.1, 'Flexion', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, FontSize=12);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(Lcontact_frame_time(i)-0.1, min(ylim), 'Extension', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, FontSize=12);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % Log
    yyaxis right
    plot(log_time(idx_log), log_data(idx_log)*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2);
    ylabel('Assist Signal', 'FontSize', 16, 'Color',[0 1 0]);
    yticks([0 0.8]);
    yticklabels({'0', '1'});
    ax = gca;
    ax.YAxis(2).FontSize = 14;
    ylim([0 1]);

    % Adding time of starting Assist 
    diff_log = diff(current_log_data);
    assist_start_idx = find(diff_log == 1);
    assist_start_time = current_log_time(assist_start_idx);
    assist_end_idx = find(diff_log == -1);
    assist_end_time = current_log_time(assist_end_idx);
   
    assist_start_str = sprintf('%.2fs', assist_start_time);
    text_assist_start = text(assist_start_time, ax.YAxis(2).Limits(2)*0.8, assist_start_str, ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
             'Color', [0 1 0], 'FontSize', 14, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);

    assist_end_str = sprintf('%.2fs', assist_end_time);
    text_assist_end = text(assist_end_time+0.03, ax.YAxis(2).Limits(2)*0.8, assist_end_str, ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
        'Color', [0 1 0], 'FontSize', 14, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);
    % ---

    % Common
    title(sprintf('Step %d Left side (%.2f-%.2f sec)', i, Lcontact_frame_time(i), Lcontact_frame_time(i+1)));
    xlim([Lcontact_frame_time(i), Lcontact_frame_time(i+1)]);
    xlabel('Time [s]', FontSize=16);
    legend('Location','best');
    
    filename = sprintf('step_%02d.jpeg', i);
    save_file = fullfile(figure_Lside, filename);
    saveas(gcf, save_file);
end

disp('Completely Processed!')

function add_phase_backgrounds(contact_time,contact_end_time,next_contact_time,y_lim)
    bg_stance = fill([contact_time,contact_end_time,contact_end_time,contact_time], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], 'b', 'EdgeColor','none','FaceAlpha',0.05, 'HandleVisibility','off'); hold on;
    bg_swing = fill([contact_end_time,next_contact_time, next_contact_time,contact_end_time], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1,0.5,0],'EdgeColor','none','FaceAlpha',0.05,'HandleVisibility','off');
    uistack(bg_stance, 'bottom');
    uistack(bg_swing, 'bottom');

    text(contact_time+0.05, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Stance Phase', 'FontSize', 12, 'Color', [0 0 0.5], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top','Rotation',90);
    text(contact_end_time+0.05, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Swing Phase', 'FontSize', 12, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top','Rotation',90);
end