function[] = Export_fig(Modified_input_file,paralyzed_side)

addpath(genpath('..'));
addpath(genpath('plot'));

%%   make folder for figure
figure_dirs =  make_fig_directories(Modified_input_file);

%%   ------- 一度に見れるようまとめるため、pdf化して保存していたがあまり使わなかったので、コメントアウトしています -------
% if exist(export_filename, 'file') == 2
%     % ファイルが存在する場合、削除する
%     choice = questdlg(...
%         {'指定したファイルは既に存在します。削除して新しいファイルを保存しますか？  削除せず図を追加することも可能です', '実行キャンセルは✕ボタン'}, ...
%         'ファイルの確認', ...
%         '古いファイルを削除', '既存ファイルに図を追加', '古いファイルを削除');
% 
%     if isempty(choice)
%         % ユーザーが✕ボタンを押した場合の処理
%         disp('処理を中止しました。');
%         return;
%     end
%     if strcmp(choice, '古いファイルを削除')
%         % ファイルを削除
%         delete(export_filename);
%         disp('古いファイルを削除して上書き保存します')
%     elseif strcmp(choice, '既存ファイルに図を追加')
%         disp('既存ファイルに図を追加します');
%     end
% end
%%   ---------------------------------------------------  %%

complement_title = ["R knee flexion", "L knee flexion", "R ankle flexion", "L ankle flexion", "R hip flexion", "L hip flexion", ...
                    "R hip internal rotation", "L hip internal rotation", "R hip abduction", "L hip abduction", "lateral accel L5", "lumber lateral flex", "trunk lateral flex", "trunk forward tilt"]; 

writematrix(complement_title, Modified_input_file, 'Sheet', 'Linear_complement', 'Range', 'A1');

%%  Aquiring data
sheet_11m = '時系列データ 11m';
sheet_5m = '時系列データ 5m';
data_all = GaitData2(input_file_name, sheet_11m);
data_measure = GaitData2(input_file_name, sheet_5m);

%% --重心軌跡-- %%

start_frame = find(data_all.CoM.x > 3, 1, 'first');
end_frame = find(data_all.CoM.x > 8, 1, 'first');
gray_black = [0.5, 0.5, 0.5];

%　歩容特性　標準偏差等グラフ化　%
plot_feature(Modified_input_file, figure_dirs.gait_feature)

% 水平面-重心軌跡 %
figure('Visible', 'off');
ax = axes;
set(ax, 'Position', [0.3, 0.05, 0.4, 0.9]);
bg1 = fill([-0.5,0.5,0.5,-0.5],[0,0,3,3],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha', 0.5,'HandleVisibility','off');hold on;
bg_main = fill([-0.5,0.5,0.5,-0.5],[3,3,8,8], [0,0,1], 'EdgeColor', 'none','FaceAlpha', 0.1,'HandleVisibility','off');hold on;
bg2 = fill([-0.5,0.5,0.5,-0.5],[8,8,11,11],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha', 0.5,'HandleVisibility','off');
uistack(bg1, 'bottom');
uistack(bg_main, 'bottom');
uistack(bg2, 'bottom');

plot(data_all.CoM.y(1:start_frame), data_all.CoM.x(1:start_frame), '--','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
plot(data_all.CoM.y(start_frame:end_frame), data_all.CoM.x(start_frame:end_frame), '-k', 'LineWidth',2,'DisplayName','CoM');hold on;
plot(data_all.CoM.y(end_frame:end), data_all.CoM.x(end_frame:end), '--','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
p1 = plot(data_all.RFoot.y(1:start_frame), data_all.RFoot.x(1:start_frame), '-b','LineWidth',1,'HandleVisibility','off');hold on;
plot(data_all.RFoot.y(start_frame:end_frame), data_all.RFoot.x(start_frame:end_frame), '-b', 'LineWidth',1.2,'DisplayName','Right Foot');hold on;
p2 = plot(data_all.RFoot.y(end_frame:end), data_all.RFoot.x(end_frame:end), '-b', 'LineWidth',1,'HandleVisibility','off');hold on;
p3 = plot(data_all.LFoot.y(1:start_frame), data_all.LFoot.x(1:start_frame), '-g','LineWidth',1,'HandleVisibility','off');hold on;
plot(data_all.LFoot.y(start_frame:end_frame), data_all.LFoot.x(start_frame:end_frame), '-g', 'LineWidth',1.2,'DisplayName','Left Foot');hold on;
p4 = plot(data_all.LFoot.y(end_frame:end), data_all.LFoot.x(end_frame:end), '-g', 'LineWidth',1,'HandleVisibility','off');

p1.Color = [0,0,1,0.2];
p2.Color = [0,0,1,0.2];
p3.Color = [0,1,0,0.2];
p4.Color = [0,1,0,0.2];

legend('Location','Best');
xlim([-0.5,0.5]);
ylim([0,11]);
xlabel('Center of Mass (Lateral) [m]');
ylabel('Center of Mass (AP) [m]');
title('Trajectory of Center of Mass on the Horizontal Plane');

yline(3, '--b', '5m measurement starting point','HandleVisibility','off');
yline(8, '--b', '5m measurement endpoint','HandleVisibility','off');
saveas(gcf,fullfile(indiv_figdir, '重心軌跡水平面.jpeg'))
close(gcf);



% 矢状面-重心軌跡 %
figure('Visible', 'off');
bg1 = fill([0,3,3,0],[0,0,1,1],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha',0.5,'HandleVisibility','off');hold on;
bg_main = fill([3,8,8,3],[0,0,1,1],[0,0,1],'EdgeColor', 'none','FaceAlpha',0.1,'HandleVisibility','off');hold on;
bg2 = fill([8,11,11,8],[0,0,1,1],[0.9,0.9,0.9],'EdgeColor', 'none','FaceAlpha',0.5,'HandleVisibility','off');
uistack(bg1, 'bottom');
uistack(bg_main, 'bottom');
uistack(bg2, 'bottom');

plot(data_all.CoM.x(1:start_frame), data_all.CoM.z(1:start_frame), '--','Color', gray_black, 'LineWidth',1.2, 'HandleVisibility','off');hold on;
plot(data_all.CoM.x(start_frame:end_frame), data_all.CoM.z(start_frame:end_frame), '-k', 'LineWidth',2, 'Marker', 'x', 'MarkerIndices',1:60:end_frame-start_frame,'MarkerSize', 8,'DisplayName','CoM');hold on;
plot(data_all.CoM.x(end_frame:end), data_all.CoM.z(end_frame:end), '--','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
p5 = plot(data_all.RToe.x(1:start_frame), data_all.RToe.z(1:start_frame), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
plot(data_all.RToe.x(start_frame:end_frame), data_all.RToe.z(start_frame:end_frame), '-b', 'LineWidth',1.2,'Marker', 'x', 'MarkerIndices',1:60:end_frame-start_frame,'MarkerSize', 8,'DisplayName','Right Toe');hold on;
p6 = plot(data_all.RToe.x(end_frame:end), data_all.RToe.z(end_frame:end), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
p7 = plot(data_all.LToe.x(1:start_frame), data_all.LToe.z(1:start_frame), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');hold on;
plot(data_all.LToe.x(start_frame:end_frame), data_all.LToe.z(start_frame:end_frame), '-g', 'LineWidth',1.2,'Marker', 'x', 'MarkerIndices',1:60:end_frame-start_frame,'MarkerSize', 8,'DisplayName','Left Toe');hold on;
p8 = plot(data_all.LToe.x(end_frame:end), data_all.LToe.z(end_frame:end), '-','Color', gray_black, 'LineWidth',1.2,'HandleVisibility','off');


p5.Color = [0,0,1,0.4];
p6.Color = [0,0,1,0.4];
p7.Color = [0,1,0,0.4];
p8.Color = [0,1,0,0.4];


legend('Location','Best');
xlim([0,11]);
ylim([0,1]);
xlabel('Center of Mass (AP) [m]');
ylabel('Center of Mass (Vertical) [m]');
title('Trajectory of Center of Mass on the Sagittal Plane');

xline(3, '--b', '5m measurement starting point','HandleVisibility','off');
xline(8, '--b', '5m measurement endpoint','HandleVisibility','off');
set(gcf, 'Position', [100, 100, 900, 300]);
saveas(gcf,fullfile(indiv_figdir, '重心軌跡矢状面.jpeg'))
close(gcf);


%% --足部接地フレームを導出-- %%
[valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame] = detectValidFootContacts(data_all.RFootContact, data_all.LFootContact);


%%  ----------変更点-----------
% CoM_x_5m -> data_measure.CoM.x
% CoM_y_5m -> data_measure.CoM.y
% CoM_z_5m -> data_measure.CoM.z

% Rknee_angle -> data_measure.RKnee.angle
% Lknee_angle -> data_measure.LKnee.angle
% Rankle_angle -> data_measure.RAnkle.angle
% Lankle_angle -> data_measure.LAnkle.angle
% Rhip_abduction -> data_measure.RHip.abdct
% Lhip_abduction -> data_measure.LHip.abdct
% Rhip_rotation -> data_measure.RHip.rotation
% Lhip_rotation -> data_measure.RHip.rotation
% Rhip_extension -> data_measure.RHip.extension
% Lhip_extension -> data_measure.LHip.extension
% L5_ay_5 -> data_measure.Correct_L5.ay
% 
% Rfoot_x_5 -> data_measure.RFoot.x
% Lfoot_x_5 -> data_measure.LFoot.x
% Rfoot_y_5 -> data_measure.RFoot.y
% Lfoot_y_5 -> data_measure.LFoot.y
% Rtoe_x_5 -> data_measure.RToe.x
% Rtoe_y_5 -> data_measure.RToe.y
% Rtoe_z_5 -> data_measure.RToe.z
% Ltoe_x_5 -> data_measure.LToe.x
% Ltoe_y_5 -> data_measure.LToe.y
% Ltoe_z_5 -> data_measure.LToe.z
% Rthigh_x_5 -> data_measure.RThigh.x
% Rthigh_z_5 -> data_measure.RThigh.z
% Lthigh_x_5 -> data_measure.LThigh.x
% Lthigh_z_5 -> data_measure.LThigh.z
% 
% neck_x -> data_measure.neck.x
% neck_y -> data_measure.neck.y
% 
% Lumber_lateralFlex -> data_measure.LateralFlex.Lumber
% Pelvis2Neck_lateralFlex -> data_measure.LateralFlex.neck
% Pelvis2Neck_Flex -> data_measure.Trunk.flexion  
%%  -------------------------------------------  %%

CoM_z_5m_mean = mean(data_measure.CoM.z);

nondisabled_data = 'C:\abe_backup\backup\1修士\６.Xsens_analysis\歩容特性分析_abe_健常者分析用\健常者データ\健常者平均および標準誤差用角度データ.xlsx';

% 水平面-重心軌跡- 足部比較 %
% 接地時の足部の座標と離地時のつま先の座標を格納
Rfootx_footprint = [];
Rfooty_footprint = [];
Lfootx_footprint = [];
Lfooty_footprint = [];
Rtoex_footprint = [];
Rtoey_footprint = [];
Ltoex_footprint = [];
Ltoey_footprint = [];

for i=1:length(valid_Rcontact_frame)
    Rfootx_footprint = [Rfootx_footprint, Rfoot_x_5(valid_Rcontact_frame(i))];
    Rfooty_footprint = [Rfooty_footprint, Rfoot_y_5(valid_Rcontact_frame(i))];
end
for i=1:length(valid_Lcontact_frame)
    Lfootx_footprint = [Lfootx_footprint, Lfoot_x_5(valid_Lcontact_frame(i))];
    Lfooty_footprint = [Lfooty_footprint, Lfoot_y_5(valid_Lcontact_frame(i))];
end
for i=1:length(valid_Rcontact_frame)
    Rtoex_footprint = [Rtoex_footprint, Rtoe_x_5(valid_Rcontact_frame(i))];
    Rtoey_footprint = [Rtoey_footprint, Rtoe_y_5(valid_Rcontact_frame(i))];
end
for i=1:length(valid_Lcontact_frame)
    Ltoex_footprint = [Ltoex_footprint, Ltoe_x_5(valid_Lcontact_frame(i))];
    Ltoey_footprint = [Ltoey_footprint, Ltoe_y_5(valid_Lcontact_frame(i))];
end

foot_width = 0.1;
foot_length = 0.25; %足の長さ25cm想定


figure('Visible','off');
ax = axes;
set(ax, 'Position', [0.3, 0.05, 0.4, 0.9]);
% グラフの幅と高さを計算

for i=1:length(Rfootx_footprint)
    %足部とつま先を結ぶベクトル
    dx = Rtoex_footprint(i) - Rfootx_footprint(i);
    dy = Rtoey_footprint(i) - Rfooty_footprint(i);
    %ベクトルの長さ
    length_vec = sqrt(dx^2 + dy^2);
    %単位ベクトル
    ex = dx / length_vec;
    ey = dy / length_vec;
    % 足部とつま先を結ぶ線の法線ベクトル
    normal_vec_x = -ey;
    normal_vec_y = ex;
    
    %四角形の頂点を計算
    corner1_x = Rtoex_footprint(i) - foot_length * ex - foot_width / 2 * normal_vec_x;
    corner1_y = Rtoey_footprint(i) - foot_length * ey - foot_width / 2 * normal_vec_y;
    corner2_x = Rtoex_footprint(i) - foot_length * ex + foot_width / 2 * normal_vec_x;
    corner2_y = Rtoey_footprint(i) - foot_length * ey + foot_width / 2 * normal_vec_y;
    corner3_x = Rtoex_footprint(i) + foot_width / 2 * normal_vec_x;
    corner3_y = Rtoey_footprint(i) + foot_width / 2 * normal_vec_y;
    corner4_x = Rtoex_footprint(i) - foot_width / 2 * normal_vec_x;
    corner4_y = Rtoey_footprint(i) - foot_width / 2 * normal_vec_y;
    % 四角形を塗りつぶしてプロット
    fill([corner1_y, corner2_y, corner3_y, corner4_y], ...
         [corner1_x, corner2_x, corner3_x, corner4_x], ...
         'r', 'FaceAlpha', 0.3, 'EdgeColor', 'k', 'HandleVisibility','off');
    hold on;
end    
for i=1:length(Lfootx_footprint)
    %足部とつま先を結ぶベクトル
    dx = Ltoex_footprint(i) - Lfootx_footprint(i);
    dy = Ltoey_footprint(i) - Lfooty_footprint(i);
    %ベクトルの長さ
    length_vec = sqrt(dx^2 + dy^2);
    %単位ベクトル
    ex = dx / length_vec;
    ey = dy / length_vec;
    % 足部とつま先を結ぶ線の法線ベクトル
    normal_vec_x = -ey;
    normal_vec_y = ex;
    
    %四角形の頂点を計算
    corner1_x = Ltoex_footprint(i) - foot_length * ex - foot_width / 2 * normal_vec_x;
    corner1_y = Ltoey_footprint(i) - foot_length * ey - foot_width / 2 * normal_vec_y;
    corner2_x = Ltoex_footprint(i) - foot_length * ex + foot_width / 2 * normal_vec_x;
    corner2_y = Ltoey_footprint(i) - foot_length * ey + foot_width / 2 * normal_vec_y;
    corner3_x = Ltoex_footprint(i) + foot_width / 2 * normal_vec_x;
    corner3_y = Ltoey_footprint(i) + foot_width / 2 * normal_vec_y;
    corner4_x = Ltoex_footprint(i) - foot_width / 2 * normal_vec_x;
    corner4_y = Ltoey_footprint(i) - foot_width / 2 * normal_vec_y;
    % 四角形を塗りつぶしてプロット
    hold on;
    fill([corner1_y, corner2_y, corner3_y, corner4_y], ...
         [corner1_x, corner2_x, corner3_x, corner4_x], ...
         'r', 'FaceAlpha', 0.3, 'EdgeColor', 'k', 'HandleVisibility','off');
end 

plot(CoM_y_5m(1:end), CoM_x_5m(1:end), '-k', 'LineWidth',2,'DisplayName','CoM');hold on;
set(gca, 'XDir', 'reverse')
legend('Location','Best');
xlim([-0.3,0.3]);
ylim([3,8]);
xlabel('Center of Mass (Lateral) [m]');
ylabel('Center of Mass (AP) [m]');
title('Trajectory of Center of Mass on the Horizontal Plane');

yline(3, 'b', '5m measurement starting point', 'HandleVisibility','off');
text(-0.1, 8 - 0.05, '5m measurement endpoint', 'Color', 'b', 'VerticalAlignment', 'top', 'FontSize', 9);

saveas(gcf,fullfile(indiv_figdir, '重心軌跡水平面_足部あり.jpeg'))
close(gcf);

figure('Visible','off');
ax = axes;
set(ax, 'Position', [0.3, 0.05, 0.4, 0.9]);
% グラフの幅と高さを計算

for i=1:length(Rfootx_footprint)
    %足部とつま先を結ぶベクトル
    dx = Rtoex_footprint(i) - Rfootx_footprint(i);
    dy = Rtoey_footprint(i) - Rfooty_footprint(i);
    %ベクトルの長さ
    length_vec = sqrt(dx^2 + dy^2);
    %単位ベクトル
    ex = dx / length_vec;
    ey = dy / length_vec;
    % 足部とつま先を結ぶ線の法線ベクトル
    normal_vec_x = -ey;
    normal_vec_y = ex;
    
    %四角形の頂点を計算
    corner1_x = Rtoex_footprint(i) - foot_length * ex - foot_width / 2 * normal_vec_x;
    corner1_y = Rtoey_footprint(i) - foot_length * ey - foot_width / 2 * normal_vec_y;
    corner2_x = Rtoex_footprint(i) - foot_length * ex + foot_width / 2 * normal_vec_x;
    corner2_y = Rtoey_footprint(i) - foot_length * ey + foot_width / 2 * normal_vec_y;
    corner3_x = Rtoex_footprint(i) + foot_width / 2 * normal_vec_x;
    corner3_y = Rtoey_footprint(i) + foot_width / 2 * normal_vec_y;
    corner4_x = Rtoex_footprint(i) - foot_width / 2 * normal_vec_x;
    corner4_y = Rtoey_footprint(i) - foot_width / 2 * normal_vec_y;
    % 四角形を塗りつぶしてプロット
    fill([corner1_y, corner2_y, corner3_y, corner4_y], ...
         [corner1_x, corner2_x, corner3_x, corner4_x], ...
         'r', 'FaceAlpha', 0.3, 'EdgeColor', 'k', 'HandleVisibility','off');
    hold on;
end    
for i=1:length(Lfootx_footprint)
    %足部とつま先を結ぶベクトル
    dx = Ltoex_footprint(i) - Lfootx_footprint(i);
    dy = Ltoey_footprint(i) - Lfooty_footprint(i);
    %ベクトルの長さ
    length_vec = sqrt(dx^2 + dy^2);
    %単位ベクトル
    ex = dx / length_vec;
    ey = dy / length_vec;
    % 足部とつま先を結ぶ線の法線ベクトル
    normal_vec_x = -ey;
    normal_vec_y = ex;
    
    %四角形の頂点を計算
    corner1_x = Ltoex_footprint(i) - foot_length * ex - foot_width / 2 * normal_vec_x;
    corner1_y = Ltoey_footprint(i) - foot_length * ey - foot_width / 2 * normal_vec_y;
    corner2_x = Ltoex_footprint(i) - foot_length * ex + foot_width / 2 * normal_vec_x;
    corner2_y = Ltoey_footprint(i) - foot_length * ey + foot_width / 2 * normal_vec_y;
    corner3_x = Ltoex_footprint(i) + foot_width / 2 * normal_vec_x;
    corner3_y = Ltoey_footprint(i) + foot_width / 2 * normal_vec_y;
    corner4_x = Ltoex_footprint(i) - foot_width / 2 * normal_vec_x;
    corner4_y = Ltoey_footprint(i) - foot_width / 2 * normal_vec_y;
    % 四角形を塗りつぶしてプロット
    hold on;
    fill([corner1_y, corner2_y, corner3_y, corner4_y], ...
         [corner1_x, corner2_x, corner3_x, corner4_x], ...
         'r', 'FaceAlpha', 0.3, 'EdgeColor', 'k', 'HandleVisibility','off');
end 

plot(CoM_y_5m(1:end), CoM_x_5m(1:end), '-k', 'LineWidth',2,'DisplayName','CoM');hold on;
plot(neck_y(1:end), neck_x(1:end), '--r', 'LineWidth',2,'DisplayName','Cervital Spine' );hold on;
plot(Ltoe_y_5(1:end), Ltoe_x_5(1:end), '--g', 'LineWidth',2,'DisplayName','Left Leg' );hold on;
plot(Rtoe_y_5(1:end), Rtoe_x_5(1:end), '--g', 'LineWidth',2,'DisplayName','Right Leg' );hold on;
set(gca, 'XDir', 'reverse')
legend('Location','Best');
xlim([-0.3,0.3]);
ylim([3,8]);
xlabel('CoM (Lateral) [m]');
ylabel('CoM (AP) [m]');
title('Trajectory of Center of Mass on the Horizontal Plane');

yline(3, 'b', '5m measurement starting point','HandleVisibility','off');
text(-0.1, 8 - 0.05, '5m measurement endpoint', 'Color', 'b', 'VerticalAlignment', 'top', 'FontSize', 9);


saveas(gcf,fullfile(indiv_figdir, '重心軌跡水平面_足部あり(頸椎足部軌道あり).jpeg'))
close(gcf);
next_column = 1;

    function next_column = plot_joint_angle(input_file_name2, export_filename,indiv_figdir,side, angle_data, angle_label, y_lim, direction_max,direction_min,contact_frame, next_column)
    % angle_data: 各関節の角度データ
    % joint_name: 関節名 ('足関節' など)
    % angle_label: 関節角度のラベル ('足関節角度(°)' など)
    % y_lim: y軸の範囲
    % x_labels: x軸の目盛りラベル 
    % 図の作成
    figure('Visible', 'off');
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    
    
    bg5 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Stance Phase');hold on;
    bg6 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Swing Phase');
    uistack(bg5, 'bottom');
    uistack(bg6, 'bottom');
    
    uniform_length = 100;
    % 線形補間とプロット
    for j = 1:length(contact_frame)-1
        current_cycle = angle_data(contact_frame(j):contact_frame(j+1));
        original_x = linspace(0, 1, length(current_cycle));
        uniform_x = linspace(0, 1, uniform_length);
        resampled_angles(:, j) = interp1(original_x, current_cycle, uniform_x);
        plot(uniform_x, resampled_angles(:,j), '-k', 'HandleVisibility', 'off');
    end
    
    % 平均線のプロット
    mean_resampled = mean(resampled_angles, 2);
    plot(uniform_x, mean_resampled, '-r', 'DisplayName', 'Average', 'LineWidth', 2);
    
    % 凡例設定
    legend('Location','Best');
    
    % 軸ラベル、目盛り設定
    xlabel('Gait Cycle [%]');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel([side,'　',angle_label]);
    ylim(y_lim);
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.1, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), 'Initial Contact', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), 'Single Support Start', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), 'Heel Off', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), 'Double Support', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'Swing Phase Start', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), 'Shank Vertical', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    % グラフを保存
    % if strcmp(angle_label, 'L5左右方向の加速度 [m/s^2]')
    %     angle_label_export = 'L5左右方向の加速度';
    % else
    %     angle_label_export = angle_label;
    % end

    writematrix(mean_resampled, input_file_name2, 'Sheet', 'Linear_complement', 'Range', [char('A' + next_column - 1), '2']);
    angle_label_export = regexprep(angle_label, '\[.*?\]', '');
    saveas(gcf, fullfile(indiv_figdir, [side, angle_label_export, '.jpeg']));
    close(gcf);
    next_column = next_column + 1;
end

function compare_joint_angle(export_filename, indiv_figdir, Rangle_data, Langle_data, angle_label, y_lim, direction_max,direction_min,Rcontact_frame, Lcontact_frame, paralyzed_side)
    % angle_data: 各関節の角度データ
    % joint_name: 関節名 ('足関節' など)
    % angle_label: 関節角度のラベル ('足関節角度(°)' など)
    % y_lim: y軸の範囲
    % x_labels: x軸の目盛りラベル
    
    % 図の作成
    figure('Visible','off');
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Stance Phase');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Swing Phase');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
        % plot(Runiform_x, Rresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    for i = 1:length(Lcontact_frame)-1
        Lcurrent_cycle = Langle_data(Lcontact_frame(i):Lcontact_frame(i+1));
        Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
        Luniform_x = linspace(0, 1, uniform_length);
        Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
        % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    %% 麻痺側によって凡例の文字変更
    if strcmp(paralyzed_side, '右')
        right_label = 'Right Average ＊Paralyzed side';
    else
        right_label = 'Right Average';
    end
    if strcmp(paralyzed_side, '左')
        left_label = 'Left Average ＊Paralyzed side';
    else
        left_label = 'Left Average';
    end
    % 平均線のプロット
    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Luniform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    % 凡例設定
    legend('Location', 'Best');
    
    % 軸ラベル、目盛り設定
    xlabel('Gait Cycle [%]');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);
    
    % 方向のテキストと矢印
    text(-0.1, max(ylim)-0.1, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(-0.1, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), 'Initial Contact', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), 'Single Support Start', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), 'Heel Off', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), 'Double Support Start', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'Swing Phase start', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), 'Shank Vertical', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    
    % グラフを保存
    saveas(gcf, fullfile(indiv_figdir, ['左右比較', angle_label, '.jpeg']));
    close(gcf);
end
function compare_joint_angle_withsigma(export_filename, indiv_figdir, Rangle_data, Langle_data, angle_label, y_lim, direction_max,direction_min,Rcontact_frame, Lcontact_frame, paralyzed_side, nondisabled_data)
    if strcmp(angle_label, '股関節外転角度 [°]')
        angle_label = 'Hip joint Abduction Angle [deg]';
        mean_data = readmatrix(nondisabled_data, 'Sheet', '両股関節外転角度正規化', 'Range', 'AC1:AC100');
        std_data = readmatrix(nondisabled_data, 'Sheet', '両股関節外転角度正規化', 'Range', 'AD1:AD100');
    else
        if strcmp(angle_label, '膝関節角度 [°]')
            angle_label = 'Knee Joint Angle [deg]';
            mean_data = readmatrix(nondisabled_data, 'Sheet','両膝関節角度','Range','AD1:AD100');
            std_data = readmatrix(nondisabled_data, 'Sheet','両膝関節角度','Range','AE1:AE100');
        elseif strcmp(angle_label, '足関節角度 [°]')
            angle_label = 'Ankle Joint Angle [deg]';
            mean_data = readmatrix(nondisabled_data, 'Sheet','両足関節角度','Range','AD1:AD100');
            std_data = readmatrix(nondisabled_data, 'Sheet','両足関節角度','Range','AE1:AE100');
        elseif strcmp(angle_label, '股関節伸展角度 [°]')
            angle_label = 'Hip Joint Extention Angle [deg]';
            mean_data = readmatrix(nondisabled_data, 'Sheet','両股関節伸展角度','Range','AD1:AD100');
            std_data = readmatrix(nondisabled_data, 'Sheet','両股関節伸展角度','Range','AE1:AE100');   
        end
    end
    x_data = linspace(0,1,100);

    % 図の作成
    figure('Visible','off');
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Stance Phase');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Swing Phase');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
        % plot(Runiform_x, Rresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    for i = 1:length(Lcontact_frame)-1
        Lcurrent_cycle = Langle_data(Lcontact_frame(i):Lcontact_frame(i+1));
        Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
        Luniform_x = linspace(0, 1, uniform_length);
        Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
        % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    if strcmp(angle_label, 'Hip joint Abduction Angle [deg]')
        mean_data = mean_data + (Rresampled_angles(1) - (Rresampled_angles(1) - Lresampled_angles(1)) / 2);
    end
    std_min = mean_data - std_data;
    std_max = mean_data + std_data;

    %% 麻痺側によって凡例の文字変更
    if strcmp(paralyzed_side, '右')
        right_label = 'Right Average ＊Paralyzed Side';
    else
        right_label = 'Right Average';
    end
    if strcmp(paralyzed_side, '左')
        left_label = 'Left Average ＊Paralyzed Side';
    else
        left_label = 'Left Average';
    end
    % 平均線のプロット
    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Luniform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    for k=1:99
        bg_grey = fill([x_data(k), x_data(k+1),x_data(k+1),x_data(k)], [std_min(k),std_min(k+1),std_max(k+1),std_max(k)], [0.5, 0.5, 0.5], 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on;
    end
    uistack(bg_grey, 'bottom');
    legend('Location', 'Best');
    
    % 軸ラベル、目盛り設定
    xlabel('Gait Cycle [%]');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);
    
    % 方向のテキストと矢印
    text(-0.1, max(ylim)-0.1, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.85, 0.95]);
    text(-0.1, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), 'Initial Contact', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), 'Single Support Start', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), 'Heel Off', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), 'Double Support Start', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'Swing Phase Start', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), 'Shank Vertical', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    
    saveas(gcf, fullfile(indiv_figdir, ['左右比較', angle_label, '(健常者標準偏差あり).jpeg']));
    close(gcf);
end

function compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rangle_data, Langle_data, something_z,angle_label, y_lim, direction_max,direction_min,Rcontact_frame,comparing_label,paralyzed_side)
    % 元々はCOMの高さの変位と比較を行いたかったのでcomとなっていま
    
    % 図の作成
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Lcurrent_cycle = Langle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        something_current_cycle = something_z(Rcontact_frame(i):Rcontact_frame(i+1));

        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
        something_resampled(:, i) = interp1(Roriginal_x, something_current_cycle, Runiform_x);
        Lresampled_angles(:, i) = interp1(Roriginal_x, Lcurrent_cycle, Runiform_x);
    end
    figure('Position',[100,100,560,560],'Visible','off');
    subplot(3,1,1);
    
    something_mean_resampled = mean(something_resampled, 2);
    mean_for_ylim = mean(something_mean_resampled);
    range_ofylim = max(something_mean_resampled) - min(something_mean_resampled);
    cm_range_ofylim = 100 * range_ofylim;
    min_ofylim = mean_for_ylim - 0.5*range_ofylim - 0.005;
    max_ofylim = mean_for_ylim + 0.5*range_ofylim + 0.005;

    title_name = ['高さ移動範囲 : ',num2str(cm_range_ofylim), 'cm'];
    bga = fill([0,0.1,0.1,0],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Double Support Phase');hold on;
    bgb = fill([0.5,0.6,0.6,0.5],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Double Support Phase');
    uistack(bga, 'bottom');
    uistack(bgb, 'bottom');
    name_plot = [comparing_label,' 高さ'];
    plot(Runiform_x, something_mean_resampled, '-k','DisplayName', name_plot, 'LineWidth',2);

    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    title(title_name);
    ylim([min_ofylim, max_ofylim]);
    ylabel(comparing_label);
    legend('Location','best');

    subplot(3,1,[2,3]);
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Stance Phase');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','Swing Phase');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');

    if strcmp(paralyzed_side, '右')
        right_label = 'Right Average ＊Paralyzed Side';
    else
        right_label = 'Right Average';
    end
    if strcmp(paralyzed_side, '左')
        left_label = 'Left Average ＊Paralyzed Side';
    else
        left_label = 'Left Average';
    end

    % 平均線のプロット
    
    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Runiform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    % 軸ラベル、目盛り設定
    xlabel('Gait Cycle [%]');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);

    % 凡例設定
    legend('Location', 'Best');  
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.2, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.56, 0.66]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), 'Right Foot: Initial Contact', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), 'Right Foot: Single Support', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), 'Right Foot: Heel Off', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), 'Double Support Start', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), 'Right Foot: Swing Phase Start', 'Rotation', 90,'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), 'Right Foot：Shank Vertical', 'Rotation', 90, 'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較_', angle_label,'_',comparing_label, 'あり_右脚接地基準', '.jpeg']));
    close(gcf);
end
function compare_joint_angle_addsomething(export_filename, indiv_figdir, Rangle_data, Langle_data, something_z,something_side,angle_label, y_lim, direction_max,direction_min,Rcontact_frame,Lcontact_frame,comparing_label,paralyzed_side)
    % 元々はCOMの高さの変位と比較を行いたかったのでcomとなっていま
    
    % 図の作成
    uniform_length = 100;
    % 線形補間とプロット
    for i = 1:length(Rcontact_frame)-1
        Rcurrent_cycle = Rangle_data(Rcontact_frame(i):Rcontact_frame(i+1));
        Roriginal_x = linspace(0, 1, length(Rcurrent_cycle));
        Runiform_x = linspace(0, 1, uniform_length);
        Rresampled_angles(:, i) = interp1(Roriginal_x, Rcurrent_cycle, Runiform_x);
    end
    for i = 1:length(Lcontact_frame)-1
        Lcurrent_cycle = Langle_data(Lcontact_frame(i):Lcontact_frame(i+1));
        Loriginal_x = linspace(0, 1, length(Lcurrent_cycle));
        Luniform_x = linspace(0, 1, uniform_length);
        Lresampled_angles(:, i) = interp1(Loriginal_x, Lcurrent_cycle, Luniform_x);
        % plot(Luniform_x, Lresampled_angles(:,i), '-k', 'HandleVisibility', 'off');
    end
    if strcmp(something_side, '左')
        for i = 1:length(Lcontact_frame)-1
        something_current_cycle = something_z(Lcontact_frame(i):Lcontact_frame(i+1));
        some_original_x = linspace(0,1,length(something_current_cycle));
        some_uniform_x = linspace(0,1,uniform_length);
        something_resampled(:, i) = interp1(some_original_x, something_current_cycle, some_uniform_x);
        end
    else
        for i = 1:length(Rcontact_frame)-1
        something_current_cycle = something_z(Rcontact_frame(i):Rcontact_frame(i+1));
        some_original_x = linspace(0,1,length(something_current_cycle));
        some_uniform_x = linspace(0,1,uniform_length);
        something_resampled(:, i) = interp1(some_original_x, something_current_cycle, some_uniform_x);
        end
    end


    figure('Position',[100,100,560,560],'Visible','off');
    subplot(3,1,1);
    
    something_mean_resampled = mean(something_resampled, 2);
    mean_for_ylim = mean(something_mean_resampled);
    range_ofylim = max(something_mean_resampled) - min(something_mean_resampled);
    cm_range_ofylim = 100 * range_ofylim;
    min_ofylim = mean_for_ylim - 0.5*range_ofylim - 0.005;
    max_ofylim = mean_for_ylim + 0.5*range_ofylim + 0.005;

    title_name = ['高さ移動範囲 : ',num2str(cm_range_ofylim), 'cm'];
    bga = fill([0,0.1,0.1,0],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','両脚支持期');hold on;
    bgb = fill([0.5,0.6,0.6,0.5],[min_ofylim,min_ofylim,max_ofylim,max_ofylim],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','両脚支持期');
    uistack(bga, 'bottom');
    uistack(bgb, 'bottom');
    name_plot = [comparing_label,' 高さ'];
    plot(Runiform_x, something_mean_resampled, '-k','DisplayName', name_plot, 'LineWidth',2);

    xticks(0.1:0.1:1);
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    title(title_name);
    ylim([min_ofylim, max_ofylim]);
    ylabel(comparing_label);
    legend('Location','best');

    subplot(3,1,[2,3]);
    set(gcf,'defaultLegendAutoUpdate','off');
    hold on;
    bg9 = fill([0,0.6,0.6,0],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],'b','EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','立脚期');hold on;
    bg10 = fill([0.6,1,1,0.6],[y_lim(1),y_lim(1),y_lim(2),y_lim(2)],[1, 0.5, 0],'EdgeColor', 'none','FaceAlpha',0.05,'DisplayName','遊脚期');
    uistack(bg9, 'bottom');
    uistack(bg10, 'bottom');

    if strcmp(paralyzed_side, '右')
        right_label = '右平均 ＊麻痺側';
    else
        right_label = '右平均';
    end
    if strcmp(paralyzed_side, '左')
        left_label = '左平均 ＊麻痺側';
    else
        left_label = '左平均';
    end

    % 平均線のプロット
    
    Rmean_resampled = mean(Rresampled_angles, 2);
    plot(Runiform_x, Rmean_resampled, '-', 'Color',[1, 0.5, 0], 'DisplayName', right_label, 'LineWidth', 2); hold on;
    Lmean_resampled = mean(Lresampled_angles, 2);
    plot(Runiform_x, Lmean_resampled, '-b', 'DisplayName', left_label, 'LineWidth', 2); hold on;
    
    % 軸ラベル、目盛り設定
    xlabel('歩行周期(%)');
    xticks(0.1:0.1:1); 
    xticklabels(arrayfun(@(v) sprintf('%.0f%%', v*100), xticks, 'UniformOutput', false));
    ylabel(angle_label);
    ylim(y_lim);

    % 凡例設定
    legend('Location', 'Best');  
    
    % 方向のテキストと矢印
    text(-0.09, max(ylim)-0.2, direction_max, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.56, 0.66]);
    text(-0.09, min(ylim), direction_min, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
    annotation('arrow', [0.09, 0.09], [0.15, 0.05]);
    
    % 地面接触時のライン
    l_x = line(xlim, [0 0], 'LineStyle', '-', 'Color', [0, 0, 0, 0.3], 'LineWidth', 0.7);
    uistack(l_x, "bottom");
    line([0 0], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.03, max(ylim), '右脚:初期接地', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.1 0.1], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.13, max(ylim), '左脚:反対側離地', 'Rotation', 90,'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.3 0.3], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.33, max(ylim), '右脚:踵離地', 'Rotation', 90,'Color', [1,0.5,0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.5 0.5], ylim, 'LineStyle', '-', 'Color', [0, 0, 1, 0.2], 'LineWidth', 1);
    text(0.53, max(ylim), '両脚支持', 'Rotation', 90, 'Color', 'blue', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.6 0.6], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.63, max(ylim), '右脚:つま先離地', 'Rotation', 90,'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    line([0.85 0.85], ylim, 'LineStyle', '-', 'Color', [1, 0.5, 0, 0.2], 'LineWidth', 1);
    text(0.83, max(ylim), '右脚：下腿垂直', 'Rotation', 90, 'Color', [1, 0.5, 0], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較_', angle_label,'_',comparing_label, 'あり', '.jpeg']));
    close(gcf);
end


function traject(export_filename, indiv_figdir,angle_x, angle_z, joint_name, x_lim, y_lim, CoM_x_5m, CoM_z_5m_mean, contact_frame, contact_end_frame)
    figure('Visible','off');
    for i = 1:length(contact_frame)-1
        % 関節位置と重心位置のデータ取得
        z_trajectory_stance = angle_z(contact_frame(i):contact_end_frame(i));
        x_trajectory_stance = angle_x(contact_frame(i):contact_end_frame(i));
        z_trajectory_swing = angle_z(contact_end_frame(i):contact_frame(i+1));
        x_trajectory_swing = angle_x(contact_end_frame(i):contact_frame(i+1));
        
        CoM_x_div_stance = CoM_x_5m(contact_frame(i):contact_end_frame(i));
        CoM_x_div_swing = CoM_x_5m(contact_end_frame(i):contact_frame(i+1));
        if i==1
            plot(x_trajectory_stance(1)-CoM_x_div_stance(1)-3, z_trajectory_stance(1),'Marker','o','DisplayName','Initial Position'); hold on;
            plot(0, CoM_z_5m_mean, 'k.','MarkerSize', 20,'DisplayName','CoM'); hold on;
        end
        x_trajectory_stance_adj = x_trajectory_stance - CoM_x_div_stance;
        plot(x_trajectory_stance_adj, z_trajectory_stance, 'Color', [1,0.5,0],'DisplayName','Stance Phase'); hold on;
        x_trajectory_swing_adj = x_trajectory_swing - CoM_x_div_swing;
        plot(x_trajectory_swing_adj, z_trajectory_swing, 'Color', [0,0,1], 'DisplayName','Swing Phase');hold on;
        legend;
        % ラベル設定
        xlim(x_lim);
        ylim(y_lim);
        xlabel("The Position of "+joint_name+"relative to CoM (AP)");
        ylabel('Hight from the Ground [m]');
    end
    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['軌跡_', joint_name, '.jpeg']));
    close(gcf);
end    
function compared_traject(export_filename, indiv_figdir,Rangle_x, Rangle_z, Langle_x, Langle_z, joint_name, x_lim, y_lim, CoM_x_5m, CoM_z_5m_mean, Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame)
    % 定義: 補間後の統一データ点数
    unified_length = 100;
    x_R_stance_interp = [];
    z_R_stance_interp = [];
    x_L_stance_interp = [];
    z_L_stance_interp = [];
    
    figure('Visible','off');
    hold on;
    
    % 右脚立脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_stance = Rangle_z(Rcontact_frame(i):Rcontact_end_frame(i));
        x_Rtrajectory_stance = Rangle_x(Rcontact_frame(i):Rcontact_end_frame(i));
        RCoM_x_div_stance = CoM_x_5m(Rcontact_frame(i):Rcontact_end_frame(i));
        
        % 軌道補正
        x_Rtrajectory_stance_adj = x_Rtrajectory_stance - RCoM_x_div_stance;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_stance_adj), unified_length);
        x_R_stance_interp(:, i) = interp1(1:length(x_Rtrajectory_stance_adj), x_Rtrajectory_stance_adj, lin_space, 'linear');
        z_R_stance_interp(:, i) = interp1(1:length(z_Rtrajectory_stance), z_Rtrajectory_stance, lin_space, 'linear');
    end
    % 右脚遊脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_swing = Rangle_z(Rcontact_end_frame(i):Rcontact_frame(i+1));
        x_Rtrajectory_swing = Rangle_x(Rcontact_end_frame(i):Rcontact_frame(i+1));
        RCoM_x_div_swing = CoM_x_5m(Rcontact_end_frame(i):Rcontact_frame(i+1));
        
        % 軌道補正
        x_Rtrajectory_swing_adj = x_Rtrajectory_swing - RCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_swing_adj), unified_length);
        x_R_swing_interp(:, i) = interp1(1:length(x_Rtrajectory_swing_adj), x_Rtrajectory_swing_adj, lin_space, 'linear');
        z_R_swing_interp(:, i) = interp1(1:length(z_Rtrajectory_swing), z_Rtrajectory_swing, lin_space, 'linear');
    end
    
    % 左脚の軌道を処理
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_stance = Langle_z(Lcontact_frame(i):Lcontact_end_frame(i));
        x_Ltrajectory_stance = Langle_x(Lcontact_frame(i):Lcontact_end_frame(i));
        LCoM_x_div_stance = CoM_x_5m(Lcontact_frame(i):Lcontact_end_frame(i));
        
        % 軌道補正
        x_Ltrajectory_stance_adj = x_Ltrajectory_stance - LCoM_x_div_stance;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_stance_adj), unified_length);
        x_L_stance_interp(:, i) = interp1(1:length(x_Ltrajectory_stance_adj), x_Ltrajectory_stance_adj, lin_space, 'linear');
        z_L_stance_interp(:, i) = interp1(1:length(z_Ltrajectory_stance), z_Ltrajectory_stance, lin_space, 'linear');
    end
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_swing = Langle_z(Lcontact_end_frame(i):Lcontact_frame(i+1));
        x_Ltrajectory_swing = Langle_x(Lcontact_end_frame(i):Lcontact_frame(i+1));
        LCoM_x_div_swing = CoM_x_5m(Lcontact_end_frame(i):Lcontact_frame(i+1));
        
        % 軌道補正
        x_Ltrajectory_swing_adj = x_Ltrajectory_swing - LCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_swing_adj), unified_length);
        x_L_swing_interp(:, i) = interp1(1:length(x_Ltrajectory_swing_adj), x_Ltrajectory_swing_adj, lin_space, 'linear');
        z_L_swing_interp(:, i) = interp1(1:length(z_Ltrajectory_swing), z_Ltrajectory_swing, lin_space, 'linear');
    end

    % 平均軌道を計算
    mean_x_Rstance = mean(x_R_stance_interp, 2, 'omitnan');
    mean_z_Rstance = mean(z_R_stance_interp, 2, 'omitnan');
    mean_x_Rswing = mean(x_R_swing_interp, 2, 'omitnan');
    mean_z_Rswing = mean(z_R_swing_interp, 2, 'omitnan');
    mean_x_Lstance = mean(x_L_stance_interp, 2, 'omitnan');
    mean_z_Lstance = mean(z_L_stance_interp, 2, 'omitnan');
    mean_x_Lswing = mean(x_L_swing_interp, 2, 'omitnan');
    mean_z_Lswing = mean(z_L_swing_interp, 2, 'omitnan');

    % 軌道のプロット
    plot(mean_x_Rstance, mean_z_Rstance, '-','Color', [1,0,0], 'Marker', 'x','MarkerIndices', 1:20:100,'MarkerSize',8,'LineWidth', 1, 'DisplayName', 'Right Foot: Stance Phase　Trajectory Ave');hold on;
    plot(mean_x_Rswing, mean_z_Rswing, '-','Color', [1,0.5,0], 'Marker', 'x','MarkerIndices', 1:20:100,'MarkerSize',8,'LineWidth', 1, 'DisplayName', 'Right Foot: Swing Phase　Trajectory Ave');hold on;
    plot(mean_x_Lstance, mean_z_Lstance, '-', 'Color', [0,0,1], 'Marker', '^','MarkerIndices', 1:20:100,'MarkerSize',3, 'LineWidth', 1, 'DisplayName', 'Left Foot: Stance Phase　Trajectory Ave');hold on;
    plot(mean_x_Lswing, mean_z_Lswing, '-', 'Color', [0,0.5,1], 'Marker', '^','MarkerIndices', 1:20:100,'MarkerSize',3,'LineWidth', 1, 'DisplayName', 'Left Foot: Swing Phase　Trajectory Ave');hold on;

    % 重心位置をプロット
    plot(0, CoM_z_5m_mean, 'k.', 'MarkerSize', 20, 'DisplayName', 'CoM');
    
    % グラフ設定
    legend;
    xlim(x_lim);
    ylim(y_lim);
    xlabel("The Position of " + joint_name + "relative to the CoM (AP) [m]");
    ylabel('Height from the Ground [m]');
    title("Comparison of both legs - " + joint_name);

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較_', joint_name, '.jpeg']));
    close(gcf);
end
    function compared_traject_onlyswing(export_filename, indiv_figdir,Rangle_x, Rangle_z, Langle_x, Langle_z, joint_name, x_lim, y_lim, CoM_x_5m, CoM_z_5m_mean, Rcontact_frame, Rcontact_end_frame, Lcontact_frame, Lcontact_end_frame)
    % 定義: 補間後の統一データ点数
    unified_length = 100;
    x_R_swing_interp = [];
    z_R_swing_interp = [];
    x_L_swing_interp = [];
    z_L_swing_interp = [];
    
    figure('Visible','off');
    hold on;
    % 右脚遊脚期の軌道を処理
    for i = 1:length(Rcontact_frame)-1
        z_Rtrajectory_swing = Rangle_z(Rcontact_end_frame(i):Rcontact_frame(i+1));
        x_Rtrajectory_swing = Rangle_x(Rcontact_end_frame(i):Rcontact_frame(i+1));
        RCoM_x_div_swing = CoM_x_5m(Rcontact_end_frame(i):Rcontact_frame(i+1));
        
        % 軌道補正
        x_Rtrajectory_swing_adj = x_Rtrajectory_swing - RCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Rtrajectory_swing_adj), unified_length);
        x_R_swing_interp(:, i) = interp1(1:length(x_Rtrajectory_swing_adj), x_Rtrajectory_swing_adj, lin_space, 'linear');
        z_R_swing_interp(:, i) = interp1(1:length(z_Rtrajectory_swing), z_Rtrajectory_swing, lin_space, 'linear');
    end
    
    for i = 1:length(Lcontact_frame)-1
        z_Ltrajectory_swing = Langle_z(Lcontact_end_frame(i):Lcontact_frame(i+1));
        x_Ltrajectory_swing = Langle_x(Lcontact_end_frame(i):Lcontact_frame(i+1));
        LCoM_x_div_swing = CoM_x_5m(Lcontact_end_frame(i):Lcontact_frame(i+1));
        
        % 軌道補正
        x_Ltrajectory_swing_adj = x_Ltrajectory_swing - LCoM_x_div_swing;
        
        % 線形補間
        lin_space = linspace(1, length(x_Ltrajectory_swing_adj), unified_length);
        x_L_swing_interp(:, i) = interp1(1:length(x_Ltrajectory_swing_adj), x_Ltrajectory_swing_adj, lin_space, 'linear');
        z_L_swing_interp(:, i) = interp1(1:length(z_Ltrajectory_swing), z_Ltrajectory_swing, lin_space, 'linear');
    end

    % 平均軌道を計算
    mean_x_Rswing = mean(x_R_swing_interp, 2, 'omitnan');
    mean_z_Rswing = mean(z_R_swing_interp, 2, 'omitnan');
    mean_x_Lswing = mean(x_L_swing_interp, 2, 'omitnan');
    mean_z_Lswing = mean(z_L_swing_interp, 2, 'omitnan');

    % 軌道のプロット
    plot(mean_x_Rswing, mean_z_Rswing, '-','Color', [1,0.5,0], 'LineWidth', 1, 'DisplayName', 'Right Foot: Swing Phase　Trajectory Ave');hold on;
    plot(mean_x_Lswing, mean_z_Lswing, '-', 'Color', [0,0.5,1], 'LineWidth', 1, 'DisplayName', 'Left Foot: Swing Phase　Trajectory Ave');hold on;

    % 重心位置をプロット
    plot(0, CoM_z_5m_mean, 'k.', 'MarkerSize', 20, 'DisplayName', 'CoM');
    
    % グラフ設定
    legend;
    xlim(x_lim);
    ylim(y_lim);
    xlabel("The Position of " + joint_name + "relative to CoM (AP) [m]");
    ylabel('Height from the Ground [m]');
    title("Comparison of both legs - " + joint_name);

    exportgraphics(gcf, export_filename, 'Append', true);
    saveas(gcf, fullfile(indiv_figdir, ['左右比較(立脚期なし)_', joint_name, '.jpeg']));
    close(gcf);
end


compare_joint_angle(export_filename, indiv_figdir,Rknee_angle,Lknee_angle, '膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side);
compare_joint_angle(export_filename, indiv_figdir,Rankle_angle,Lankle_angle, '足関節角度 [°]', [-45,30],'Dorsiflexion','Plantarflexion', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side);
compare_joint_angle(export_filename, indiv_figdir,Rhip_extension,Lhip_extension, '股関節伸展角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side);
compare_joint_angle(export_filename, indiv_figdir,Rhip_abduction,Lhip_abduction, '股関節外転角度 [°]', [-12,12],'Abduction','Adduction', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side);
compare_joint_angle(export_filename, indiv_figdir,Rhip_rotation,Lhip_rotation, '股関節内旋角度 [°] ', [-15,15],'Internal Rotation','External Rotation', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side);

compare_joint_angle_withsigma(export_filename, indiv_figdir,Rknee_angle,Lknee_angle, '膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side,nondisabled_data);
compare_joint_angle_withsigma(export_filename, indiv_figdir,Rankle_angle,Lankle_angle, '足関節角度 [°]', [-45,30],'Dorsiflexion','Plantarflexion', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side,nondisabled_data);
compare_joint_angle_withsigma(export_filename, indiv_figdir,Rhip_extension,Lhip_extension, '股関節伸展角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side,nondisabled_data);
compare_joint_angle_withsigma(export_filename, indiv_figdir,Rhip_abduction,Lhip_abduction, '股関節外転角度 [°]', [-12,12],'Abduction','Adduction', valid_Rcontact_frame,valid_Lcontact_frame,paralyzed_side,nondisabled_data);

compare_joint_angle_addsomething(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, CoM_z_5m,'両方','膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,'重心位置',paralyzed_side);
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, CoM_z_5m,'両方','股関節角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,'重心位置',paralyzed_side);
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Rthigh_z_5,'右','膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,'右大腿',paralyzed_side);
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Rthigh_z_5,'右','股関節角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,'右大腿',paralyzed_side);
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Lthigh_z_5,'左','膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,'左大腿',paralyzed_side);
compare_joint_angle_addsomething(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Lthigh_z_5,'左','股関節角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,valid_Lcontact_frame,'左大腿',paralyzed_side);

compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, CoM_z_5m,'膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,'重心位置',paralyzed_side);
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, CoM_z_5m,'股関節角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,'重心位置',paralyzed_side);
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Rthigh_z_5,'膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,'右大腿',paralyzed_side);
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Rthigh_z_5,'股関節角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,'右大腿',paralyzed_side);
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rknee_angle, Lknee_angle, Lthigh_z_5,'膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame,'左大腿',paralyzed_side);
compare_joint_angle_addsomething_Rfootcontact(export_filename, indiv_figdir, Rhip_extension, Lhip_extension, Lthigh_z_5,'股関節角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame,'左大腿',paralyzed_side);

next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'右', Rknee_angle, '膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'左', Lknee_angle, '膝関節角度 [°]', [-10,70],'Flextion','Extension', valid_Lcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'右', Rankle_angle, '足関節角度 [°]', [-45,30],'Dorsiflexion','Plantarflexion', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'左', Lankle_angle, '足関節角度 [°]', [-45,30],'Dorsiflexion','Plantarflexion', valid_Lcontact_frame, next_column);

next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'右', Rhip_extension, '股関節伸展角度 [°]', [-15,45],'Flextion','Extension', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'左', Lhip_extension, '股関節伸展角度 [°]', [-15,45],'Flextion','Extension', valid_Lcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'右', Rhip_rotation, '股関節内旋角度 [°]', [-15,15],'Internal Rotation','External Rotation', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'左', Lhip_rotation, '股関節内旋角度 [°]', [-15,15],'Internal Rotation','External Rotation', valid_Lcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'右', Rhip_abduction, '股関節外転角度 [°]', [-12,12],'Abduction','Adduction', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'左', Lhip_abduction, '股関節外転角度 [°]', [-12,12],'Abduction','Adduction', valid_Lcontact_frame, next_column);
% Rplot_joint_angle_adjcycle(export_filename, indiv_figdir, Rhip_abduction, '股関節外転角度 [°]', [-12,12],'外転方向','内転方向', valid_Rcontact_frame);

next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'右', L5_ay_5, 'L5左右方向の加速度 [m/s^2]', [-6,6],'Right','Left', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'', Lumber_lateralFlex, '腰椎側屈角度 [°]', [-15,15],'Right','Left', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'', Pelvis2Neck_lateralFlex, '体幹側屈角度 [°]', [-15,15],'Right','Left', valid_Rcontact_frame, next_column);
next_column = plot_joint_angle(Modified_input_file, export_filename, indiv_figdir,'', Pelvis2Neck_Flex, '体幹前傾角度 [°]', [-15,15],'Anterior','Posterior', valid_Rcontact_frame, next_column);

%% -- 関節の軌跡導出 -- %%
traject(export_filename, indiv_figdir,Rthigh_x_5, Rthigh_z_5, 'Right Thigh', [-0.2,0.2], [0.8,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame);
traject(export_filename, indiv_figdir,Lthigh_x_5, Lthigh_z_5, 'Left Thigh', [-0.2,0.2], [0.8,1], CoM_x_5m, CoM_z_5m_mean, valid_Lcontact_frame, valid_Lcontact_end_frame);
compared_traject(export_filename, indiv_figdir,Rthigh_x_5, Rthigh_z_5, Lthigh_x_5, Lthigh_z_5, 'Comparison of trajectory of Thigh', [-0.2,0.2], [0.8,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame);
traject(export_filename, indiv_figdir,Rtoe_x_5, Rtoe_z_5, 'Right Toe', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame);
traject(export_filename, indiv_figdir,Ltoe_x_5, Ltoe_z_5, 'Left Toe', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Lcontact_frame, valid_Lcontact_end_frame);
compared_traject(export_filename, indiv_figdir,Rtoe_x_5, Rtoe_z_5, Ltoe_x_5, Ltoe_z_5, 'Comparison of trajectory of Toe', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame);
compared_traject_onlyswing(export_filename, indiv_figdir,Rtoe_x_5, Rtoe_z_5, Ltoe_x_5, Ltoe_z_5, 'Comparison of trajectory of Toe', [-0.5,0.5], [0,1], CoM_x_5m, CoM_z_5m_mean, valid_Rcontact_frame, valid_Rcontact_end_frame, valid_Lcontact_frame, valid_Lcontact_end_frame);

disp('図の出力が完了しました')

end