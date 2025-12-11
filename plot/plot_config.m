function [config, export_filename] = plot_config(angle_label,cycle_mode)
    % %% 引数の文字を予測変換させる処理
    % arguments
    %     angle_label (1,1) string {mustBeMember(angle_label, ["Hip Flexion", "Hip Abduction", "Hip Rotation", "Knee Angle", ...
    %         "Ankle Angle", "Trunk Flexion", "Lumber Lateral", "Trunk Lateral", "L5 Accel", "CoM Vertical", "Toe Clearance", ...
    %         "Shin Angle", "Hip Sway"])}
    %     cycle_mode (1,1) string
    % end
    
    %  引数が3つ渡されない、つまりcycle_modeを定義しなかったときはdedaultを引数に入れる
    if nargin < 2 || isempty(cycle_mode)
        cycle_mode = 'default';
    end
    Normal_Range_file = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\" + ...
        "Gait_Analysis_Xsens\Export_fig\plot\NormalRange_Healthy_data.xlsx";
    mean_data = [];
    std_data = [];

    %%  if data_measure.RHip.extensionみたいにフィールドを条件式にすることができないらしいので、めんどくさいがラベル設定
    if strcmp(angle_label, 'Hip Flexion')
        y_lim = [-20, 50];
        y_label = 'Hip Flexion [deg]';
        export_filename = 'Hip_Flexion';
        angle_label_plus = 'Flexion';
        angle_label_minus = 'Extension';
        mean_data = readmatrix(Normal_Range_file, 'Sheet','両股関節伸展角度','Range','AD1:AD100');
        std_data = readmatrix(Normal_Range_file, 'Sheet','両股関節伸展角度','Range','AE1:AE100');
    elseif strcmp(angle_label, 'Hip Abduction')
        y_lim = [-15, 15];
        y_label = 'Hip Abduction [deg]';
        export_filename = 'Hip_Abduction';
        angle_label_plus = 'Abduction';
        angle_label_minus = 'Adduction';
        % mean_data = readmatrix(Normal_Range_file, 'Sheet', '両股関節外転角度正規化', 'Range', 'AC1:AC100');
        % std_data = readmatrix(Normal_Range_file, 'Sheet', '両股関節外転角度正規化', 'Range', 'AD1:AD100');
    elseif strcmp(angle_label, 'Hip Rotation')
        y_lim = [-15, 15];
        y_label = 'Hip Rotation [deg]';
        export_filename = 'Hip_Rotation';
        angle_label_plus = 'Internal Rotation';
        angle_label_minus = 'External Rotation';
    elseif strcmp(angle_label, 'Knee Angle')
        y_lim = [-10, 70];
        y_label = 'Knee Flexion [deg]';
        export_filename = 'Knee_Flexion';
        angle_label_plus = 'Flexion';
        angle_label_minus = 'Extension';
        mean_data = readmatrix(Normal_Range_file, 'Sheet','両膝関節角度','Range','AD1:AD100');
        std_data = readmatrix(Normal_Range_file, 'Sheet','両膝関節角度','Range','AE1:AE100');
    elseif strcmp(angle_label, 'Ankle Angle')
        y_lim = [-45, 30];
        y_label = 'Ankle Dorsiflexion Angle [deg]';
        export_filename = 'Ankle_angle';
        angle_label_plus = 'Dorsiflexion';
        angle_label_minus = 'Plantar Flexion';
        mean_data = readmatrix(Normal_Range_file, 'Sheet','両足関節角度','Range','AD1:AD100');
        std_data = readmatrix(Normal_Range_file, 'Sheet','両足関節角度','Range','AE1:AE100');
    elseif strcmp(angle_label, 'Trunk Flexion')
        y_lim = [-7, 7];
        y_label = 'Trunk Forward Tilt Angle [deg]';
        export_filename = 'Trunk_AP';
        angle_label_plus = 'Anterior';
        angle_label_minus = 'Posterior';
    elseif strcmp(angle_label, 'Lumber Lateral')
        y_lim = [-7, 7];
        y_label = 'Lumber Lateral Bending Angle [deg]';
        export_filename = 'lumber_ML';
        angle_label_plus = 'Right';   %% Please check if it's right   
        angle_label_minus = 'Left';
    elseif strcmp(angle_label, 'Trunk Lateral')
        y_lim = [-7, 7];
        y_label = 'Trunk Lateral Bending Angle [deg]';
        export_filename = 'Trunk_NecktoPelvis_ML';
        angle_label_plus = 'Right';   %% Please check if it's right   
        angle_label_minus = 'Left';
    elseif strcmp(angle_label, 'L5 Accel')   %%  Please check the difference between using filter and not using it 
        y_lim = [-3, 3];
        y_label = 'L5 Lateral Acceleration';
        export_filename = 'L5_ML_accel';
        angle_label_plus = 'Right';    %% Please check if it's right 
        angle_label_minus = 'Left';
    elseif strcmp(angle_label, 'Thigh Vertical')
        y_lim = [-5, 5];
        y_label = 'Thigh Vertical Motion [cm]';
        export_filename = 'Thigh_z';
        angle_label_plus = 'Upward';    %% Please check if it's right 
        angle_label_minus = 'Downward';
    elseif strcmp(angle_label, 'CoM Vertical')
        y_lim = [0, 5];
        y_label = 'CoM Vertical Motion [cm]';
        export_filename = 'CoM_vertical';
        angle_label_plus = 'Upward';    %% Please check if it's right 
        angle_label_minus = 'Downward';
    elseif strcmp(angle_label, 'CoM Vertical Velocity')
        y_lim = [-0.3, 0.3];
        y_label = 'CoM Velocity -VT-  [m/s]';
        export_filename = 'CoM_velo_VT';
        angle_label_plus = 'Upward';    %% Please check if it's right 
        angle_label_minus = 'Downward';
    elseif strcmp(angle_label, 'CoM Vertical Accel')
        y_lim = [-5, 5];
        y_label = 'CoM Accel -VT-  [m/s^2]';
        export_filename = 'CoM_accel_VT';
        angle_label_plus = 'Upward';    %% Please check if it's right 
        angle_label_minus = 'Downward';
    elseif strcmp(angle_label, 'CoM Mediolateral')
        y_lim = [-10, 25];
        y_label = 'CoM Mediolateral [cm]';
        export_filename = 'CoM_y';
        angle_label_plus = 'Non Disabled Side';    %% Please check if it's right 
        angle_label_minus = 'Paretic Side';
    elseif strcmp(angle_label, 'CoM Forward')
        y_lim = [-30, 100];
        y_label = 'CoM Forward Motion [cm]';
        export_filename = 'CoM_forward';
        angle_label_plus = 'Forward';    %% Please check if it's right 
        angle_label_minus = 'Backward';
    elseif strcmp(angle_label, 'L5 Forward')
        y_lim = [-30, 100];
        y_label = 'L5 Forward Motion [cm]';
        export_filename = 'CoM_forward';
        angle_label_plus = 'Forward';    %% Please check if it's right 
        angle_label_minus = 'Backward';
    elseif strcmp(angle_label, 'Toe Clearance')
        y_lim = [0, 20];
        y_label = 'Toe Height [cm]';
        export_filename = 'Toe_Clearance';
        angle_label_plus = 'Upward';    %% Please check if it's right 
        angle_label_minus = 'Ground';
    elseif strcmp(angle_label, 'Shin Angle')
        y_lim = [-45, 45];
        y_label = 'Shin Angle [deg]';
        export_filename = 'Shin_Angle';
        angle_label_plus = 'Forward';    %% Please check if it's right 
        angle_label_minus = 'Backward';
    elseif strcmp(angle_label, 'Shin Angular Velo')
        y_lim = [-180, 180];
        y_label = 'Shin Angular Velo [deg/s]';
        export_filename = 'Shin_AngularVelo';
        angle_label_plus = 'Forward';    %% Please check if it's right 
        angle_label_minus = 'Backward';
    elseif strcmp(angle_label, 'Hip Sway')
        y_lim = [-15, 15];
        y_label = 'Hip Sway [cm]';
        export_filename = 'Hip_Sway';
        angle_label_plus = 'Non Disabled Side';    %% Please check if it's right 
        angle_label_minus = 'Paretic Side';
    elseif strcmp(angle_label, 'Load on Unaffected')
        y_lim = [-5, 25];
        y_label = 'CoM (ML) [cm]';
        export_filename = 'Load_on_unaffected';
        angle_label_plus = 'Paretic Side';    %% Please check if it's right 
        angle_label_minus = 'Unaffected Side';
    elseif strcmp(angle_label, 'Hip Flexion Angular Velocity')
        y_lim = [-200, 200];
        y_label = 'Hip Flexion Angular Velocity [deg/s]';
        export_filename = 'HipEx_angular_velo';
        angle_label_plus = 'Flexion';    %% Please check if it's right 
        angle_label_minus = 'Extension';
    elseif strcmp(angle_label, 'TLA Angle')
        y_lim = [-45, 45];
        y_label = 'TLA Angle [deg]';
        export_filename = 'TLA_Angle';
        angle_label_plus = 'Forward';    %% Please check if it's right 
        angle_label_minus = 'Backward';
    else
        valid_labels = {'Hip Flexion', 'Hip Abduction', 'Hip Rotation', 'Knee Angle', ...
            'Ankle Angle', 'Trunk Flexion', 'Lumber Lateral', 'Trunk Lateral', 'L5 Accel', 'CoM Vertical', ' Toe Clearance', ...
            'Shin Angle', 'Hip Sway', 'TLA Angle'};
        [~, closest_idx] = min(cellfun(@(x) strdist(angle_label, x), valid_labels));
        closest_label = valid_labels{closest_idx};
        error('error: angle label "%s" is not supported. Did you mean "%s"?', angle_label, closest_label);
    end
    
    config.add_phase_backgrounds = @() add_phase_backgrounds(y_lim);
    config.add_phase_backgrounds_SwingInterval = @() add_phase_backgrounds_SwingInterval(y_lim);
    config.setup_gait_cycle_axis = @() setup_gait_cycle_axis(y_label, y_lim, angle_label_plus, angle_label_minus);
    config.add_gait_event_markers = @() add_gait_event_markers(y_lim);
    if ~isempty(mean_data)
        config.add_normal_range = @() add_normal_range(mean_data, std_data);
        config.add_normal_range_SwingInterval = @(current_xlim_vals) add_normal_range_SwingInterval_timescaled( ...
            mean_data, std_data, current_xlim_vals);
    else
        config.add_normal_range = @() [];
    end
    config.add_image_above = @() add_image_above(cycle_mode);
end

%%  background  %%
function add_phase_backgrounds(y_lim)
    bg_stance = fill([0,0.6,0.6,0], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], 'b', ...
        'EdgeColor','none','FaceAlpha',0.05, 'HandleVisibility','off'); hold on;
    bg_swing = fill([0.6,1,1,0.6], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1,0.5,0], ...
        'EdgeColor','none','FaceAlpha',0.05,'HandleVisibility','off');
    uistack(bg_stance, 'bottom');
    uistack(bg_swing, 'bottom');

    text(0.05, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Stance Phase', 'FontSize', 12, ...
        'Color', [0 0 0.5], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    text(0.65, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Swing Phase', 'FontSize', 12, ...
        'Color', [0.8 0.4 0], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
end

function add_phase_backgrounds_SwingInterval(y_lim)
    bg_stance = fill([0.4,1,0.4,1], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], ...
        'b', 'EdgeColor','none','FaceAlpha',0.05, 'HandleVisibility','off'); hold on;
    bg_swing = fill([0,0.4,0,0.4], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], ...
        [1,0.5,0],'EdgeColor','none','FaceAlpha',0.05,'HandleVisibility','off');
    uistack(bg_stance, 'bottom');
    uistack(bg_swing, 'bottom');

    text(0.05, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Swing Phase', 'FontSize', 12, ...
        'Color', [0.8 0.4 0], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    text(0.45, y_lim(2) - (y_lim(2)-y_lim(1))*0.05, 'Stance Phase', 'FontSize', 12, ...
        'Color', [0 0 0.5], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
end

%%  x-axis normalization  %%
function setup_gait_cycle_axis(y_label, y_lim, angle_label_plus, angle_label_minus)
    xlabel('Gait Cycle [%]', 'FontSize', 16);
    xticks_val = 0:0.1:1;
    xticks(xticks_val);
    xticklabels(arrayfun(@(v) sprintf('%.0f', v*100), xticks_val, 'UniformOutput', false));
    ylabel(y_label, 'FontSize', 16);
    ylim(y_lim);
    ax = gca;
    ax.FontSize = 14;
    
    original_pos = ax.Position; 
    
    left_margin_increase = 0.01; % 例: 左側マージンをFigure幅の5%増やす
    ax.Position = [original_pos(1) + left_margin_increase, original_pos(2), ...
                   original_pos(3) - left_margin_increase, original_pos(4)];
    text(-0.15, max(ylim), angle_label_plus, 'HorizontalAlignment', 'center', ...
        'VerticalAlignment','middle','Rotation',90,'FontSize',12 ,'EdgeColor', 'k', 'Clipping','off');
    text(-0.15, min(ylim), angle_label_minus, 'HorizontalAlignment','center', ...
        'VerticalAlignment','middle','Rotation',90, 'FontSize',12, 'EdgeColor', 'k','Clipping','off');

    % if strcmp(angle_label_plus, 'Upward')    %%  due to small scale, position of test is getting lower
    %     text(-0.15, max(ylim)-0.05, angle_label_plus, 'HorizontalAlignment', 'center', ...
    %         'VerticalAlignment','middle','Rotation',90,'FontSize',12 ,'EdgeColor', 'k');
    % else
    %     text(-0.15, max(ylim), angle_label_plus, 'HorizontalAlignment', 'center', ...
    %         'VerticalAlignment','middle','Rotation',90,'FontSize',12, 'EdgeColor', 'k');
    % end
    % annotation('arrow', [0.075, 0.075], [0.70, 0.80]);
    % annotation('arrow', [0.075, 0.075], [0.15, 0.05]);
end

function add_gait_event_markers(y_lim)
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7, 'HandleVisibility','off');
    uistack(l_x, "bottom");

    events = [
        0.00, "Initial Contact";
        0.10, "Single Support Start";
        0.30, "Heel Off";
        0.50, "Double Support Start";
        0.60, "Swing Phase Start";
        0.85, "Shank Vertical"
    ];

    for i = 1:size(events, 1)
        pos = double(events(i, 1));
        label = events(i, 2);

        line([pos,pos], y_lim, 'LineStyle', '-', 'Color', [0, 0, 0.9, 0.3], 'LineWidth', 1, 'HandleVisibility','off');
        text(pos+0.03, max(y_lim), label, 'Rotation', 90, 'Color', [0,0,0.9,0.3], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
end

%%  normal range  %%
function add_normal_range(mean_data, std_data)
    x_data = linspace(0,1,100);
    std_min = mean_data - std_data;
    std_max = mean_data + std_data;
    for k=1:99
        bg_grey = fill([x_data(k), x_data(k+1),x_data(k+1),x_data(k)], ...
            [std_min(k),std_min(k+1),std_max(k+1),std_max(k)], [0.5, 0.5, 0.5], ...
            'FaceAlpha', 0.2, 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on;
    end
    uistack(bg_grey, 'bottom');
end

function add_normal_range_SwingInterval_timescaled(mean_data, std_data, current_xlim_vals)
    split_point = 60;
    mean_data = [mean_data(split_point+1:end); mean_data(1:split_point)];
    std_data= [std_data(split_point+1:end); std_data(1:split_point)];

    std_min = mean_data - std_data;
    std_max = mean_data + std_data;
    
    xmin_time = current_xlim_vals(1);
    xmax_time = current_xlim_vals(2);
    
    % x_data_scaled = linspace(xmin_time, xmax_time, length(mean_data));
    % 20250620 adjusting scaling for percentage-based normal range
    % ensures that the 0-100% gait cycle data from normal range healthy is
    % correctly mapped to the actual, variable time duration of the
    % currrent plot
    % this resolves the 'ずれ’ (misalignment) issue
    plot_duration = xmax_time - xmin_time;
    x_percent = linspace(0, 1, length(mean_data));
    x_data_scaled = xmin_time + x_percent * plot_duration;

                                                                            
    for k=1:length(mean_data)-1
        bg_grey = fill([x_data_scaled(k), x_data_scaled(k+1),x_data_scaled(k+1),x_data_scaled(k)], ...
            [std_min(k),std_min(k+1),std_max(k+1),std_max(k)], [0.5, 0.5, 0.5], ...
            'FaceAlpha', 0.2, 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on;
    end
    uistack(bg_grey, 'bottom');
end

%% gait cycle illustration
function add_image_above(cycle_mode)
    if strcmp(cycle_mode, 'swing')
        image_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\Gait_Analysis_Xsens\Export_fig\plot\gait_cycle_swingIVL_illustration.png"; 
    else
        image_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\Gait_Analysis_Xsens\Export_fig\plot\gait_cycle_illustration.png"; 
    end

    image_height_ratio = 0.2;

    fig = gcf;
    ax = gca;

    fig_pos = get(fig, 'Position');
    ax_pos = get(ax, 'Position');

    new_fig_height = fig_pos(4) * (1 + image_height_ratio);
    fig_pos(4) = new_fig_height;
    set(fig, "Position", fig_pos);

    new_ax_pos = [ax_pos(1), ax_pos(2) / (1 + image_height_ratio), ...
        ax_pos(3), ax_pos(4) / (1 + image_height_ratio)];
    set(ax, 'Position', new_ax_pos);

    img_height = image_height_ratio / (1 + image_height_ratio);
    img_ax = axes('Position', [0, ax_pos(2)/(1+image_height_ratio) + ...
        ax_pos(4)/(1+image_height_ratio) + 0.01, 1, img_height]);

    try
        img = imread(image_path);
        imshow(img, 'Parent', img_ax);
        axis(img_ax, 'off');
    catch
        text(0.5, 0.5, 'Image could not be loaded. The file may not exist or the path may be incorrect.', ...
            'Parent',img_ax, 'HorizontalAlignment','center');
        axis(img_ax, 'off');
    end

    axes(ax);
end