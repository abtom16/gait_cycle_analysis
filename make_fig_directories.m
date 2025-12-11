function figure_dirs = make_fig_directories(Modified_input_file)

[path, name, ~]=fileparts(Modified_input_file);
figure_path = fullfile(path, 'figure');
% folder for each subject
if ~exist(figure_path, 'dir')
    mkdir(figure_path);
    disp("'figure' folder not found. Creating new directory");
end

% folder for each recording
name = char(name);  %%文字列にしないと[]がリストになってしまう
eachtrial_figdir = fullfile(figure_path,name);
if ~exist(eachtrial_figdir,'dir')
    mkdir(eachtrial_figdir);
    disp(['Figure folder for "',name,'" has been created!']);
end

% Define figure types
figure_types = {'gait_feature', 'CoM_movement', 'joint_angle_halfleg', 'trajectory', 'Both_joint_angle', 'joint_addthigh', 'withLOG_eachstep'};

% Loop through each figure type and create the corresponding directory
for i = 1:length(figure_types)
    % Create the subdirectory for each figure type
    fieldname = figure_types{i};
    figure_subdir = fullfile(eachtrial_figdir, fieldname);
    
    if ~exist(figure_subdir, 'dir')
        mkdir(figure_subdir);
    end

    figure_dirs.(fieldname) = figure_subdir;
end