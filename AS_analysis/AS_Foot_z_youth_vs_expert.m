clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right'
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\08_ASvsNW\Foot_z\youth_vs_expert';

youth_paths_left = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_as1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_as2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_as-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_as-003.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_as-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_as-002.xlsx";
    
};
expert_paths_left = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_as3.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_as4.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_as-004.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub11\Modified_sub11_as-005.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_as-003.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250630\sub12\Modified_sub12_as-004.xlsx";
};
youth_paths_right = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\Modified_as-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\Modified_as-002.xlsx";
};
expert_paths_right = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\Modified_as-003.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250825\sub15\Modified_as-004.xlsx";
};
filenames_left = {
    'sub7';
    'sub11';
    'sub12';
};
filenames_right = 'sub15';

if strcmp(target_foot, 'Left')
    youth_paths = youth_paths_left;
    expert_paths = expert_paths_left;
    filenames = filenames_left;
else
    youth_paths = youth_paths_right;
    expert_paths = expert_paths_right;
    filenames = filenames_right;
end

% for lowpexperts filter
CUTOFF = 10;
FZ = 60;

% color definition
youth_MEAN_COLOR = [0.9 0.5 0.2];
youth_RANGE_COLOR = [1.0 0.8 0.7];
expert_MEAN_COLOR = [0.7 0 0.4];
expert_RANGE_COLOR = [0.9 0.7 0.8];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;


if strcmp(target_foot, 'Nondisabled')
    iteration_setup = 1:length(youth_paths);
else
    iteration_setup = 1:2:length(youth_paths);
end

for p_idx = iteration_setup
    all_youth_resampled_angles = [];
    all_expert_resampled_angles = [];

    current_youth_data = GaitData(youth_paths{p_idx}, '時系列データ 5m');
    [youth_Rcontact_frame,youth_Rcontact_end_frame,youth_Lcontact_frame, youth_Lcontact_end_frame] = ...
        detectValidFootContacts(current_youth_data.RFootContact, current_youth_data.LFootContact);
    current_expert_data = GaitData(expert_paths{p_idx}, '時系列データ 5m');
    [expert_Rcontact_frame,expert_Rcontact_end_frame, expert_Lcontact_frame, expert_Lcontact_end_frame] = ...
        detectValidFootContacts(current_expert_data.RFootContact, current_expert_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_youth_contact_frame = youth_Lcontact_frame;
        current_youth_contact_end_frame = youth_Lcontact_end_frame;
        current_expert_contact_frame = expert_Lcontact_frame;
        current_expert_contact_end_frame = expert_Lcontact_end_frame;
        current_youth_data_foot_z = current_youth_data.LFoot.z;
        current_expert_data_foot_z = current_expert_data.LFoot.z;
    else  % only cexperte for Right
        current_youth_contact_frame = youth_Rcontact_frame;
        current_youth_contact_end_frame = youth_Rcontact_end_frame;
        current_expert_contact_frame = expert_Rcontact_frame;
        current_expert_contact_end_frame = expert_Rcontact_end_frame;
        current_youth_data_foot_z = current_youth_data.RFoot.z;
        current_expert_data_foot_z = current_expert_data.RFoot.z;
    end

    for j = 1:length(current_youth_contact_frame)-1
        current_cycle = current_youth_data_foot_z( ...  %
            current_youth_contact_frame(j):current_youth_contact_frame(j+1));
        norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position expert the bexperteline for each stride
        norm_current_cycle = norm_current_cycle * 100;

        original_x = linspace(0, 1, length(norm_current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

        all_youth_resampled_angles = [all_youth_resampled_angles, resampled_cycle'];
    end
    for j = 1:length(current_expert_contact_frame)-1
        current_cycle = current_expert_data_foot_z( ...  %
            current_expert_contact_frame(j):current_expert_contact_frame(j+1));
        norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position expert the bexperteline for each stride
        norm_current_cycle = norm_current_cycle * 100;

        original_x = linspace(0, 1, length(norm_current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

        all_expert_resampled_angles = [all_expert_resampled_angles, resampled_cycle'];
    end
    if p_idx+1 <= length(youth_paths)
        current_youth_data = GaitData(youth_paths{p_idx+1}, '時系列データ 5m');
        [youth_Rcontact_frame,youth_Rcontact_end_frame,youth_Lcontact_frame, youth_Lcontact_end_frame] = ...
            detectValidFootContacts(current_youth_data.RFootContact, current_youth_data.LFootContact);
        current_expert_data = GaitData(expert_paths{p_idx+1}, '時系列データ 5m');
        [expert_Rcontact_frame,expert_Rcontact_end_frame, expert_Lcontact_frame, expert_Lcontact_end_frame] = ...
            detectValidFootContacts(current_expert_data.RFootContact, current_expert_data.LFootContact);
    
        if strcmpi(target_foot, 'Left')
            current_youth_contact_frame = youth_Lcontact_frame;
            current_youth_contact_end_frame = youth_Lcontact_end_frame;
            current_expert_contact_frame = expert_Lcontact_frame;
            current_expert_contact_end_frame = expert_Lcontact_end_frame;
            current_youth_data_foot_z = current_youth_data.LFoot.z;
            current_expert_data_foot_z = current_expert_data.LFoot.z;
        else  % only cexperte for Right
            current_youth_contact_frame = youth_Rcontact_frame;
            current_youth_contact_end_frame = youth_Rcontact_end_frame;
            current_expert_contact_frame = expert_Rcontact_frame;
            current_expert_contact_end_frame = expert_Rcontact_end_frame;
            current_youth_data_foot_z = current_youth_data.RFoot.z;
            current_expert_data_foot_z = current_expert_data.RFoot.z;
        end
        
        for j = 1:length(current_youth_contact_frame)-1
            current_cycle = current_youth_data_foot_z( ...  %
                current_youth_contact_frame(j):current_youth_contact_frame(j+1));
            norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position expert the bexperteline for each stride
            norm_current_cycle = norm_current_cycle * 100;
    
            original_x = linspace(0, 1, length(norm_current_cycle));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

            all_youth_resampled_angles = [all_youth_resampled_angles, resampled_cycle'];
        end
        for j = 1:length(current_expert_contact_frame)-1
            current_cycle = current_expert_data_foot_z( ...  %
                current_expert_contact_frame(j):current_expert_contact_frame(j+1));
            
            norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position expert the bexperteline for each stride
            norm_current_cycle = norm_current_cycle * 100;
    
            original_x = linspace(0, 1, length(norm_current_cycle));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);
            
            all_expert_resampled_angles = [all_expert_resampled_angles, resampled_cycle'];
        end
    end
    %% calculate each (expert, youth) data
    youth_uniform_x = uniform_x_temp;
    youth_mean_resampled = mean(all_youth_resampled_angles, 2);
    youth_std_resampled = std(all_youth_resampled_angles, 1, 2);
    youth_std_max = youth_mean_resampled + youth_std_resampled;
    youth_std_min = youth_mean_resampled - youth_std_resampled;
    
    expert_uniform_x = uniform_x_temp;
    expert_mean_resampled = mean(all_expert_resampled_angles, 2);
    expert_std_resampled = std(all_expert_resampled_angles, 1, 2);
    expert_std_max = expert_mean_resampled + expert_std_resampled;
    expert_std_min = expert_mean_resampled - expert_std_resampled;

    [min_expert_swing, min_expert_swing_idx] = min(expert_mean_resampled(65:90));
    [max_expert_stance, maxidx_expert_stance] = max(expert_mean_resampled(10:40));
    min_expert_swing_idx = min_expert_swing_idx + 65;
    min_expert_swing_xaxis = min_expert_swing_idx / 100;
    
    
    %% ---ttest---- 20250916
    p_values = zeros(1, UNIFORM_LENGTH);
    for i=1:UNIFORM_LENGTH
        if size(all_youth_resampled_angles, 2) > 1 && size(all_expert_resampled_angles, 2) > 1
            [~, p_values(i)] = ttest2(all_youth_resampled_angles(i,:), all_expert_resampled_angles(i,:));
        else
            p_values(i) = 1;
        end
    end

    %  -- plot
    fig = figure('Visible','off','Position',[600 400 560 420]);
    [cfg1, ~] = plot_config('Toe Clearance');  %
    cfg1.setup_gait_cycle_axis();
    cfg1.add_image_above();
    hold on;
    Phexperte_Support; hold on;
    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
   
    
    % youth
    fill_x_youth = [youth_uniform_x, fliplr(youth_uniform_x)];
    fill_y_youth = [youth_std_min', fliplr(youth_std_max')];
    fill(fill_x_youth, fill_y_youth, youth_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(youth_uniform_x, youth_mean_resampled, '--', 'Color', youth_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    % expert
    fill_x_expert = [expert_uniform_x, fliplr(expert_uniform_x)];
    fill_y_expert = [expert_std_min', fliplr(expert_std_max')];
    fill(fill_x_expert, fill_y_expert, expert_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(expert_uniform_x, expert_mean_resampled, '--', 'Color', expert_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    ax = gca;
    y_max = ax.YLim(2);
    y_min = ax.YLim(1);
    significant_indices = find(p_values < 0.05);
    significant_x = expert_uniform_x(significant_indices);

    y_lim_current = ax.YLim;
    y_expertterisk = y_lim_current(2) - (y_lim_current(2)-y_lim_current(1))*0.03; % グラフの上端から少し下に配置
    
    plot(significant_x, repmat(y_expertterisk, size(significant_x)), '*k', 'MarkerSize', 8, 'HandleVisibility','off');
    
    %% 重心最高点と最小点の算出 
    % plot([expert_uniform_x(60),expert_uniform_x(95)],[min_expert_swing,min_expert_swing], '--r'); hold on;
    % text(min_expert_swing_xaxis, min_expert_swing+1.5, sprintf('Min%.2fcm', min_expert_swing), "FontSize",12,'Color','r',...
    %     'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor', 'w'); hold on;
    if strcmp(target_foot, 'Left')
        save_filename = [filenames{ceil(p_idx/2)}, '_Toe_z-youthvsexpert.png'];
    else
        save_filename = ['sub15','_Foot_z-youthvsexpert.png'];
    end
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    set(fig, 'Visible', 'off');  

end


disp('Completely Successed!')

function Phexperte_Support
    ax = gca;
    y_lim_current = ax.YLim;
    
    % --- 背景色の描画 ---
    % 両脚支持相1 (DS1: Initial Double Support) - 0%~10%
    bg_ds1 = fill([0, 0.1, 0.1, 0], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                  [0.5 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
    
    % 麻痺側片脚支持相 (Affected Single Support) - 10%~50%
    bg_affected_ss = fill([0.1, 0.5, 0.5, 0.1], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                          [0 0 1], 'EdgeColor', 'none','FaceAlpha', 0.05, 'HandleVisibility', 'off');   % 麻痺の時は、麻痺側の色を[0 0 1]
    
    % 両脚支持相2 (DS2: Terminal Double Support) - 50%~60%
    bg_ds2 = fill([0.5, 0.6, 0.6, 0.5], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                  [0.5 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
    
    % 健側片脚支持相 (Non-Affected Single Support) - 60%~100%
    bg_non_affected_ss = fill([0.6, 1.0, 1.0, 0.6], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                              [1 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.05,'HandleVisibility', 'off'); 
    
    % 全ての背景をグラフの底面に送る
    uistack(bg_ds1, 'bottom');
    uistack(bg_affected_ss, 'bottom');
    uistack(bg_ds2, 'bottom');
    uistack(bg_non_affected_ss, 'bottom');
    
    % --- テキストラベルの描画 ---
    % Y軸のテキスト位置を、グラフの最大値に合わせる
    text_y_top = y_lim_current(2) - (y_lim_current(2)-y_lim_current(1))*0.05;
    
    % 相の名前のテキスト
    text_ds1 = text(0.05, text_y_top, 'Double Support', 'FontSize', 12, 'Color', [0.7 0.4 0.4], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90); 
    text_affected_ss = text(0.15, text_y_top, 'Affected Single', 'FontSize', 12, 'Color', [0.9 0.75 0.5], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90);
    text_ds2 = text(0.55, text_y_top, 'Double Support', 'FontSize', 12, 'Color', [0.7 0.4 0.4], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90); 
    text_non_affected_ss = text(0.65, text_y_top, 'Non-Affected Single', 'FontSize', 12, 'Color', [0.9 0.75 0.5],  ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90);

    uistack(text_ds1, 'bottom');
    uistack(text_affected_ss, 'bottom');
    uistack(text_ds2, 'bottom');
    uistack(text_non_affected_ss, 'bottom');
end