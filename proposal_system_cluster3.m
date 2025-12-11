clc;
addpath(genpath(fullfile(pwd,'..', '..', '..')));

%% ---- 概要 ---- %%
%{
 アシストログを歩行周期ごとに算出するのではなく、11m歩行全体で導出
%}

paretic_side = 'Left';
[filepaths, log_paths, sync_frames, filenames] = getAssistData(paretic_side);
save_dir = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\11_simulate_proposal_system\Cluster3';

f = waitbar(0, 'Processing...');

for i=1:length(filepaths)
    if i== length(filepaths)/2 + 1
        disp('Halfway done');
    end
    filepath = filepaths{i};
    log_path = log_paths{i};
    sync_frame = sync_frames(i);

    %% ---- Data Loading ----
    %  ---- XSens Data ----
    data = GaitData(filepath, '時系列データ 11m');
    [Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame] = detectValidFootContacts(data.RFootContact(sync_frame:end), data.LFootContact(sync_frame:end));
    data_len = length(data.RFootContact(sync_frame:end));
    %  ---- Assist Log Data ----
    assist_log = readmatrix(log_path);
    if data_len > length(assist_log)  % アシストログよりもXSensのデータ量のほうが大きい場合の処理
        data_len = length(assist_log);
    end
    log_time = assist_log(1:data_len,4);   %%  log dataのA(1)行データ番号はフレーム数ではなかった。タイムスタンプから時間を導出していたので、この時間を使用 
    log_data = assist_log(1:data_len,7);
    
    
    %  ---- Definition of each joint ----
    Rangle_hipex = data.RHip.extension(sync_frame:end);
    Langle_hipex = data.LHip.extension(sync_frame:end);

    if strcmp(paretic_side, 'Right')
        angle_hipex = Rangle_hipex;
        contact_frame = Rcontact_frame;
        contact_end_frame = Rcontact_end_frame;
        unaffected_contact_frame = Lcontact_frame;
    elseif strcmp(paretic_side, 'Left')
        angle_hipex = Langle_hipex;
        contact_frame = Lcontact_frame;
        contact_end_frame = Lcontact_end_frame;
        unaffected_contact_frame = Rcontact_frame;
    else
        error('Input error: "partic_side" should be either "Right" or "Left".')
    end
    
    time = (1:length(angle_hipex)) * 1/60 ; % Fs=60Hz

    %% -------- Detection of Hip Extension/CoM Peaks near Assist-Off
    %{
        ・各歩行周期（立脚期）ごとに、股関節最大伸展・重心最高点・健側のトゥクリアランスを算出
        ・アシスト終了タイミングの前後0.1s以内に、それぞれの最大点が存在するとき、アシスト終了タイミングのx位置・y軸最大値(y_lim(2))に〇を描画
        ・hipexのデータは、正が屈曲であるので、最大伸展はmin(angle_hipex)とする必要がある
        ・max_hipex_rel_idx：相対インデックス
        　angle_hipex(stance_idx)が[angle_hipex(100),...,angle_hipex(120)]の時、maxがangle_hipex(114)だとすると、
          max_hipex_rel_idxは15になるので、stance_idx(max_hipex_rel_idx)で114に戻す
    %}
    assist_end_events = [];
    THRESHOLD_MATCH = 0.1;

    for j = 1:(length(contact_frame) - 1)
        stance_start = contact_frame(j);
        stance_end = contact_end_frame(j);
        next_stance_start = contact_frame(j+1);

        stance_idx = stance_start:stance_end;
        stance_time = (stance_idx) * 1/60;
        stance_start_time = stance_start * 1/60;
        stance_end_time = stance_end * 1/60;

        [~, max_hipex_rel_idx] = min(angle_hipex(stance_idx));
        max_hipex_idx = stance_idx(max_hipex_rel_idx);
        max_hipex_time = max_hipex_idx * 1/60;

        assist_off_indices = find(diff(log_data) == -1) + 1;
        for k = 1:length(assist_off_indices)
            off_idx = assist_off_indices(k);
            off_time = log_time(off_idx);
            if off_time >= stance_start_time && off_time <= stance_end_time
                if abs(max_hipex_time - off_time) <= THRESHOLD_MATCH
                    assist_end_events = [assist_end_events; struct( ...
                        'type', 'hipex', ...
                        'time', off_time)];
                end
            end
        end
    end


    %% -------- Plotting Section --------
    figure('Position',[100,100,2000,400], 'Visible','off'); %1グラフのheight 400
    sgtitle(sprintf('Data: %s',filenames{i}), 'FontSize',20, 'Interpreter', 'none'); %sub1_as1のときaが下付き文字になるためinterpreterをnoneにする
    %{
        クラスタ3への支援方策として、HIMOCOのシステムを参考に前回の股関節最大伸展のタイミングで、アシストさせたときとPTによるアシストがどのくらい異なるのか調査するためのコード
    %}
    % % --- Hip Extension ---
    y_label = 'Hip Extenstion  [deg]';
    y_lim = [-20, 45];
    
    plot_joint_angle(time, angle_hipex, y_label, y_lim); hold on;
    add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    plot_unaffected_contact(unaffected_contact_frame, y_lim); hold on;
    plot_assist_log(log_time, log_data); hold on;
    config_x_axis(log_time, log_data, time); hold on;
    % for e1 = 1:length(assist_end_events)
    %     if strcmp(assist_end_events(e1).type, 'hipex')
    %         plot(assist_end_events(e1).time, 40, ...
    %             'ko', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
    %     end
    % end
    %  ----- Proposal Assist System -----
    yyaxis right
    [max_indices_all, min_indices_all] = detect_hipex_peaks(angle_hipex);
    time_max_all = max_indices_all * 1/60;
    time_min_all = min_indices_all * 1/60;

    if length(time_max_all) >= 2
        for j = 2:length(time_max_all)
            previous_start_time = time_max_all(j-1);  %%　現在の歩行周期の開始時刻
            previous_end_time = time_max_all(j);
            
            previous_time_min = time_min_all(previous_start_time <= time_min_all & time_min_all <= previous_end_time);
            if ~isempty(previous_time_min)
                assist_time_length = previous_time_min - previous_start_time;
                current_assist_off = previous_end_time + assist_time_length;
                if j==2
                    plot([previous_end_time, current_assist_off], [0.8, 0.8] ,'Color',[1, 0, 0], ...
                        'LineWidth',1.2,'DisplayName','Proposal Assist', 'Marker', 'none', 'LineStyle','-');
                else
                    plot([previous_end_time, current_assist_off], [0.8, 0.8] ,'Color',[1, 0, 0],'LineWidth',1.2,'HandleVisibility','off','Marker', 'none','LineStyle','-');                 
                end
                plot([previous_end_time, previous_end_time], [0, 0.8], 'Color', [1, 0, 0], 'LineWidth',1.2,'HandleVisibility','off','Marker', 'none','LineStyle','-');
                plot([current_assist_off, current_assist_off], [0, 0.8], 'Color', [1, 0, 0], 'LineWidth',1.2,'HandleVisibility','off','Marker', 'none','LineStyle','-');
            end
        end
    end
    
    legend('Location','northeast');


    filename = [filenames{i}, '_proposal_assist.jpeg'];
    save_filename = fullfile(save_dir, filename);
    saveas(gca, save_filename);
    
   
    progress = i / length(filepaths);
    waitbar(progress, f, 'Progressing...');
end
clear all;
disp('Completely Processed!')

% =====================================================
% ============= Local Function Section ================
% =====================================================

function plot_unaffected_contact(unaffected_contact_frame, y_lim)
    unaffected_contact_time = unaffected_contact_frame * (1/60); % Fs=60Hz
    for i=1:length(unaffected_contact_time)
        unaffected_contact = unaffected_contact_time(i);
        if i == 1
            plot([unaffected_contact, unaffected_contact], y_lim, ...
                'DisplayName','Unaffected Foot Contact', 'Color', [1, 0.5, 0], 'LineStyle','--','Marker','none');
        else
            plot([unaffected_contact, unaffected_contact], y_lim, ...
                'Color', [1, 0.5, 0], 'LineStyle','--', 'Marker','none','HandleVisibility','off');
        end
    end
end

function add_stance_and_swing_phase(contact_frame,contact_end_frame,y_lim)
    %{
        患者ごとの麻痺側の立脚期開始と遊脚期開始をグラフに載せるための関数
    %}
    for i=1:length(contact_frame)-1
        contact_time = contact_frame(i) * 1/60;
        next_contact_time = contact_frame(i+1) * 1/60;
        contact_end_time = contact_end_frame(i) * 1/60;
        bg_stance = fill([contact_time,contact_end_time,contact_end_time,contact_time], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], 'b', 'EdgeColor','none','FaceAlpha',0.05, 'HandleVisibility','off'); hold on;
        bg_swing = fill([contact_end_time,next_contact_time, next_contact_time,contact_end_time], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1,0.5,0],'EdgeColor','none','FaceAlpha',0.05,'HandleVisibility','off');
        uistack(bg_stance, 'bottom');
        uistack(bg_swing, 'bottom');
    
        text(contact_time+0.05, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Stance Phase', 'FontSize', 8, 'Color', [0 0 0.5], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top','Rotation',90);
        text(contact_end_time+0.05, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Swing Phase', 'FontSize', 8, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top','Rotation',90);
    end
end
function plot_joint_angle(time, angle_data, y_label, y_lim)
    plot(time, angle_data,'DisplayName','Affected Leg', 'Color', [0, 0, 1]); hold on;
    yline(0, '-k', 'HandleVisibility', 'off'); hold on;
    ylabel(y_label, 'FontSize', 16);
    ax = gca;
    ax.YAxis(1).FontSize = 14;
    ylim(y_lim);
end
function plot_unaffected_joint_angle(time, angle_data, y_label, y_lim)
    plot(time, angle_data,'DisplayName','Unaffected Leg', 'Color', [1, 0.5, 0]); hold on;
    yline(0, '-k', 'HandleVisibility', 'off'); hold on;
    ylabel(y_label, 'FontSize', 16);
    ax = gca;
    ax.YAxis(1).FontSize = 14;
    ylim(y_lim);
end
function plot_assist_log(log_time, log_data)
    yyaxis right
    plot(log_time, log_data*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth', 0.5); hold on;
    
    current_xlim_vals_for_label = xlim();
    label_x_pos = current_xlim_vals_for_label(2) + (current_xlim_vals_for_label(2) - current_xlim_vals_for_label(1)) * 0.04;
    ylabel('Assist Signal', 'FontSize', 16, 'Color', [1 0 0], 'Units', 'data', 'Position', [label_x_pos, 0.5], 'HorizontalAlignment', 'center');
    yticks(0.8);
    yticklabels({'ON'});
    ax = gca;
    ax.YAxis(2).FontSize = 14;
    ax.YAxis(2).Color = [1, 0 ,0];
    ylim([0 1]);
end

function config_x_axis(log_time, log_data, time)
    yyaxis left
    ax = gca;
    on_indices = find(log_data > 0.5, 1, 'first');  % log_dataは0か1のバイナリだが、グラフ化するとき0.8倍しているため正常に動作するため0.5に閾値設定
    if isempty(on_indices)
        warning('Warnig: No On Signals found in the assist log data. Setting X-axis start limit to 1');
        min_x_lim = 1;
    else
        first_assist_on_time = log_time(on_indices);
        min_x_lim = max(1, floor(first_assist_on_time)-1);
    end
    max_x_lim = max(time);
    if min_x_lim <= 5
        start_tick = 0;
    else
        start_tick = floor((min_x_lim - 1) / 5) * 5;
    end
    xlim([min_x_lim, max_x_lim]);
    end_tick = ceil(max(time));
    tick_interval = 5;
    ax.XTick = start_tick : tick_interval : end_tick;
    
    xlabel('Time [s]', 'FontSize', 16);
    ax.XAxis.FontSize = 14;
end

function [max_indices, min_indices] = detect_hipex_peaks(angle_data)
    % ------ 北原さんのHIMICOのプログラム controller.cppのreturn_max_min_timingを参考
    % Amplitude振幅と北原さんのコードでは書いてあるが、わかりにくいので一部joint_angle関節角と変換
    INDEX_THRESHOLD = 5;
    AMP_THRESHOLD = 10;

    max_indices = [];
    min_indices = [];

    persistent index_pre amp_pre dif_sign_pre

    if isempty(index_pre) || isempty(amp_pre) || isempty(dif_sign_pre)
        index_pre = -INDEX_THRESHOLD - 1;
        amp_pre = -99999;
        dif_sign_pre = 0;
    end
    joint_angle_diff = diff(angle_data);
    for k=2:length(angle_data)
        current_joint_angle = angle_data(k);
        current_joint_angle_diff = joint_angle_diff(k-1);
        joint_angle_diff_sign = sign(current_joint_angle_diff);
        if joint_angle_diff_sign == 0  %% 傾きが0、関節角度の変化が平坦であるときは符号を維持する
            joint_angle_diff_sign = dif_sign_pre;
        end
        if k > 2 
            if joint_angle_diff_sign * dif_sign_pre < 0 && abs(index_pre - (k-1)) > INDEX_THRESHOLD
                amplitude_diff = current_joint_angle - amp_pre;

                if joint_angle_diff_sign < 0  %% 傾きが正から負に変わったとき
                    if amplitude_diff > AMP_THRESHOLD
                        max_indices = [max_indices; k-1];
                        index_pre = k-1;
                        amp_pre = current_joint_angle;
                        dif_sign_pre = joint_angle_diff_sign;
                    end
                elseif joint_angle_diff_sign > 0
                    if amplitude_diff < -AMP_THRESHOLD
                        min_indices = [min_indices; k-1];
                        index_pre = k-1;
                        amp_pre = current_joint_angle;
                        dif_sign_pre = joint_angle_diff_sign;
                    end
                end
            end
        end
        if dif_sign_pre == 0 && k > 1
            dif_sign_pre = joint_angle_diff_sign;
        end
    end
end