clc;
addpath(genpath(fullfile(pwd,'..', '..','..')));

paretic_side = 'Left';
[filepaths, log_paths, sync_frames, filenames] = getAssistData(paretic_side);
target_joint = 'Hip Flexion';
save_path = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\06_assist_timing_analysis\2_detail_assist_timing';

f = waitbar(0, 'Progressing...');

if strcmp(paretic_side, 'Left')
    paretic_joint_side = 'L';
    nonaffected_joint_side = 'R';
else
    paretic_joint_side = 'R';
    nonaffected_joint_side = 'L';
end
if strcmp(target_joint, 'CoM Vertical')
    paretic_joint_name = 'CoM';
    joint_axis = 'z';
    nonaffected_joint_name = 'CoM';
    yright_label = 'CoM Vertical Motion [cm]';
    y_lim = [0, 5];
    y_max_text = 'Upward';
    y_min_text = 'Downward';
    filename_joint = '_CoM-z';
elseif strcmp(target_joint, 'Hip Flexion')
    paretic_joint_name = [paretic_joint_side, 'Hip'];
    joint_axis = 'extension';
    nonaffected_joint_name = [nonaffected_joint_side, 'Hip'];
    yright_label = 'Hip Flexion [deg]';
    y_lim = [-20, 45];
    y_max_text = 'Flexion';
    y_min_text = 'Extension';
    filename_joint = '_HipEx';
elseif strcmp(target_joint, 'Knee Angle')
    paretic_joint_name = [paretic_joint_side, 'Knee'];
    joint_axis = 'angle';
    nonaffected_joint_name = [nonaffected_joint_side, 'Knee'];
    yright_label = 'Knee Flexion [deg]';
    y_lim = [-20, 70];
    y_max_text = 'Flexion';
    y_min_text = 'Extension';
    filename_joint = '_Knee';
elseif strcmp(target_joint, 'L5 Forward')
    paretic_joint_name = 'L5';
    joint_axis = 'x';
    nonaffected_joint_name = 'L5';
    yright_label = 'L5 Forward [cm]';
    y_lim = [-50, 50];
    y_max_text = 'Forward';
    y_min_text = 'Backward';
    filename_joint = '_L5Forward';
end

for i=1:length(filepaths)
    if i == length(filepaths)/2 + 1
        disp('Halfway done');
    end
    filepath = filepaths{i};
    log_path = log_paths{i};
    sync_frame = sync_frames(i);
 
    figure_dirs = make_fig_directories(filepath);
    save_dir = figure_dirs.withLOG_eachstep;
    if ~exist(save_dir,'dir')
        error('Save directory does not exist');
    end
    data = GaitData(filepath, '時系列データ 11m');
    assist_log = readmatrix(log_path);
      
    data_len = length(data.RFootContact(sync_frame:end));
    if data_len > length(assist_log) % アシストログよりもXSensのデータ量のほうが大きい場合の処理
        data_len = length(assist_log);
    end
    log_time = assist_log(1:data_len,4);   %%  log dataのA行データ番号はフレーム数ではなかった。タイムスタンプから時間を導出していたので、この時間を使用 
    log_data = assist_log(1:data_len,7);
    
    [Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame] = ...
        detectValidFootContacts(data.RFootContact(sync_frame:end), data.LFootContact(sync_frame:end));
    
    paretic_angle_data = data.(paretic_joint_name).(joint_axis)(sync_frame:end);
    nonaffected_angle_data = data.(nonaffected_joint_name).(joint_axis)(sync_frame:end);
    paretic_foot_x = data.([paretic_joint_side, 'Foot']).x(sync_frame:end);
    %% -- scaling m -> cm
    if strcmp(target_joint, 'CoM Vertical') 
        paretic_angle_data = paretic_angle_data * 100;  
        nonaffected_angle_data = nonaffected_angle_data * 100;
    end
    %% --
    if strcmp(target_joint, 'L5 Forward') 
        paretic_angle_data = paretic_angle_data * 100;  
        nonaffected_angle_data = nonaffected_angle_data * 100;
        paretic_foot_x = paretic_foot_x * 100;
    end

    Rcontact_frame_time = Rcontact_frame * 1/60;
    Rcontact_end_frame_time = Rcontact_end_frame * 1/60;
    Lcontact_frame_time = Lcontact_frame * 1/60;
    Lcontact_end_frame_time = Lcontact_end_frame * 1/60;
    time = (1:length(paretic_angle_data)) * 1/60 ;

    if strcmp(paretic_side, 'Left')
        paretic_contact_frame = Lcontact_frame;
        paretic_contact_end_frame = Lcontact_frame;
        paretic_contact_frame_time = Lcontact_frame_time;
        paretic_contact_end_frame_time = Lcontact_end_frame_time;
        unaffected_contact_frame = Rcontact_frame;
        unaffected_contact_end_frame = Rcontact_frame;
        unaffected_contact_frame_time = Rcontact_frame_time;
        unaffected_contact_end_frame_time = Rcontact_end_frame_time;
    else
        paretic_contact_frame = Rcontact_frame;
        paretic_contact_end_frame = Rcontact_frame;
        paretic_contact_frame_time = Rcontact_frame_time;
        paretic_contact_end_frame_time = Rcontact_end_frame_time;
        unaffected_contact_frame = Lcontact_frame;
        unaffected_contact_end_frame = Lcontact_frame;
        unaffected_contact_frame_time = Lcontact_frame_time;
        unaffected_contact_end_frame_time = Lcontact_end_frame_time;
    end
    
    all_current_start_time = [];
    all_assist_start_time = [];
    all_assist_end_time = [];
    all_current_end_time = [];
    all_step_number = [];
    all_assist_start_perc = [];
    all_paretic_footcontact_perc = [];
    all_unaffected_footcontact_perc = [];
    all_assist_end_perc = [];
    all_joint_event_perc = [];
    %% in case of Paretic side is Left
    paretic_time = (1:length(paretic_angle_data)) * 1/60 ;
    for j=1:length(paretic_contact_end_frame_time)-1
        figure('Visible','off');
        idx_angle = (time>= paretic_contact_end_frame_time(j)) & (time < paretic_contact_end_frame_time(j+1));
        idx_log = (log_time>= paretic_contact_end_frame_time(j)) & (log_time < paretic_contact_end_frame_time(j+1));
        
        current_log_time = log_time(idx_log);
        current_log_data = log_data(idx_log);
        
        %% angle y-axis(left)
        if strcmp(target_joint,'CoM Vertical')
            paretic_angle_data_min = min(paretic_angle_data(idx_angle));  
            paretic_angle_data(idx_angle) = paretic_angle_data(idx_angle) - paretic_angle_data_min; 
        elseif strcmp(target_joint,'L5 Forward')
            stance_start_idx = find(time >= paretic_contact_frame_time(j+1), 1, 'first');
            paretic_foot_x_offset = paretic_foot_x(stance_start_idx);
            paretic_angle_data_temp = paretic_angle_data(idx_angle);
            paretic_angle_data(idx_angle) = paretic_angle_data(idx_angle) - paretic_foot_x_offset; 
        end
        
        
        plot(time(idx_angle), paretic_angle_data(idx_angle),'DisplayName','Paretic Side Leg', 'Color', [0, 0, 1], 'LineWidth',2); hold on;

        ylabel(yright_label, FontSize=16); 
        ax = gca;
        ax.YAxis(1).FontSize = 14;
        ylim(y_lim);
        text(paretic_contact_end_frame_time(j)-0.15, max(ylim)-0.1, y_max_text, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, 'FontSize',12, 'EdgeColor','k'); %
        text(paretic_contact_end_frame_time(j)-0.15, min(ylim), y_min_text, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90,'FontSize',12, 'EdgeColor', 'k');  %

        %% -Common(x-axis)  editted in 20250620
        % title(sprintf('Step %d Paretic side (%.2f-%.2f sec)', j, paretic_contact_end_frame_time(j), paretic_contact_end_frame_time(j+1)));
        xlim([paretic_contact_end_frame_time(j), paretic_contact_end_frame_time(j+1)]);
        y_lim_current = ylim(); 
        xlabel_y_pos = y_lim_current(1) - (y_lim_current(2) - y_lim_current(1)) * 0.05; 

        yline(0 , '-k', 'HandleVisibility','off');
        xlabel('Time [s]', 'FontSize', 16, 'Units', 'data', 'Position', [mean(xlim()), xlabel_y_pos]);

        ax.XAxis.FontSize = 14;
        add_phase_swingIVL_backgrounds(paretic_contact_end_frame_time(j),paretic_contact_frame_time(j+1),paretic_contact_end_frame_time(j+1),y_lim); hold on;
        [cfg,~] = plot_config(target_joint, 'swing');  
        current_xlim_vals = xlim();
        if strcmp(target_joint, 'Hip Flexion')
            cfg.add_normal_range_SwingInterval(current_xlim_vals); hold on;
        elseif strcmp(target_joint, 'Knee Angle')
            cfg.add_normal_range_SwingInterval(current_xlim_vals); hold on;
        end

        %% Log y-axis(right) 
        yyaxis right
        plot(log_time(idx_log), log_data(idx_log)*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2);
        current_xlim_vals_for_label = xlim();
        label_x_pos = current_xlim_vals_for_label(2) + (current_xlim_vals_for_label(2) - current_xlim_vals_for_label(1)) * 0.04;

        ylabel('Assist Signal', 'FontSize', 16, 'Color', [0 1 0], 'Units', 'data', 'Position', [label_x_pos, 0.5], 'HorizontalAlignment', 'center');
        yticks(0.8);
        yticklabels({'ON'});
        ax = gca;
        ax.YAxis(2).FontSize = 14;
        ax.YAxis(2).Color = [0, 1 ,0];
        ylim([0 1]);

        %% ---Adding time of starting Assist 
        current_start_time = paretic_contact_end_frame_time(j);
        stance_start_time = paretic_contact_frame_time(j+1);
        current_end_time = paretic_contact_end_frame_time(j+1);

        diff_log = diff(current_log_data);
        assist_start_idx = find(diff_log == 1);
        assist_start_time = current_log_time(assist_start_idx);
        assist_end_idx = find(diff_log == -1);
        assist_end_time = current_log_time(assist_end_idx);

        %% add text for assist time -- Hundles cases where multiple assist start times exist 
        for k=1:length(assist_start_time)
            if current_start_time <= assist_start_time(k) && assist_start_time(k) <= current_end_time
                assist_start_str = sprintf('%.2fs', assist_start_time(k));
                text_assist_start = text(assist_start_time(k), ax.YAxis(2).Limits(2)*0.8, assist_start_str, ...
                    'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
                     'Color', [0 1 0], 'FontSize', 14, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);
            end
        end
        for k=1:length(assist_end_time)
            if current_start_time <= assist_end_time(k) && assist_end_time(k) <= current_end_time
                text_y = ax.YAxis(2).Limits(2) * 0.8;
                horizontal_alignment = 'left';
                if assist_end_time(k) < stance_start_time
                    text_y = ax.YAxis(2).Limits(2) * 0.9;
                    horizontal_alignment = 'right';
                end
                assist_end_str = sprintf('End:%.2fs', assist_end_time(k));
                text_assist_end = text(assist_end_time(k)+0.03, text_y, assist_end_str, ...
                    'HorizontalAlignment', horizontal_alignment, 'VerticalAlignment', 'bottom', ...
                    'Color', [0 1 0], 'FontSize', 14, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);
            end
        end
        %% ---

        %%  ---Adding xlabel (made in 20250620, Last update:20250904)
        %%  - want to plot foot contact timing of unaffected side  
        unaffected_footcontact_idx = (current_start_time < unaffected_contact_frame_time) & (unaffected_contact_frame_time <= current_end_time);
        unaffected_footcontact_time = unaffected_contact_frame_time(unaffected_footcontact_idx);
        if length(unaffected_footcontact_time) > 1
            unaffected_footcontact_time(1) = unaffected_footcontact_time(2);
            unaffected_footcontact_time(2) = [];
        end
        if isempty(unaffected_footcontact_time)
            unaffected_footcontact_time = NaN;
        end

        x_tick_positions = [];

        display_min_x = floor(current_start_time * 5) / 5;
        display_max_x = ceil(current_end_time * 5) / 5;
        intermediate_ticks = display_min_x : 0.2 : display_max_x;
        intermediate_ticks = intermediate_ticks(intermediate_ticks >= current_start_time ...
            & intermediate_ticks <= current_end_time);
        x_tick_positions = [x_tick_positions, intermediate_ticks];
        xticks(x_tick_positions);
        x_tick_labels = cell(size(x_tick_positions));
        xticklabels(x_tick_labels);

        text_y_pos = y_lim(1);
        yyaxis left;
        text(current_start_time, text_y_pos,sprintf('%.2f', current_start_time), ...
             'HorizontalAlignment', 'center','VerticalAlignment', 'top','FontSize', 14);   
        text(stance_start_time, text_y_pos,sprintf('%.2f', stance_start_time), ...
             'HorizontalAlignment', 'center','VerticalAlignment', 'top','FontSize', 14);
        text(current_end_time, text_y_pos,sprintf('%.2f', current_end_time), ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'top','FontSize', 14);
        if ~isempty(unaffected_footcontact_time)
            text(unaffected_footcontact_time, y_lim(2), 'Unaffected Footcontact', 'Color',[0.3,0.3,0.3],...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 8);
            xline(unaffected_footcontact_time,'-k','LineWidth',1.2, 'HandleVisibility','off');
            if unaffected_footcontact_time ~= current_end_time  
            text(unaffected_footcontact_time, text_y_pos, sprintf('%.2f', unaffected_footcontact_time), ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 14);
            end
        end
        %% --

        legend('Location','northeast');
        save_dir = fullfile(save_path, filenames{i});

        if ~exist(save_dir, "dir")
            mkdir(save_dir);
        end

    
        %%  ----- 
        %{
            アシスト開始タイミングと終了タイミングの平均値と標準偏差算出用
            足部接地のタイミングとの比較を行いたい
            重心上昇なら重心最高点
            股関節屈曲なら最大股関節伸展角度のタイミングも導出
        %}
        % ---- アシスト終了が遊脚期開始後になってしまうとうまく導出できないため、前の歩行周期のデータを編集
        if isempty(assist_start_time)
            assist_start_time = NaN;
        end
        if isempty(assist_end_time) 
            assist_end_time = NaN;
        end
        if j==1 && (assist_end_time(1)-current_start_time) < 0.1  %　sub14_as1のためのコード　0m地点からの歩行は足を踏み出してからアシストではなくアシストから足を踏み出している
            assist_end_time(1) = assist_end_time(2);
            assist_end_time(2) = [];
        end
        
        % ----
        current_gaitcycle_time = current_end_time - current_start_time;
        assist_start_perc = (assist_start_time - current_start_time)/ current_gaitcycle_time * 100;
        assist_end_perc = (assist_end_time - current_start_time) / current_gaitcycle_time * 100;
        paretic_footcontact_perc = (stance_start_time - current_start_time) / current_gaitcycle_time * 100;
        unaffected_footcontact_perc = (unaffected_footcontact_time - current_start_time) / current_gaitcycle_time * 100;

        idx_angle_stance = (time>= paretic_contact_frame_time(j+1)) & (time < paretic_contact_end_frame_time(j+1));
        if strcmp(target_joint, 'CoM Vertical')
            [joint_event_feature, joint_event_time_idx] = max(paretic_angle_data(idx_angle_stance));
            joint_event_time = stance_start_time + time(joint_event_time_idx);
            joint_event_str = 'CoM Max: ';
            text_joint_y = joint_event_feature + 1;
        elseif strcmp(target_joint, 'Hip Flexion')
            [joint_event_feature, joint_event_time_idx] = min(paretic_angle_data(idx_angle_stance));
            joint_event_time = stance_start_time + time(joint_event_time_idx);
            joint_event_str = 'HipEx Max: ';
            text_joint_y = joint_event_feature - 5;
        elseif strcmp(target_joint, 'L5 Forward')
            abs_paretic_angle_data = abs(paretic_angle_data(idx_angle_stance));
            [~, joint_event_time_idx] = min(abs_paretic_angle_data);
            joint_event_time = stance_start_time + time(joint_event_time_idx);
        end
        
        xline(joint_event_time, '--b', 'HandleVisibility','off');
        text(joint_event_time, text_joint_y, [joint_event_str, sprintf('%.2fs', joint_event_time)], ...
            'HorizontalAlignment','center', "FontSize",12, 'Color','b');
        
        joint_event_perc = (joint_event_time - current_start_time) / current_gaitcycle_time * 100;

        if ~isempty(assist_end_time)
            if length(all_assist_end_time) >0 && isnan(all_assist_end_time(end))  && ~isnan(all_assist_start_time(end))
                all_assist_end_time(end) = all_current_end_time(end) + assist_end_time(1) - current_start_time;
                all_assist_end_perc(end) = (assist_end_time(1) - all_current_start_time(end)) / (all_current_end_time(end) - all_current_start_time(end)) * 100;
                if length(assist_end_time) == 1
                    assist_end_time(2) = NaN;
                    assist_end_perc(2) = NaN;
                end
                all_assist_end_time = [all_assist_end_time, assist_end_time(2)];
                all_assist_end_perc = [all_assist_end_perc; assist_end_perc(2)];
            else
                all_assist_end_time = [all_assist_end_time, assist_end_time(1)];
                all_assist_end_perc = [all_assist_end_perc; assist_end_perc(1)];
            end
        end      
        all_current_start_time = [all_current_start_time, current_start_time];
        all_assist_start_time = [all_assist_start_time, assist_start_time];
        all_current_end_time = [all_current_end_time , current_end_time];
        
        all_step_number = [all_step_number; j];
        all_assist_start_perc = [all_assist_start_perc; assist_start_perc];
        all_paretic_footcontact_perc = [all_paretic_footcontact_perc; paretic_footcontact_perc];
        all_unaffected_footcontact_perc = [all_unaffected_footcontact_perc; unaffected_footcontact_perc];
        all_joint_event_perc = [all_joint_event_perc; joint_event_perc];
        
        filename= [filenames{i}, filename_joint,sprintf('swingIVL_step%02d_TIME.jpeg', j)]; 
        save_file = fullfile(save_dir, filename);
        saveas(gcf, save_file);
        progress = i / length(filepaths);
        waitbar(progress, f, 'Progressing...');
    end
    
    if strcmp(target_joint, 'CoM Vertical')
        joint_event_title = "Max CoM-z (Stance Phase)";
    elseif strcmp(target_joint, 'Hip Flexion')
        joint_event_title = "Max Hip Extension (Stance Phase)";
    elseif strcmp(target_joint, 'L5 Forward')
        joint_event_title = "Pelvis Over Paretic Foot";
    end
    if length(all_step_number) ~= length(all_unaffected_footcontact_perc)
        all_unaffected_footcontact_perc = [all_unaffected_footcontact_perc; NaN];
    end

    title = ["Step No.","Assist Start Timing","Foot Contact Timing (Paretic)","Foot Contact Timing (unaffected)","Assist End Timing",joint_event_title];
    table = [all_step_number, all_assist_start_perc, all_paretic_footcontact_perc, all_unaffected_footcontact_perc, all_assist_end_perc, all_joint_event_perc];
    mean_value = ["Mean", mean(all_assist_start_perc,'omitnan'), mean(all_paretic_footcontact_perc,'omitnan'), mean(all_unaffected_footcontact_perc,'omitnan'), mean(all_assist_end_perc,'omitnan'), mean(all_joint_event_perc,'omitnan')];
    std_value = ["STD", std(all_assist_start_perc,'omitnan'), std(all_paretic_footcontact_perc,'omitnan'), std(all_unaffected_footcontact_perc,'omitnan'), std(all_assist_end_perc,'omitnan'), std(all_joint_event_perc,'omitnan')];
    export_table = [title; table; mean_value; std_value];
    excel_filename = [filenames{i}, filename_joint, '.xlsx'];
    export_excel_filename = fullfile(save_dir, excel_filename);
    writematrix(export_table, export_excel_filename);
end
close(f);
close all;
clear all;
disp('Completely Processed!')


function add_phase_swingIVL_backgrounds(contact_end_time,contact_time,next_contact_end_time,y_lim)
    bg_swing = fill([contact_end_time,contact_time,contact_time,contact_end_time], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], [1, 0.5, 0], 'EdgeColor','none','FaceAlpha',0.05, 'HandleVisibility','off'); hold on;
    bg_stance = fill([contact_time,next_contact_end_time, next_contact_end_time,contact_time], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor','none','FaceAlpha',0.05,'HandleVisibility','off');
    uistack(bg_stance, 'bottom');
    uistack(bg_swing, 'bottom');
   
    text(contact_end_time+0.01, y_lim(2)-0.02, 'Swing Phase', 'FontSize', 10, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top','Rotation',90);
    text(contact_time+0.01, y_lim(2)-0.02, 'Stance Phase', 'FontSize', 10, 'Color', [0 0 0.5], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top','Rotation',90);
end