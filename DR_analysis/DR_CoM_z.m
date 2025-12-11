clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right'
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\09_DRvsNW\CoM_z';
[nw_paths, ~] = getSubjectDataNW(target_foot);
[dr_paths, filenames] = getSubjectDataDR(target_foot);
write_data_file = [save_folder,'DR_CoM_vertical_excursion.xlsx'];

%% -- save folder check --
if ~exist(save_folder, 'dir')
    fprintf('\n-----------------------------------------------------------\n');
    fprintf('The save folder does not exist\n');
    fprintf('Please create this folder or update the ''save_folder'' variable.\n');
    fprintf('-----------------------------------------------------------\n');
end
if ~exist(write_data_file, 'file')
    empty_table = table();
    writetable(empty_table,write_data_file);
end

% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
DR_MEAN_COLOR = [0 0 0.7];
DR_RANGE_COLOR = [0.4 0.6 1];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;
THRESHOLD = 2.22;  % AbleBodied Participants 10%tile

excursions_table = table('Size',[0,3],'VariableTypes', {'string','double','double'}, ...
    'VariableNames',{'ParticipantID', 'CountBelowThreshold', 'OccurenceRatio'});

% NW
if strcmp(target_foot, 'Nondisabled')
    iteration_setup = 1:length(nw_paths);
else 
    iteration_setup = 1:2:length(nw_paths);
end


for p_idx = iteration_setup   
    all_nw_resampled_angles = [];
    all_dr_resampled_angles = [];
    all_CoM_vertical_excursions = [];

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    current_dr_data = GaitData(dr_paths{p_idx}, '時系列データ 5m');
    [dr_Rcontact_frame,dr_Rcontact_end_frame, dr_Lcontact_frame, dr_Lcontact_end_frame] = ...
        detectValidFootContacts(current_dr_data.RFootContact, current_dr_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        current_dr_contact_frame = dr_Lcontact_frame;
        current_dr_contact_end_frame = dr_Lcontact_end_frame;
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        current_dr_contact_frame = dr_Rcontact_frame;
        current_dr_contact_end_frame = dr_Rcontact_end_frame;
    end

    for j = 1:length(current_nw_contact_frame)-1
        current_cycle = current_nw_data.CoM.z( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
        norm_current_cycle = norm_current_cycle * 100;

        original_x = linspace(0, 1, length(norm_current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
    for j = 1:length(current_dr_contact_frame)-1
        current_cycle = current_dr_data.CoM.z( ...  %
            current_dr_contact_frame(j):current_dr_contact_frame(j+1));
        norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
        norm_current_cycle = norm_current_cycle * 100;

        original_x = linspace(0, 1, length(norm_current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

        max_stance_angle_per_cycle = max(resampled_cycle(10:40));
        min_stance_angle_per_cycle = min(resampled_cycle(1:20));
        current_CoM_vertical_excursion = max_stance_angle_per_cycle - min_stance_angle_per_cycle;

        all_dr_resampled_angles = [all_dr_resampled_angles, resampled_cycle'];
        all_CoM_vertical_excursions = [all_CoM_vertical_excursions, current_CoM_vertical_excursion];
    end
    if p_idx+1 <= length(nw_paths)
        current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
        [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
            detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
        current_dr_data = GaitData(dr_paths{p_idx+1}, '時系列データ 5m');
        [dr_Rcontact_frame,dr_Rcontact_end_frame, dr_Lcontact_frame, dr_Lcontact_end_frame] = ...
            detectValidFootContacts(current_dr_data.RFootContact, current_dr_data.LFootContact);
    
        if strcmpi(target_foot, 'Left')
            current_nw_contact_frame = nw_Lcontact_frame;
            current_nw_contact_end_frame = nw_Lcontact_end_frame;
            current_dr_contact_frame = dr_Lcontact_frame;
            current_dr_contact_end_frame = dr_Lcontact_end_frame;
        else  % only case for Right
            current_nw_contact_frame = nw_Rcontact_frame;
            current_nw_contact_end_frame = nw_Rcontact_end_frame;
            current_dr_contact_frame = dr_Rcontact_frame;
            current_dr_contact_end_frame = dr_Rcontact_end_frame;
        end
        
        for j = 1:length(current_nw_contact_frame)-1
            current_cycle = current_nw_data.CoM.z( ...  %
                current_nw_contact_frame(j):current_nw_contact_frame(j+1));
            norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
            norm_current_cycle = norm_current_cycle * 100;
    
            original_x = linspace(0, 1, length(norm_current_cycle));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

            all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
        end
        for j = 1:length(current_dr_contact_frame)-1
            current_cycle = current_dr_data.CoM.z( ...  %
                current_dr_contact_frame(j):current_dr_contact_frame(j+1));
            
            norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
            norm_current_cycle = norm_current_cycle * 100;
    
            original_x = linspace(0, 1, length(norm_current_cycle));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);
            
            max_stance_angle_per_cycle = max(resampled_cycle(10:40));
            min_stance_angle_per_cycle = min(resampled_cycle(1:20));
            current_CoM_vertical_excursion = max_stance_angle_per_cycle - min_stance_angle_per_cycle;

            all_dr_resampled_angles = [all_dr_resampled_angles, resampled_cycle'];
            all_CoM_vertical_excursions = [all_CoM_vertical_excursions, current_CoM_vertical_excursion];
        end
    end
    %% calculate each (DR, NW) data
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    dr_uniform_x = uniform_x_temp;
    dr_mean_resampled = mean(all_dr_resampled_angles, 2);
    dr_std_resampled = std(all_dr_resampled_angles, 1, 2);
    dr_std_max = dr_mean_resampled + dr_std_resampled;
    dr_std_min = dr_mean_resampled - dr_std_resampled;

    [min_dr_stance, minidx_dr_stance] = min(dr_mean_resampled(1:30));
    [max_dr_stance, maxidx_dr_stance] = max(dr_mean_resampled(10:40));
    maxidx_dr_stance = maxidx_dr_stance + 10;
    minidx_dr_stance_xaxis = minidx_dr_stance / 100;
    maxidx_dr_stance_xaxis = maxidx_dr_stance / 100;
    
    mean_CoM_vertical_excursion = mean(all_CoM_vertical_excursions);
    std_CoM_vertical_excursion = std(all_CoM_vertical_excursions);
    
    %% ---ttest---- 20250916
    p_values = zeros(1, UNIFORM_LENGTH);
    for i=1:UNIFORM_LENGTH
        if size(all_nw_resampled_angles, 2) > 1 && size(all_dr_resampled_angles, 2) > 1
            [~, p_values(i)] = ttest2(all_nw_resampled_angles(i,:), all_dr_resampled_angles(i,:));
        else
            p_values(i) = 1;
        end
    end

    %  -- plot
    fig = figure('Visible','off');
    [cfg1, ~] = plot_config('CoM Vertical');  %
    cfg1.setup_gait_cycle_axis();
    cfg1.add_image_above();
    hold on;
    Phase_Support; hold on;
    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    
    % NW
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    % DR
    fill_x_dr = [dr_uniform_x, fliplr(dr_uniform_x)];
    fill_y_dr = [dr_std_min', fliplr(dr_std_max')];
    fill(fill_x_dr, fill_y_dr, DR_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(dr_uniform_x, dr_mean_resampled, '--', 'Color', DR_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    ax = gca;
    y_max = ax.YLim(2);
    y_min = ax.YLim(1);
    significant_indices = find(p_values < 0.05);
    significant_x = dr_uniform_x(significant_indices);

    y_lim_current = ax.YLim;
    y_asterisk = y_lim_current(2) - (y_lim_current(2)-y_lim_current(1))*0.03; % グラフの上端から少し下に配置
    
    plot(significant_x, repmat(y_asterisk, size(significant_x)), '*k', 'MarkerSize', 8, 'HandleVisibility','off');
    
    %% 重心最高点と最小点の算出 
    plot([dr_uniform_x(1),dr_uniform_x(50)],[max_dr_stance,max_dr_stance], '--r'); hold on;
    plot([dr_uniform_x(1),dr_uniform_x(50)],[min_dr_stance,min_dr_stance], '--r'); hold on;
    text(minidx_dr_stance_xaxis, min_dr_stance-0.2, sprintf('Min%d%%', minidx_dr_stance), "FontSize",12,'Color','r',...
        'HorizontalAlignment','left', 'VerticalAlignment','top', 'BackgroundColor', 'w'); hold on;
    text(maxidx_dr_stance_xaxis, max_dr_stance+0.3, sprintf('Vertical CoM Excursion\n %.2f ± %.2f cm  at %d%%', mean_CoM_vertical_excursion, std_CoM_vertical_excursion, maxidx_dr_stance), ...
        "FontSize",12,'Color','r', 'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor', 'w'); hold on;
    save_filename = [filenames{ceil(p_idx/2)}, '_CoM_z-NWvsDR.png'];
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    set(fig, 'Visible', 'off');  

    %%  --- occurence ratio ---
    if ~isempty(all_CoM_vertical_excursions)
        count_below_threshold = sum(all_CoM_vertical_excursions < THRESHOLD);
        total_cycles = length(all_CoM_vertical_excursions);
        occurence_ratio = (count_below_threshold / total_cycles) * 100;
    else
        count_below_threshold = 0;
        occurence_ratio = 0;
    end
    participant_id = filenames{ceil(p_idx/2)};
    new_row = table({participant_id}, count_below_threshold, occurence_ratio, ...
        'VariableNames', {'ParticipantID', 'CountBelowThreshold', 'OccurenceRatio'});
    excursions_table = [excursions_table;new_row];
    %%  ------
end

if strcmpi(target_foot, 'Left')
    writetable(excursions_table, write_data_file, 'Sheet', 'Left');
else
    writetable(excursions_table, write_data_file, 'Sheet', 'Right');
end

disp('Completely Successed!')

function Phase_Support
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