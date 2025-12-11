clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

% Analyse 'Left' or 'Right' foot
target_foot = 'Left';  % If you want to analyse right foot, change to 'Right'
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\08_ASvsNW\Toe_z';
[nw_paths, filenames] = getSubjectDataNWForASanalyze(target_foot);
[as_paths, ~, ~ , ~] = getAssistData(target_foot);

% for lowpass filter
CUTOFF = 10;
FZ = 60;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
AS_MEAN_COLOR = [0.7 0 0.4];
AS_RANGE_COLOR = [0.9 0.7 0.8];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;


if strcmp(target_foot, 'Nondisabled')
    iteration_setup = 1:length(nw_paths);
else
    iteration_setup = 1:2:length(nw_paths);
end

for p_idx = iteration_setup
    all_nw_resampled_angles = [];
    all_as_resampled_angles = [];
    all_CoM_vertical_excursions = [];

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    current_as_data = GaitData(as_paths{p_idx}, '時系列データ 5m');
    [as_Rcontact_frame,as_Rcontact_end_frame, as_Lcontact_frame, as_Lcontact_end_frame] = ...
        detectValidFootContacts(current_as_data.RFootContact, current_as_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        current_as_contact_frame = as_Lcontact_frame;
        current_as_contact_end_frame = as_Lcontact_end_frame;
        current_nw_data_toe_z = current_nw_data.LToe.z;
        current_as_data_toe_z = current_as_data.LToe.z;
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        current_as_contact_frame = as_Rcontact_frame;
        current_as_contact_end_frame = as_Rcontact_end_frame;
        current_nw_data_toe_z = current_nw_data.RToe.z;
        current_as_data_toe_z = current_as_data.RToe.z;
    end

    for j = 1:length(current_nw_contact_frame)-1
        current_cycle = current_nw_data_toe_z( ...  %
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
        norm_current_cycle = norm_current_cycle * 100;

        original_x = linspace(0, 1, length(norm_current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

        all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
    end
    for j = 1:length(current_as_contact_frame)-1
        current_cycle = current_as_data_toe_z( ...  %
            current_as_contact_frame(j):current_as_contact_frame(j+1));
        norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
        norm_current_cycle = norm_current_cycle * 100;

        original_x = linspace(0, 1, length(norm_current_cycle));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

        all_as_resampled_angles = [all_as_resampled_angles, resampled_cycle'];
    end
    if p_idx+1 <= length(nw_paths)
        current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
        [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
            detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
        current_as_data = GaitData(as_paths{p_idx+1}, '時系列データ 5m');
        [as_Rcontact_frame,as_Rcontact_end_frame, as_Lcontact_frame, as_Lcontact_end_frame] = ...
            detectValidFootContacts(current_as_data.RFootContact, current_as_data.LFootContact);
    
        if strcmpi(target_foot, 'Left')
            current_nw_contact_frame = nw_Lcontact_frame;
            current_nw_contact_end_frame = nw_Lcontact_end_frame;
            current_as_contact_frame = as_Lcontact_frame;
            current_as_contact_end_frame = as_Lcontact_end_frame;
            current_nw_data_toe_z = current_nw_data.LToe.z;
            current_as_data_toe_z = current_as_data.LToe.z;
        else  % only case for Right
            current_nw_contact_frame = nw_Rcontact_frame;
            current_nw_contact_end_frame = nw_Rcontact_end_frame;
            current_as_contact_frame = as_Rcontact_frame;
            current_as_contact_end_frame = as_Rcontact_end_frame;
            current_nw_data_toe_z = current_nw_data.RToe.z;
            current_as_data_toe_z = current_as_data.RToe.z;
        end
        
        for j = 1:length(current_nw_contact_frame)-1
            current_cycle = current_nw_data_toe_z( ...  %
                current_nw_contact_frame(j):current_nw_contact_frame(j+1));
            norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
            norm_current_cycle = norm_current_cycle * 100;
    
            original_x = linspace(0, 1, length(norm_current_cycle));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);

            all_nw_resampled_angles = [all_nw_resampled_angles, resampled_cycle'];
        end
        for j = 1:length(current_as_contact_frame)-1
            current_cycle = current_as_data_toe_z( ...  %
                current_as_contact_frame(j):current_as_contact_frame(j+1));
            
            norm_current_cycle = current_cycle - min(current_cycle);   %% to set the Minimum CoM z-position as the baseline for each stride
            norm_current_cycle = norm_current_cycle * 100;
    
            original_x = linspace(0, 1, length(norm_current_cycle));
            uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
            resampled_cycle = interp1(original_x, norm_current_cycle, uniform_x_temp);
            
            all_as_resampled_angles = [all_as_resampled_angles, resampled_cycle'];
        end
    end
    %% calculate each (AS, NW) data
    nw_uniform_x = uniform_x_temp;
    nw_mean_resampled = mean(all_nw_resampled_angles, 2);
    nw_std_resampled = std(all_nw_resampled_angles, 1, 2);
    nw_std_max = nw_mean_resampled + nw_std_resampled;
    nw_std_min = nw_mean_resampled - nw_std_resampled;
    
    as_uniform_x = uniform_x_temp;
    as_mean_resampled = mean(all_as_resampled_angles, 2);
    as_std_resampled = std(all_as_resampled_angles, 1, 2);
    as_std_max = as_mean_resampled + as_std_resampled;
    as_std_min = as_mean_resampled - as_std_resampled;

    [min_as_swing, min_as_swing_idx] = min(as_mean_resampled(65:90));
    [max_as_stance, maxidx_as_stance] = max(as_mean_resampled(10:40));
    min_as_swing_idx = min_as_swing_idx + 65;
    min_as_swing_xaxis = min_as_swing_idx / 100;
    
    
    %% ---ttest---- 20250916
    p_values = zeros(1, UNIFORM_LENGTH);
    for i=1:UNIFORM_LENGTH
        if size(all_nw_resampled_angles, 2) > 1 && size(all_as_resampled_angles, 2) > 1
            [~, p_values(i)] = ttest2(all_nw_resampled_angles(i,:), all_as_resampled_angles(i,:));
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
    Phase_Support; hold on;
    yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    
    % NW
    fill_x_nw = [nw_uniform_x, fliplr(nw_uniform_x)];
    fill_y_nw = [nw_std_min', fliplr(nw_std_max')];
    fill(fill_x_nw, fill_y_nw, NW_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(nw_uniform_x, nw_mean_resampled, '--', 'Color', NW_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    % AS
    fill_x_as = [as_uniform_x, fliplr(as_uniform_x)];
    fill_y_as = [as_std_min', fliplr(as_std_max')];
    fill(fill_x_as, fill_y_as, AS_RANGE_COLOR, 'FaceAlpha',0.5, 'EdgeColor', 'none', ...
        'HandleVisibility','off'); hold on;
    plot(as_uniform_x, as_mean_resampled, '--', 'Color', AS_MEAN_COLOR, ...
        'DisplayName', 'Normal Walking', 'LineWidth', 1.5); hold on;
    
    ax = gca;
    y_max = ax.YLim(2);
    y_min = ax.YLim(1);
    significant_indices = find(p_values < 0.05);
    significant_x = as_uniform_x(significant_indices);

    y_lim_current = ax.YLim;
    y_asterisk = y_lim_current(2) - (y_lim_current(2)-y_lim_current(1))*0.03; % グラフの上端から少し下に配置
    
    plot(significant_x, repmat(y_asterisk, size(significant_x)), '*k', 'MarkerSize', 8, 'HandleVisibility','off');
    
    %% 重心最高点と最小点の算出 
    plot([as_uniform_x(60),as_uniform_x(95)],[min_as_swing,min_as_swing], '--r'); hold on;
    text(min_as_swing_xaxis, min_as_swing+1.5, sprintf('Min%.2fcm', min_as_swing), "FontSize",12,'Color','r',...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'BackgroundColor', 'w'); hold on;
    save_filename = [filenames{ceil(p_idx/2)}, '_Toe_z-NWvsAS.png'];
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    set(fig, 'Visible', 'off');  

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