%% --- height 1/2 ver. for Gotech MTG in 0624 (made 2025/06/23) --

for i=1: length(Lcontact_end_frame_time)-1

    % -- When you want to change graph's height, you can execute these code
    % 2025/06/23
    h_fig = figure('Units', 'pixels'); % Figureオブジェクトのハンドルを取得し、単位をpixelsに設定
    current_pos = get(h_fig, 'Position'); % 現在のポジションを取得
    new_height = current_pos(4) / 2; % 高さを半分にする
    new_bottom = current_pos(2) + new_height; % 図が上に移動するようにbottomを調整
    set(h_fig, 'Position', [current_pos(1), new_bottom, current_pos(3), new_height]); % 新しいポジションを設定
    % --
    idx_angle = (time>= Lcontact_end_frame_time(i)) & (time < Lcontact_end_frame_time(i+1));
    idx_log = (log_time>= Lcontact_end_frame_time(i)) & (log_time < Lcontact_end_frame_time(i+1));
    current_log_time = log_time(idx_log);
    current_log_data = log_data(idx_log);

    % angle y-axis(left)
    plot(time(idx_angle), Langle_data(idx_angle),'DisplayName','Left Leg', 'Color', [0, 0, 1], 'LineWidth',2); hold on;

    ylabel('Knee Flexion  [deg]', FontSize=14);  %
    ax = gca;
    ax.YAxis(1).FontSize = 14;
    y_lim = [-15,70];  %
    ylim(y_lim);

    % -Common(x-axis)  editted in 20250620
    title(sprintf('Step %d Left side (%.2f-%.2f sec)', i, Lcontact_end_frame_time(i), Lcontact_end_frame_time(i+1)));
    xlim([Lcontact_end_frame_time(i), Lcontact_end_frame_time(i+1)]);
    y_lim_current = ylim(); 
    xlabel_y_pos = y_lim_current(1) - (y_lim_current(2) - y_lim_current(1)) * 0.02; 

    xlabel('Time [s]', 'FontSize', 14, 'Units', 'data', 'Position', [mean(xlim()), xlabel_y_pos]);

    ax.XAxis.FontSize = 14;
    add_phase_swingIVL_backgrounds(Lcontact_end_frame_time(i),Lcontact_frame_time(i+1),Lcontact_end_frame_time(i+1),y_lim); hold on;
    [cfg,~] = plot_config('Knee Angle', 'swing');  %
    current_xlim_vals = xlim();
    cfg.add_normal_range_SwingInterval(current_xlim_vals); hold on;
    % -

    % Log y-axis(right) 
    yyaxis right
    plot(log_time(idx_log), log_data(idx_log)*0.8, 'DisplayName', 'Assist Log', 'Color', [0, 1, 0], 'LineWidth',1.2);
    current_xlim_vals_for_label = xlim();
    label_x_pos = current_xlim_vals_for_label(2) + (current_xlim_vals_for_label(2) - current_xlim_vals_for_label(1)) * 0.04;

    ylabel('Assist Signal', 'FontSize', 14, 'Color', [0 1 0], 'Units', 'data', 'Position', [label_x_pos, 0.5], 'HorizontalAlignment', 'center');
    yticks(0.8);
    yticklabels({'ON'});
    ax = gca;
    ax.YAxis(2).FontSize = 10;
    ax.YAxis(2).Color = [0, 1 ,0];
    ylim([0 1]);

    % ---Adding time of starting Assist 
    diff_log = diff(current_log_data);
    assist_start_idx = find(diff_log == 1);
    assist_start_time = current_log_time(assist_start_idx);
    assist_end_idx = find(diff_log == -1);
    assist_end_time = current_log_time(assist_end_idx);

    % テキストを追加 (Y軸の右側に関連付ける)
    assist_start_str = sprintf('%.2fs', assist_start_time);
    text_assist_start = text(assist_start_time, ax.YAxis(2).Limits(2)*0.8, assist_start_str, ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
             'Color', [0 1 0], 'FontSize', 12, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);

    assist_end_str = sprintf('%.2fs', assist_end_time);
    text_assist_end = text(assist_end_time+0.03, ax.YAxis(2).Limits(2)*0.8, assist_end_str, ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
        'Color', [0 1 0], 'FontSize', 12, 'BackgroundColor',[1,1,1], EdgeColor=[0.5 0.5 0.5]);
    % ---

    %  --Adding xlabel (made in 20250620)
    current_start_time = Lcontact_end_frame_time(i);
    stance_start_time = Lcontact_frame_time(i+1);
    current_end_time = Lcontact_end_frame_time(i+1);
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
    text(current_start_time, text_y_pos, ... 
         sprintf('%.2f', current_start_time), ...
         'HorizontalAlignment', 'left', ...
         'VerticalAlignment', 'top', ...   
         'FontSize', 12);   
    text(stance_start_time, text_y_pos, ...
         sprintf('%.2f', stance_start_time), ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', ...
         'FontSize', 12);
    text(current_end_time, text_y_pos, ...
         sprintf('%.2f', current_end_time), ...
         'HorizontalAlignment', 'right', ...
         'VerticalAlignment', 'top', ...
         'FontSize', 12);
    % --

    legend('Location','northeast');

    filename = sprintf('Knee_Half_swingIVL_step_%02d.jpeg', i);
    save_file = fullfile(figure_Lside, filename);
    saveas(gcf, save_file);
end