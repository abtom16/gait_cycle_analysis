function plot_jointangle_profile_eachstep(data_measure, angle_label, figure_dirs, valid_Rcontact_frame)
    figure;
    set(gcf, 'defaultLegendAutoUpdate','off');
    hold on;
    
    %{
        Available labels for the 'angle_label' argument of function 'plot_config':
        'Hip Flexion', 'Hip Abduction', 'Hip Rotation', 'Knee Angle', 
        'Ankle Angle', 'Trunk Flexion', 'Lumber Lateral', 'Trunk Lateral', 'L5 Accel', 'CoM Vertical'
    %}
    [cfg, export_filename] = plot_config(angle_label);

    uniform_length = 100;
    % 線形補間とプロット
    for j = 1:length(valid_Rcontact_frame)-1
        current_cycle = data_measure(valid_Rcontact_frame(j):valid_Rcontact_frame(j+1));
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x = linspace(0, 1, uniform_length);
        resampled_angles(:, j) = interp1(original_x, current_cycle, uniform_x);
        plot(uniform_x, resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
    end
    
    % 平均線のプロット
    mean_resampled = mean(resampled_angles, 2);
    plot(uniform_x, mean_resampled, '-r', 'DisplayName', 'Average', 'LineWidth', 2); hold on;

    cfg.add_phase_backgrounds()
    cfg.setup_gait_cycle_axis()
    cfg.add_gait_event_markers()
    cfg.add_image_above()

    saveas(gcf, fullfile(figure_dirs, [export_filename, '.jpeg']));
    close(gcf);
end