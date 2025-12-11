function plot_feature(Modified_input_file, figure_dirs)

df = readmatrix(Modified_input_file, 'Sheet','歩容特性','Range','A11');

num_rows = size(df, 1);
valid_data = df(1:num_rows-4, :);
mean_df = df(num_rows-3, 2:end);
std_df = df(num_rows-2, 2:end);
step_No = valid_data(:, 1);
step_data = valid_data(:, 2:end);

nondisable_average_path = 'C:\abe_backup\backup\1修士\６.Xsens_analysis\歩容特性分析_abe_健常者分析用\健常者歩容特性平均.xlsx';

nondisable_data = readmatrix(nondisable_average_path, 'Sheet', 'Sheet2', 'Range', 'B16:M17');
nondisable_ave = nondisable_data(1,:);
nondisable_std = nondisable_data(2,:);

%% -------------------------  Gait feature for each leg ----------------------------- %%
title_labels = {'Right Stride Length', 'Left Stride Length','Right Step Length', 'Left Step Length', 'Right Walking Cycle', 'Left Walking Cycle', 'Right Stance time', 'Left Stance time', 'Right Swing time', 'Left Swing time', 'Right Step Width', 'Left Step Width'};
y_labels = {"Step Length [m]","Step Length [m]","Step Length [m]","Step Length [m]","time [s]","time [s]","time [s]","time [s]","time [s]","time [s]","Step Width [m]","Step Width [m]"};
for i=1:12
    %%  "current" means what gait feature is focused  %%
    current_data = step_data(:, i);
    current_mean = mean_df(i);
    current_std = std_df(i);
    valid_dataidx = ~isnan(current_data);
    num_steps = length(current_data(valid_dataidx));
    current_nondisable_ave = nondisable_ave(i);
    current_nondisable_std = nondisable_std(i);
    
    %  data for each subject  %
    figure('Visible','off');
    bar(2:num_steps+1, current_data(valid_dataidx), 'FaceColor', [0.9,0.9,0.9], 'HandleVisibility','off'); hold on;   %%  each step data
    bar(1, current_mean, 'FaceColor', [1,0,0], 'HandleVisibility','off'); hold on;     %%  average data
    errorbar(1, current_mean, current_std, 'k', 'LineWidth', 1); hold on;
    
    %  control range area  %
    x_limits = xlim;
    upper = current_nondisable_ave + current_nondisable_std;
    lower = current_nondisable_ave - current_nondisable_std;
    
    fill_x = [x_limits(1), x_limits(2),x_limits(2),x_limits(1)];
    fill_y = [lower, lower, upper, upper];
    
    fill(fill_x, fill_y, [0.7, 0.85, 1], 'EdgeColor','none','FaceAlpha', 0.5, 'HandleVisibility','off'); hold on;
    text(x_limits(1)+0.2, upper, 'Control range', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 8, 'Color', [0.3 0.3 0.7], 'FontAngle', 'italic', 'Interpreter', 'none');
    
    
    
    %%   scale adjustment for each data type i=5,6: walking cycle, i=7,8: stance time, i=9,10:swing time
    if i == 5 || i == 6
        ylim([0, 1.4]);
    elseif i == 7 || i == 8
        ylim([0, 1.0]);
    elseif i == 9 || i == 10
        ylim([0, 0.6]);
    end
    
    title(title_labels{i});
    x_labels = ["Average", strcat("Step", string(1:num_steps))];  
    xticks(1:num_steps+2);
    xticklabels(x_labels);
    xlabel("Step Number");
    ylabel(y_labels{i});
    
    saveas(gcf,fullfile(figure_dirs, [title_labels{i},'.jpeg']));
    close(gcf);

end

%% ------------------------------------------------------------------------------ %%

%% -------------------------  Gait feature for Both leg ----------------------------- %%
compare_title_labels = {'Compare double support Step Length','Compare Step Length', 'Compare Walking Cycle', 'Compare Stance time','Compare Swing time', 'Compare Step Width'};
compare_y_labels = {"Step Length [m]","Step Length [m]","time [s]","time [s]","time [s]","Step Width [m]"};
for i=1:6
    % 右足と左足のデータを取得
    num_steps = length(step_No);
    current_data_right = step_data(:, 2*i-1);
    current_data_left = step_data(:, 2*i);
    current_data_left(isnan(current_data_left)) = 0;
    current_data_right(isnan(current_data_right)) = 0;
    if current_data_right(end)==0 && current_data_left(end)==0
        num_steps_forbar = num_steps-1;
        current_data_left = current_data_left(1:end-1);
        current_data_right = current_data_right(1:end-1);
    else
        num_steps_forbar = num_steps;
    end
    
    current_mean_right = mean_df(2*i-1);
    current_mean_left = mean_df(2*i);
    current_std_right = std_df(2*i-1);
    current_std_left = std_df(2*i);
    % Control (健常者平均)
    current_nondisable_ave_right = nondisable_ave(2*i-1);
    current_nondisable_ave_left = nondisable_ave(2*i);
    current_nondisable_std_right = nondisable_std(2*i-1);
    current_nondisable_std_left = nondisable_std(2*i);
    


    % 図の作成
    figure('Visible','off');

    % バーのX位置を調整
    x_positions = 1:num_steps_forbar+2; % 各ステップのx位置
    x_positions_left = x_positions - 0.15; % for left leg
    x_positions_right = x_positions + 0.15; % for right leg

    % 各ステップのバーを作成（左右のデータを並べる）
    bar(x_positions_left(2:end-1), current_data_left, 0.3,'grouped', 'FaceColor', [0.9,0.9,0.9], 'DisplayName', 'Left Step'); hold on;
    bar(x_positions_right(2:end-1), current_data_right, 0.3, 'grouped', 'FaceColor', [0.9,0.9,0.9], 'DisplayName', 'Right Step'); hold on;

    % average data 
    bar(x_positions_left(1), current_mean_left, 0.3, 'FaceColor', [1,0,0], 'DisplayName','Left Average'); hold on;
    bar(x_positions_right(1), current_mean_right, 0.3, 'FaceColor', [0.8,0,0], 'DisplayName','Right Average'); hold on;
    errorbar(x_positions_left(1), current_mean_left, current_std_left, 'k', 'LineWidth', 1, 'HandleVisibility','off');
    errorbar(x_positions_right(1), current_mean_right, current_std_right, 'k', 'LineWidth', 1, 'HandleVisibility','off');

    % average of control(healthy) group
    x_limits = xlim;
    upper = (current_nondisable_ave_right + current_nondisable_ave_left)/2 + (current_nondisable_std_right +  current_nondisable_std_left)/2;
    lower = (current_nondisable_ave_right + current_nondisable_ave_left)/2 - (current_nondisable_std_right +  current_nondisable_std_left)/2;
    fill_x = [x_limits(1), x_limits(2),x_limits(2),x_limits(1)];
    fill_y = [lower, lower, upper, upper];
    
    fill(fill_x, fill_y, [0.7, 0.85, 1], 'EdgeColor','none','FaceAlpha', 0.5, 'HandleVisibility','off'); hold on;
    text(x_limits(1)+0.2, upper, 'Control range', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 8, 'Color', [0.3 0.3 0.7], 'FontAngle', 'italic', 'Interpreter', 'none');

    % bar(x_positions_left(end), current_nondisable_ave_left, 0.3, 'FaceColor', [0.2,0.5,0.8], 'DisplayName', 'Control Left Average'); hold on;
    % bar(x_positions_right(end), current_nondisable_ave_right, 0.3, 'FaceColor', [0.1,0.4,0.7], 'DisplayName', 'Control Right Average'); hold on;
    % errorbar(x_positions_left(end), current_nondisable_ave_left, current_nondisable_std_left, 'k', 'LineWidth', 1, 'HandleVisibility','off');
    % errorbar(x_positions_right(end), current_nondisable_ave_right, current_nondisable_std_right, 'k', 'LineWidth', 1, 'HandleVisibility','off');


    % adjuct the range of y-axis
    if i == 3
        ylim([0, 1.4]);
    elseif i == 4
        ylim([0, 1.0]);
    elseif i == 5
        ylim([0, 0.6]);
    end

    x_line = (x_positions_right(end) + x_positions_left(end-1)) / 2; % ちょうど間
    y_limits = ylim;
    plot([x_line, x_line], [y_limits(1), y_limits(2)], 'k-', 'LineWidth', 1.5, 'HandleVisibility','off');

    legend('Location','best');

    % setup of label
    title(compare_title_labels{i});
    x_labels = ["Average", strcat("Step", string(1:num_steps)), "Control Average"];
    xticks(x_positions);
    xticklabels(x_labels);
    xlabel("Step Number");
    ylabel(compare_y_labels{i});

    saveas(gcf,fullfile(figure_dirs, [compare_title_labels{i},'.jpeg']));
    close(gcf);
end

end