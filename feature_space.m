clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
target_foot = 'Right';  % If you want to analyse right foot, change to 'Right'
[nw_paths, filenames] = getSubjectData(target_foot);

save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\07_clinical-analysis\FeatureSpace';
target_filename = '_ankle_knee-NW.png';


% for lowpass filter
CUTOFF = 10;
FS = 60;
dt = 1 / FS;

% color definition
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
NW_MEAN_COLOR_LEFT = [0.5 0.5 0.5];
NW_RANGE_COLOR_LEFT = [0.8 0.8 0.8];

%%  data calculation for each procedure
UNIFORM_LENGTH = 100;

if strcmp(target_foot, 'Nondisabled')
    iteration_setup = 1:length(nw_paths);
else
    iteration_setup = 1:2:length(nw_paths);
end

for p_idx = iteration_setup
    all_nw_resampled_angles_knee = [];
    all_nw_resampled_angles_ankle = [];
    all_unaffected_contact_timing = [];
    all_unaffected_footoff_timing = [];
    all_affected_footoff_timing = [];

    current_nw_data = GaitData(nw_paths{p_idx}, '時系列データ 5m');
    [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
        detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
    
    if strcmpi(target_foot, 'Left')
        current_nw_contact_frame = nw_Lcontact_frame;
        current_nw_contact_end_frame = nw_Lcontact_end_frame;
        current_unaffected_contact = nw_Rcontact_frame;
        current_unaffected_footoff = nw_Rcontact_end_frame;
        ankle_side='LAnkle';
        ankle_side = 'LKnee';
    else  % only case for Right
        current_nw_contact_frame = nw_Rcontact_frame;
        current_nw_contact_end_frame = nw_Rcontact_end_frame;
        current_unaffected_contact = nw_Lcontact_frame;
        current_unaffected_footoff = nw_Lcontact_end_frame;
        foot_side='RAnkle';
        ankle_side = 'RKnee';
    end

    for j = 1:length(current_nw_contact_frame)-1
        %% -- 健側の離地のタイミングを算出（単脚支持期のスタート）--
        %{
            frames_in_current_cycle：
            現在の歩行周期内でcurrent_unaffected_toeoffがある場合
            該当するフレームをtrueとする
            unaffected_toeoff：
            該当するフレームがtrueであるフレーム数を取得する        
        %}
        [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
            getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
            all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
            current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

        current_cycle_knee = current_nw_data.(foot_side).angle( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        current_cycle_ankle = current_nw_data.(ankle_side).angle( ...
            current_nw_contact_frame(j):current_nw_contact_frame(j+1));
        
        original_x_knee = linspace(0, 1, length(current_cycle_knee));
        uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
        resampled_cycle_knee = interp1(original_x_knee, current_cycle_knee, uniform_x_temp);
        all_nw_resampled_angles_knee = [all_nw_resampled_angles_knee, resampled_cycle_knee'];
    
        original_x_ankle = linspace(0, 1, length(current_cycle_ankle));
        resampled_cycle_ankle = interp1(original_x_ankle, current_cycle_ankle, uniform_x_temp);
        all_nw_resampled_angles_ankle = [all_nw_resampled_angles_ankle, resampled_cycle_ankle'];
    end
    if strcmp(target_foot, 'Left') || strcmp(target_foot, 'Right')
        if p_idx + 1 <= length(nw_paths)
            current_nw_data = GaitData(nw_paths{p_idx+1}, '時系列データ 5m');
            [nw_Rcontact_frame,nw_Rcontact_end_frame,nw_Lcontact_frame, nw_Lcontact_end_frame] = ...
                detectValidFootContacts(current_nw_data.RFootContact, current_nw_data.LFootContact);
            
            if strcmpi(target_foot, 'Left')
                current_nw_contact_frame = nw_Lcontact_frame;
                current_nw_contact_end_frame = nw_Lcontact_end_frame;
                current_unaffected_contact = nw_Rcontact_frame;
                current_unaffected_footoff = nw_Rcontact_end_frame;
                ankle_side='LAnkle';
                knee_side = 'LKnee';
            else  % only case for Right
                current_nw_contact_frame = nw_Rcontact_frame;
                current_nw_contact_end_frame = nw_Rcontact_end_frame;
                current_unaffected_contact = nw_Lcontact_frame;
                current_unaffected_footoff = nw_Lcontact_end_frame;
                ankle_side='RAnkle';
                knee_side = 'RKnee';
            end
        
            for j = 1:length(current_nw_contact_frame)-1
                [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
                    getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, ...
                    all_affected_footoff_timing, current_nw_contact_frame(j), current_nw_contact_frame(j+1), ...
                    current_unaffected_footoff, current_unaffected_contact, current_nw_contact_end_frame);

                current_cycle_knee = current_nw_data.(knee_side).angle( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                current_cycle_ankle = current_nw_data.(ankle_side).angle( ...
                    current_nw_contact_frame(j):current_nw_contact_frame(j+1));
                
                original_x_knee = linspace(0, 1, length(current_cycle_knee));
                uniform_x_temp = linspace(0, 1, UNIFORM_LENGTH);
                resampled_cycle_knee = interp1(original_x_knee, current_cycle_knee, uniform_x_temp);
                all_nw_resampled_angles_knee = [all_nw_resampled_angles_knee, resampled_cycle_knee'];
        
                original_x_ankle = linspace(0, 1, length(current_cycle_ankle));
                resampled_cycle_ankle = interp1(original_x_ankle, current_cycle_ankle, uniform_x_temp);
                all_nw_resampled_angles_ankle = [all_nw_resampled_angles_ankle, resampled_cycle_ankle'];
            end
        end
    end
    mean_unaffected_footoff_timing = mean(all_unaffected_footoff_timing, 'omitnan');
    mean_unaffected_contact_timing = mean(all_unaffected_contact_timing, 'omitnan');
    mean_affected_footoff_timing = mean(all_affected_footoff_timing, 'omitnan');

    %{
        平均値を取らず、毎歩行周期で特徴量空間にプロットする
    %}

    
    %  -- plot
    fig = figure('Visible','off', 'Position',[600 400 560 420]);    
    num_cycles = size(all_nw_resampled_angles_knee, 2);

    for k=1:num_cycles
        cycle_knee = all_nw_resampled_angles_knee(:, k);
        cycle_ankle = all_nw_resampled_angles_ankle(:, k);

        h_cycle = plot(cycle_knee, cycle_ankle, ...
            'Color', [0.7, 0.7, 0.7], 'LineWidth', 1); hold on;
        plot(cycle_knee(1), cycle_ankle(1), 'o', 'MarkerSize',5,'MarkerFaceColor',[0.7 0.7 0.7], 'MarkerEdgeColor','k'); hold on;
    end

    % yline(0, '-', 'Color', [0.5 0.5 0.5], 'HandleVisibility','off');
    xlabel('Knee Angle [deg]','FontSize', 16);
    ylabel('Ankle Angle [deg]', 'FontSize', 16);
    title('Knee - Ankle Feature Space');
    
    if strcmp(target_foot, 'Nondisabled')
        save_filename = [filenames{p_idx}, target_filename];
    else
        save_filename = [filenames{ceil(p_idx/2)}, target_filename];
    end
    
    save_fullfile = fullfile(save_folder, save_filename);
    saveas(fig, save_fullfile);
    
    % set(fig, 'Visible', 'off');
end
