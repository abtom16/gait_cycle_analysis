clc;
addpath(genpath(fullfile(pwd,'..', '..', '..')));

%% ---- 概要 ---- %%
%{
 アシストログを歩行周期ごとに算出するのではなく、11m歩行全体で導出
%}

paretic_side = 'Left';
[filepaths, log_paths, sync_frames, filenames] = getAssistData(paretic_side);
save_dir = ['C:\abe_backup\backup\01_修士\06_Xsens_analysis\10_Assist_Log_whole11m\3graph_ver'];

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
    
    angle_com_z = data.CoM.z(sync_frame:end);
    angle_com_z = angle_com_z - angle_com_z(sync_frame);
    angle_com_z = angle_com_z * 100;
    
    Rangle_toeclearance = data.RToe.z(sync_frame:end);
    Rangle_toeclearance = (Rangle_toeclearance - Rangle_toeclearance(sync_frame)) * 100;
    Langle_toeclearance = data.LToe.z(sync_frame:end);
    Langle_toeclearance = (Langle_toeclearance - Langle_toeclearance(sync_frame)) * 100;
    
    Rfoot_x = data.RFoot.x(sync_frame:end);
    Lfoot_x = data.LFoot.x(sync_frame:end);
    
    if strcmp(paretic_side, 'Right')
        angle_hipex = Rangle_hipex;
        angle_toeclearance = Rangle_toeclearance;
        angle_unaffected_toeclearance = Langle_toeclearance;
        contact_frame = Rcontact_frame;
        contact_end_frame = Rcontact_end_frame;
        unaffected_contact_frame = Lcontact_frame;
        unaffected_foot_x = (Lfoot_x - Rfoot_x) * 100;
    elseif strcmp(paretic_side, 'Left')
        angle_hipex = Langle_hipex;
        angle_toeclearance = Langle_toeclearance;
        angle_unaffected_toeclearance = Rangle_toeclearance;
        contact_frame = Lcontact_frame;
        contact_end_frame = Lcontact_end_frame;
        unaffected_contact_frame = Rcontact_frame;
        unaffected_foot_x = (Rfoot_x - Lfoot_x) * 100;
    else
        error('Input error: "partic_side" should be either "Right" or "Left".')
    end
    
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

        [~, max_com_z_rel_idx] = max(angle_com_z(stance_idx));
        max_com_z_idx = stance_idx(max_com_z_rel_idx);
        max_com_z_time = max_com_z_idx * 1/60;

        [~, max_unaff_toe_z_rel_idx] = max(angle_unaffected_toeclearance(stance_idx));
        max_unaff_toe_z_idx = stance_idx(max_unaff_toe_z_rel_idx);
        max_unaff_toe_z_time = max_unaff_toe_z_idx * 1/60;

        [~, close0_unaff_foot_x_rel_idx] = min(abs(unaffected_foot_x(stance_idx)));
        close0_unaff_foot_x_idx = stance_idx(close0_unaff_foot_x_rel_idx);
        close0_unaff_foot_x_time = close0_unaff_foot_x_idx * 1/60;

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
                if abs(max_com_z_time - off_time) <= THRESHOLD_MATCH
                    assist_end_events = [assist_end_events; struct( ...
                        'type', 'com_z', ...
                        'time', off_time)];
                end
                if abs(max_unaff_toe_z_time - off_time) <= THRESHOLD_MATCH
                    assist_end_events = [assist_end_events; struct( ...
                        'type', 'max_unaffected_toe_z', ...
                        'time', off_time)];
                end
                if abs(close0_unaff_foot_x_time - off_time) <= THRESHOLD_MATCH
                    assist_end_events = [assist_end_events; struct( ...
                        'type', 'min_unaffected_foot_x', ...
                        'time', off_time)];
                end
            end
        end
    end


    %% -------- Plotting Section --------
    figure('Position',[100,100,2000,1200], 'Visible','off'); %1グラフのheight 400
    sgtitle(sprintf('Data: %s',filenames{i}), 'FontSize',20, 'Interpreter', 'none'); %sub1_as1のときaが下付き文字になるためinterpreterをnoneにする
    %{
        グラフは上から、股関節伸展・重心垂直方向位置・トゥクリアランス
        plot_joint_angle：関節の角度や位置データ
        add_stance_and_swing_phase：麻痺側の立脚期と遊脚期の移行を各歩行データから算出し、背景に描画
        plot_unaffected_contact：健側の接地時、橙色でプロット
        plot_assist_log：アシストのオンオフをプロット、上にあるときON、下にあるときOFF
        config_x_axis：横軸を時間軸で算出、アシスト開始前に
    %}
    % ===== Cluster 1 & 3 =======
    % % --- Hip Extension (Top) ---
    subplot(3, 1, 1);
    y_label = 'Hip Extenstion  [deg]';
    y_lim = [-20, 45];
    time = (1:length(angle_hipex)) * 1/60 ; % Fs=60Hz
    plot_joint_angle(time, angle_hipex, y_label, y_lim); hold on;
    add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    plot_unaffected_contact(unaffected_contact_frame, y_lim); hold on;
    plot_assist_log(log_time, log_data); hold on;
    config_x_axis(log_time, log_data, time); hold on;
    for e1 = 1:length(assist_end_events)
        if strcmp(assist_end_events(e1).type, 'hipex')
            plot(assist_end_events(e1).time, 40, ...
                'ko', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
        end
    end
    legend('Location','northeast');
    % --- CoM Vertical (Middle) ---
    subplot(3, 1, 2);
    y_label = 'CoM Vertical [cm]';
    y_lim = [-5, 5];
    plot_joint_angle(time, angle_com_z, y_label, y_lim);
    add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    plot_unaffected_contact(unaffected_contact_frame, y_lim);
    plot_assist_log(log_time, log_data);
    config_x_axis(log_time, log_data, time);
    for e2 = 1:length(assist_end_events)
        if strcmp(assist_end_events(e2).type, 'com_z')
            plot(assist_end_events(e2).time, 4, ...
                'o', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
        end
    end
    legend('Location','northeast');
    % --- Toe Clearance (Bottom) ---
    subplot(3, 1, 3);
    y_label = 'Toe Clearance [cm]';
    y_lim = [-5, 20];
    plot_unaffected_joint_angle(time, angle_unaffected_toeclearance, y_label, y_lim); hold on;
    add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    plot_unaffected_contact(unaffected_contact_frame, y_lim); hold on;
    plot_assist_log(log_time, log_data);
    config_x_axis(log_time, log_data, time);
    for e3 = 1:length(assist_end_events)
        if strcmp(assist_end_events(e3).type, 'max_unaffected_toe_z')
            plot(assist_end_events(e3).time, 17, ...
                'o', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
        end
    end
    legend('Location','northeast');
    
    % ===== For Cluster 2 =====
    % --- CoM Vertical (Top) ---
    % subplot(3, 1, 2);
    % y_label = 'CoM Vertical [cm]';
    % y_lim = [-5, 5];
    % time = (1:length(angle_hipex)) * 1/60 ; % Fs=60Hz
    % plot_joint_angle(time, angle_com_z, y_label, y_lim);
    % add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    % plot_unaffected_contact(unaffected_contact_frame, y_lim);
    % plot_assist_log(log_time, log_data);
    % config_x_axis(log_time, log_data, time);
    % for e2 = 1:length(assist_end_events)
    %     if strcmp(assist_end_events(e2).type, 'com_z')
    %         plot(assist_end_events(e2).time, 4, ...
    %             'o', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
    %     end
    % end
    % legend('Location','northeast');    
    % --- Unaffected Toe Clearance (Middle) ---
    % subplot(3, 1, 2);
    % y_label = 'Unaffected Toe Clearance [cm]';
    % y_lim = [-5, 20];
    % plot_unaffected_joint_angle(time, angle_unaffected_toeclearance, y_label, y_lim); hold on;
    % add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    % plot_unaffected_contact(unaffected_contact_frame, y_lim); hold on;
    % plot_assist_log(log_time, log_data);
    % config_x_axis(log_time, log_data, time);
    % for e2 = 1:length(assist_end_events)
    %     if strcmp(assist_end_events(e2).type, 'max_unaffected_toe_z')
    %         plot(assist_end_events(e2).time, 17, ...
    %             'o', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
    %     end
    % end
    % legend('Location','northeast');
    % --- Unaffected Foot x displacement (Bottom) --- definition:(Unaffected Foot x) - (Affected Foot x)
    % subplot(3, 1, 3);
    % y_label = 'Unaffected Foot x (unaff - aff) [cm]';
    % y_lim = [-100, 100];
    % plot_unaffected_joint_angle(time, unaffected_foot_x, y_label, y_lim); hold on;
    % add_stance_and_swing_phase(contact_frame, contact_end_frame, y_lim); hold on;
    % plot_unaffected_contact(unaffected_contact_frame, y_lim); hold on;
    % plot_assist_log(log_time, log_data);
    % config_x_axis(log_time, log_data, time);
    % for e3 = 1:length(assist_end_events)
    %     if strcmp(assist_end_events(e3).type, 'min_unaffected_foot_x')
    %         plot(assist_end_events(e3).time, 90, ...
    %             'o', 'MarkerSize',12, 'LineWidth', 2,'HandleVisibility','off');
    %     end
    % end
    % legend('Location','northeast');        
    
    filename = [filenames{i}, '_assist_11m.jpeg'];
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
    plot(log_time, log_data*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2); hold on;
    
    current_xlim_vals_for_label = xlim();
    label_x_pos = current_xlim_vals_for_label(2) + (current_xlim_vals_for_label(2) - current_xlim_vals_for_label(1)) * 0.04;
    ylabel('Assist Signal', 'FontSize', 16, 'Color', [0 1 0], 'Units', 'data', 'Position', [label_x_pos, 0.5], 'HorizontalAlignment', 'center');
    yticks(0.8);
    yticklabels({'ON'});
    ax = gca;
    ax.YAxis(2).FontSize = 14;
    ax.YAxis(2).Color = [0, 1 ,0];
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
