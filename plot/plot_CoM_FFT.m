clc;
addpath(genpath(fullfile(pwd,'..', '..')));
file_paths = {
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal1.xlsx";  %paretic side is right 
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-002.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";   %paretic side is right 
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW2.xlsx";  
    % able-bodied
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1107asari_normal.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_1205_abe.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub1.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub2.xlsx";
    "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\able_bodied\Modified_kitahara_sub3.xlsx";
}; 

filenames_list = {
    'sub1_NW1';
    'sub1_NW2';
    'sub2_NW1';
    'sub2_NW2';
    'sub3_NW1';
    'sub3_NW2';
    'sub4_NW1';
    'sub4_NW2';
    'sub5_NW1';
    'sub5_NW2';
    'sub6_NW1';
    'sub6_NW2';
    'sub7_NW1';
    'sub7_NW2';
    'sub8_NW1';
    'sub8_NW2';
    'sub9_NW1';
    'sub9_NW2';
    'asari';
    'abe';
    'kitahara_sub1';
    'kitahara_sub2';
    'kitahara_sub3';
};


%%
Fs = 60;
cutoff = 10;
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\05_CoManalysis\FFT\CoM_az';
%% 

for i=1:length(file_paths)
    current_nw_path = file_paths{i};
    filename = filenames_list{i};
    data = GaitData(current_nw_path, '時系列データ 5m');

    %%
    data_m = data.CoM.az - mean(data.CoM.az);
    filtered_data = lowpass(data.CoM.az, cutoff, Fs);

    filename_orig = [filename, '_CoM_az.png'];
    filtered_filename = sprintf('_CoM_az_filt%.2fHz.png', cutoff);
    filename_orig_norm = [filename, 'CoM_az_NORM.png'];
    axis_label = 'Z';
    %%
    
    T = 1/Fs;             % Sampling period  1/60(Hz^-1)
    L = length(data_m);          

    %% Graph1: spectrum analysis for original data  
    %{
        Y: raw FFT result
        P2: 2-side amplitude spwctrum (P probably derives from Periodogram)
        P1: single side amplitude spectrum
    %}
    Y_orig = fft(data_m);
    P2_orig = abs(Y_orig/L);   % Compute the magnitude of the FFT output(=Y). /L normalizes the amplitude, preventing it from inceasing with the signal's length. 
    P1_orig = P2_orig(1:round(L/2)+1);  % Select the frequency component from 0Hz to the Nyquist frequency. In FFT results, the information for negative frequencies is a mirror image of positive ones
    P1_orig(2:end-1) = 2*P1_orig(2:end-1);
    
    fig_orig = figure('Visible','off');
    f = Fs*(0:round(L/2))/L;
    bar(f,P1_orig) 

    title(sprintf('Frequency Spectrum of Original CoM %s-acceleration', axis_label));
    xlabel('Frequency [Hz]', FontSize=16);
    ylabel('Amplitude [m/s^2]', FontSize=16);
    ylim([0 1]);
    ax_orig = gca;
    ax_orig.FontSize = 14;

    save_filepath = fullfile(save_folder, filename_orig);
    saveas(fig_orig, save_filepath);


    %% Graph2: spectrum analysis for Low-passed Filtered Data
    Y_filt = fft(filtered_data);
    P2_filt = abs(Y_filt/L);
    P1_filt = P2_filt(1:round(L/2)+1);
    P1_filt(2:end-1) = 2*P1_filt(2:end-1);

    fig_filt = figure('Visible','off');
    f = Fs*(0:round(L/2))/L;
    bar(f,P1_filt,'r') 

    title(sprintf('Frequency Spectrum of Filtered CoM %s-acceleration', axis_label))
    xlabel('Frequency [Hz]', FontSize=16);
    ylabel('Amplitude [m/s^2]', FontSize=16);
    ylim([0 1]);
    ax_filt = gca;
    ax_filt.FontSize = 14;

    filename_filt = [filename, filtered_filename];
    save_filepath_filt = fullfile(save_folder, filename_filt);
    saveas(fig_filt, save_filepath_filt);

    %% Graph3: spectrum analysis for original data -- NORMALIZE by the maximum value --
    max_amplitude_orig = max(P1_orig);

    if max_amplitude_orig == 0
        P1_orig_norm = P1_orig;
    else
        P1_orig_norm = P1_orig / max_amplitude_orig;
    end
    fig_orig_norm = figure('Visible','off');
    bar(f, P1_orig_norm, 'cyan');
    
    % -- frequency of maximum value
    [max_val_norm, max_idx_norm] = max(P1_orig_norm);
    freq_atmax = f(max_idx_norm); % frequency which is maximum value
    phase_atmax = angle(Y_orig(max_idx_norm));

    text(freq_atmax, 1.02, sprintf('Max: %.1fHz', freq_atmax),"FontSize",14,'Color','k', ...
        "VerticalAlignment",'bottom', 'HorizontalAlignment','center', 'BackgroundColor','w');
    % -- frequency of second maximum value
    P1_orig_norm_temp = P1_orig_norm;
    P1_orig_norm_temp(max_idx_norm) = 0;
    
    [second_max_val_norm, second_max_idx_norm] = max(P1_orig_norm_temp);
    freq_atsecondmax = f(second_max_idx_norm);
    phase_atsecondmax = angle(Y_orig(second_max_idx_norm));

    text(freq_atsecondmax, 0.9, sprintf('2nd: %.1fHz (Amp: %.2f)', freq_atsecondmax, second_max_val_norm), ...
        "FontSize",12, 'Color','k', "VerticalAlignment",'bottom', 'HorizontalAlignment','center');
    % -- frequency of third maximum value
    P1_orig_norm_temp(second_max_idx_norm) = 0;

    [third_max_val_norm, third_max_idx_norm] = max(P1_orig_norm_temp);
    freq_atthirdmax = f(third_max_idx_norm);
    phase_atthirdmax = angle(Y_orig(third_max_idx_norm));
    if third_max_val_norm >= 0.7
        text(freq_atthirdmax, 0.75, sprintf('3nd: %.1fHz (Amp: %.2f)', freq_atthirdmax, third_max_val_norm), ...
        "FontSize",12, 'Color','k', "VerticalAlignment",'bottom', 'HorizontalAlignment','center');
    end

    % - graph property
    title(sprintf('Normalized Frequency Spectrum of original CoM %s-acceleration', axis_label));
    xlabel('Frequency [Hz]', FontSize=16);
    xlim([0 10]);   %  over 10Hz data contains lots of noise
    ylabel('Normalized Amplitude (Relative to Max)', FontSize=16);
    ylim([0 1.1]);
    ax_orig_norm = gca;
    ax_orig_norm.FontSize = 14;
    
    % --- Add Phase Information Below the Graph Title ---
    % Get the current figure title (if any)
    current_title = get(get(gca,'Title'),'String');
    if isempty(current_title)
        current_title = ''; % Set to empty string if no title exists
    end
    
    % Create text string to display phase information
    phase_info_str = sprintf('Phases: Max=%.1f(rad), 2nd=%.1f(rad)', phase_atmax, phase_atsecondmax);
    if third_max_val_norm >= 0.7
        phase_info_str = [phase_info_str, sprintf(', 3rd=%.1f(rad)', phase_atthirdmax)];
    end
    
    % Option 1: Update the title (will create a multi-line title)
    title({current_title, phase_info_str});
    
    % % Option 2: Add a new text object positioned below the title
    % % Set figure and axes units to normalized for relative positioning
    % set(gcf, 'Units', 'normalized'); 
    % set(gca, 'Units', 'normalized'); 
    % 
    % % Position slightly below the typical title location (may require adjustment)
    % title_pos = get(get(gca,'Title'), 'Position');
    % text_y_pos = title_pos(2) - 0.05;    % Move down from title position (adjust as needed)
    % text_x_pos = 0.5;                    % Center horizontally on the graph
    % 
    % text(text_x_pos, text_y_pos, phase_info_str, 'Units', 'normalized', ...
    %     'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
    %     'FontSize', 10, 'Color', 'blue', 'BackgroundColor', 'white');


    save_filepath_norm = fullfile(save_folder, filename_orig_norm);
    saveas(fig_orig_norm, save_filepath_norm);

end

disp('Completly Proessed!')