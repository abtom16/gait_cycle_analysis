clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-002.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-002.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW2.xlsx";

%  Take Care! Paretic side is Right
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW2.xlsx";

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
paretic_side = 'Right';  % If you want to analyse right foot, change to 'Right'
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\05_CoManalysis\accel\z-axis';
save_filename = 'sub9_CoM_az.png';
clc;
addpath(genpath(fullfile(pwd,'..', '..'))); 
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub1\Modified_sub1_normal2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub3\Modified_sub3_normal2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub4\Modified_sub4_normal2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-001.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub5\Modified_sub5_normal-002.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-001.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250318\sub6\Modified_sub6_normal-002.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub7\Modified_sub7_NW2.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub8\Modified_sub8_NW2.xlsx";

%  Take Care! Paretic side is Right
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20241211\sub2\Modified_sub2_normal2.xlsx";
nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW1.xlsx";
% nw_path = "C:\abe_backup\backup\01_修士\06_Xsens_analysis\01_Xsens_Data\main_expariment\20250514\sub9\Modified_sub9_NW2.xlsx";

%% Configuration for Analysis
% Analyse 'Left' or 'Right' foot
paretic_side = 'Right';  % If you want to analyse right foot, change to 'Right'
NW_MEAN_COLOR = [0 0.7 0.7];
NW_RANGE_COLOR = [0.6 0.9 0.9];
save_folder = 'C:\abe_backup\backup\01_修士\06_Xsens_analysis\05_CoManalysis\accel\z-axis';
save_filename = 'sub9_CoM_az.png';

% for lowpass filter
CUTOFF = 10;
FS = 60;


% データの読み込み
data = GaitData(nw_path, '時系列データ 5m'); 

[valid_Rtd_frame, valid_Roff_frame, valid_Ltd_frame, valid_Loff_frame] = ...
    detectValidFootContacts(data.RFootContact, data.LFootContact);

if strcmpi(paretic_side, 'Right')
    paretic_td_frame = valid_Rtd_frame;
    paretic_off_frame = valid_Roff_frame;
    non_paretic_td_frame = valid_Ltd_frame;
    non_paretic_off_frame = valid_Loff_frame;
elseif strcmpi(paretic_side, 'Left')
    paretic_td_frame = valid_Ltd_frame;
    paretic_off_frame = valid_Loff_frame;
    non_paretic_td_frame = valid_Rtd_frame;
    non_paretic_off_frame = valid_Roff_frame;
end

% ストライドの開始フレームは麻痺足の接地フレーム
stride_start_frames = paretic_td_frame;
num_strides_in_file = length(stride_start_frames) - 1; 

% プロットするストライドの範囲 (例: 最初と最後の不安定なストライドを除外)
plot_start_stride_idx = 1; 
plot_end_stride_idx = num_strides_in_file; 

% --- 各ストライドを個別にプロットするループ (ストライドごと) ---
for s_idx = plot_start_stride_idx : plot_end_stride_idx
    start_frame = stride_start_frames(s_idx);
    end_frame = stride_start_frames(s_idx+1) - 1; % 次の麻痺足TDの直前まで

    % データと時間軸を切り出し (cm/s)
    current_data = data.CoM.az(start_frame : end_frame); 
    current_data = lowpass(current_data, CUTOFF, FS);
    current_stride_time_s = (start_frame : end_frame) / Fs; % 横軸は時間[s]
    % X軸の開始を0秒に正規化
    stride_relative_time_s = current_stride_time_s - current_stride_time_s(1);
    
    % --- 各ストライドごとのグラフ生成 ---
    fig_stride_plot = figure('Visible','off');
    hold on;

    ylim([-5 5]); 
    xlim([0 stride_relative_time_s(end)]); 
    yline(0, '-', 'Color', [0.5 0.5 0.5]); 
    
    % グラフのタイトルとラベル
    title(sprintf('%s - Stride %d: CoM Z-Velocity (Time Domain)', filename, s_idx));
    xlabel('Time (s)');
    ylabel('CoM Velocity - VT- [cm/s]'); 
    grid on;
    ax = gca;
    ax.FontSize = 12;
    y_lim = ylim(gca);

    % --- 相の区間を秒単位で動的に計算し、背景とテキストを描画 ---
    % 注意: ここが最も複雑な部分です。
    % 麻痺足基準のストライド内における、健側足のIC/TO、麻痺足のTOフレームを秒で計算します。
    
    % 現在のストライドの絶対フレーム範囲 (R_IC_frame から Next_R_IC_frame - 1)
    current_stride_abs_start_frame = start_frame;
    current_stride_abs_end_frame = end_frame;

    % 関連するイベントフレームを現在のストライドの範囲内から抽出
    % (注意: イベントフレームはソートされている必要があります)
    current_non_paretic_td_frames_in_stride = non_paretic_td_frame(non_paretic_td_frame >= current_stride_abs_start_frame & non_paretic_td_frame <= current_stride_abs_end_frame);
    current_paretic_off_frames_in_stride = paretic_off_frame(paretic_off_frame >= current_stride_abs_start_frame & paretic_off_frame <= current_stride_abs_end_frame);
    current_non_paretic_off_frames_in_stride = non_paretic_off_frame(non_paretic_off_frame >= current_stride_abs_start_frame & non_paretic_off_frame <= current_stride_abs_end_frame);

    % イベントの相対時間 (秒) を計算 (ストライド開始を0とする)
    % 必ずしもイベントが1つだけあるとは限らないが、通常は最初のものを使う
    non_paretic_IC_rel_s = nan; if ~isempty(current_non_paretic_td_frames_in_stride); non_paretic_IC_rel_s = (current_non_paretic_td_frames_in_stride(1) - current_stride_abs_start_frame) / Fs; end
    paretic_TO_rel_s = nan; if ~isempty(current_paretic_off_frames_in_stride); paretic_TO_rel_s = (current_paretic_off_frames_in_stride(1) - current_stride_abs_start_frame) / Fs; end
    non_paretic_TO_rel_s = nan; if ~isempty(current_non_paretic_off_frames_in_stride); non_paretic_TO_rel_s = (current_non_paretic_off_frames_in_stride(1) - current_stride_abs_start_frame) / Fs; end
    
    % ストライドの総持続時間
    stride_duration_s = stride_relative_time_s(end);

    % === 相の区間を秒単位で定義 ===
    % 定義は、麻痺足基準のストライドで行います (麻痺足が0秒でIC)
    % (Xsensデータにおける一般的な歩行相の定義に合わせます)
    
    % 1. Initial Double Support (IDS - 初期両脚支持相)
    %   麻痺足IC から 健側足IC まで
    ids_start = 0;
    ids_end = non_paretic_IC_rel_s; % 健側ICのタイミング
    
    % 2. Affected Single Support (ASS - 麻痺側単脚支持相)
    %   健側足IC から 麻痺足TO まで
    ass_start = non_paretic_IC_rel_s;
    ass_end = paretic_TO_rel_s; % 麻痺足TOのタイミング
    
    % 3. Terminal Double Support (TDS - 終末両脚支持相)
    %   麻痺足TO から 健側足TO まで (または健側足ICまで)
    %   ここでは、麻痺足TOから次の麻痺足IC (ストライド終了)までの間に健側足が接地している期間
    tds_start = paretic_TO_rel_s;
    
    
    % 健側遊脚相 (Non-Paretic Swing - NPS)
    % NPSの開始は通常、麻痺足のTOから健足のTOまで
    nps_start = non_paretic_TO_rel_s;
    nps_end = stride_duration_s; 
    

    % 健側単脚支持 (NSS - Non-Paretic Single Support)
    nss_start = non_paretic_IC_rel_s;
    nss_end = non_paretic_TO_rel_s;
    
    % === イベントの妥当性チェックと NaN 処理 ===
    % イベントが見つからない場合や順序がおかしい場合は NaN が入るので、
    % fill コマンドがエラーにならないように範囲をチェック
    event_times = sort([0, stride_duration_s, non_paretic_IC_rel_s, paretic_TO_rel_s, non_paretic_TO_rel_s]);
    event_times = event_times(~isnan(event_times) & event_times >= 0 & event_times <= stride_duration_s);
    event_times = unique(event_times); % 重複を削除しソート
    
    % === 背景色の描画 ===
    % 色の定義
    color_ds = [0.8 0.7 1.0]; % 紫系 (Double Support)
    color_paretic_ss = [0.7 0.7 1.0]; % 薄い青 (Affected Single Support)
    color_non_paretic_ss = [1.0 0.8 0.7]; % 薄い橙 (Non-Affected Single Support)
    color_swing = [0.9 0.9 0.9]; % 灰色 (遊脚相 - もし片脚支持と区別するなら)
    
    bg_handles = []; % 背景パッチのハンドルを格納するリスト
    
    % 各区間をループで回して背景を描画
    % 0からstride_duration_sまで細かく区切って、各時点でどの相にあるか判別する方が確実
    
    % 各フレームでどの相にあるか判別し、色分けするより簡単な方法
    % 定義した相の境界を使って fill コマンドを呼び出す
    
    % DS1
    if ~isnan(ids_end) && ids_end > ids_start
        bg_h = fill([ids_start, ids_end, ids_end, ids_start], [y_lim(1), y_lim(1), y_lim(2), y_lim(1)], ...
                      color_ds, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'HandleVisibility', 'off'); 
        bg_handles = [bg_handles, bg_h];
        % テキストラベル
        text(mean([ids_start, ids_end]), y_lim(2), 'DS1', 'FontSize', 10, 'Color', [0.5 0.3 0.8], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
    end
    
    % Affected Single Support (ASS)
    if ~isnan(ass_start) && ~isnan(ass_end) && ass_end > ass_start
        bg_h = fill([ass_start, ass_end, ass_end, ass_start], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      color_paretic_ss, 'EdgeColor', 'none','FaceAlpha', 0.5, 'HandleVisibility', 'off'); 
        bg_handles = [bg_handles, bg_h];
        text(mean([ass_start, ass_end]), y_lim(2), 'ASS', 'FontSize', 10, 'Color', [0 0 0.5], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end
    
    % Non-Paretic Single Support (NSS) - 健側単脚支持
    % これには、NSS_start と NSS_end が必要。これらは厳密に計算されるべき
    % 例えば、左足ICから左足TOまで
    if ~isnan(nss_start) && ~isnan(nss_end) && nss_end > nss_start
         bg_h = fill([nss_start, nss_end, nss_end, nss_start], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], ...
                     color_non_paretic_ss, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'HandleVisibility', 'off');
         bg_handles = [bg_handles, bg_h];
         text(mean([nss_start, nss_end]), y_lim(2), 'NSS', 'FontSize', 10, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end

    % Terminal Double Support (TDS) の定義も複雑
    tds_start_s = paretic_TO_rel_s; % 麻痺足離地
    
    % 次の健側ICを探す (現在のストライドの終わり付近にある場合)
    next_non_paretic_IC_rel_s = nan;
    next_non_paretic_IC_frames = valid_non_paretic_td_frame(valid_non_paretic_td_frame > current_stride_abs_end_frame & valid_non_paretic_td_frame < current_stride_abs_end_frame + Fs*1.0); % 次の1秒以内のIC
    if ~isempty(next_non_paretic_IC_frames)
        next_non_paretic_IC_rel_s = (next_non_paretic_IC_frames(1) - current_stride_abs_start_frame) / Fs;
    end
    
    % DS2 の正確な開始は麻痺側TO (paretic_TO_rel_s)
    % DS2 の正確な終了は健側TO (non_paretic_TO_rel_s) より後の非麻痺側IC?
    % これは非常に複雑なので、通常の4相（DS1, SS_paretic, DS2, SS_non_paretic）に分けるのが一般的

    % --- 各相の定義を正確に追記（Xsensの一般的な出力に基づきます）---
    % 1. Initial Double Support (IDS): 麻痺側IC (0) から健側TO (non_paretic_TO_rel_s) まで
    % 2. Preswing (PSw): 麻痺側TO (paretic_TO_rel_s) から健側TO (non_paretic_TO_rel_s) まで
    % 3. Mid-Stance (MS): 健側IC から 健側TO まで
    
    % 以下の相分けは一般的な健常歩行の左右脚イベントに基づいています。
    % R_IC (0), L_IC, R_TO, L_TO
    %
    % - Initial Double Support (IDS): R_IC to L_IC
    % - Right Single Support (RSS): L_IC to R_TO
    % - Terminal Double Support (TDS): R_TO to L_TO
    % - Left Single Support (LSS): L_TO to R_IC (next stride)

    % これらのイベント時間が正確に計算されている前提で、相分けのロジックを再構築
    
    % === Phase Definition ===
    % 0% - L_IC_rel_s: IDS (Initial Double Support)
    % L_IC_rel_s - R_TO_rel_s: Paretic Single Support (ASS)
    % R_TO_rel_s - L_TO_rel_s: TDS (Terminal Double Support)
    % L_TO_rel_s - stride_duration_s: Non-Paretic Single Support (NSS)
    
    % イベントの存在を確認 (NaNチェック)
    is_ds1 = ~isnan(non_paretic_IC_rel_s); % 左ICがあるなら
    is_ass = ~isnan(non_paretic_IC_rel_s) && ~isnan(paretic_TO_rel_s); % 左ICと右TOがあるなら
    is_tds = ~isnan(paretic_TO_rel_s) && ~isnan(non_paretic_TO_rel_s); % 右TOと左TOがあるなら
    is_nss = ~isnan(non_paretic_TO_rel_s); % 左TOがあるなら

    % 背景色をクリア
    background_handles = [];

    % DS1 (赤系)
    if is_ds1
        ids_start_s = 0;
        ids_end_s = non_paretic_IC_rel_s;
        if ids_end_s > ids_start_s
            bg_h = fill([ids_start_s, ids_end_s, ids_end_s, ids_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                          [1 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
            bg_handles = [bg_handles, bg_h];
            text(mean([ids_start_s, ids_end_s]), y_lim(2), 'DS1', 'FontSize', 10, 'Color', [0.5 0 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
        end
    end
    
    % Affected Single Support (青系)
    if is_ass && paretic_TO_rel_s > non_paretic_IC_rel_s % ASS期間があるなら
        ass_start_s = non_paretic_IC_rel_s;
        ass_end_s = paretic_TO_rel_s;
        bg_h = fill([ass_start_s, ass_end_s, ass_end_s, ass_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      [0.7 0.7 1.0], 'EdgeColor', 'none','FaceAlpha', 0.5, 'HandleVisibility', 'off'); 
        bg_handles = [bg_handles, bg_h];
        text(mean([ass_start_s, ass_end_s]), y_lim(2), 'ASS', 'FontSize', 10, 'Color', [0 0 0.5], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end

    % Terminal Double Support (TDS)
    if is_tds && non_paretic_TO_rel_s > paretic_TO_rel_s % TDS期間があるなら
        tds_start_s = paretic_TO_rel_s;
        tds_end_s = non_paretic_TO_rel_s;
        bg_h = fill([tds_start_s, tds_end_s, tds_end_s, tds_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      [1 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'HandleVisibility', 'off'); % DSと同じ色
        bg_handles = [bg_handles, bg_h];
        text(mean([tds_start_s, tds_end_s]), y_lim(2), 'TDS', 'FontSize', 10, 'Color', [0.5 0 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
    end
    
    % Non-Paretic Single Support (NSS) - 健側単脚支持
    if is_nss && stride_duration_s > non_paretic_TO_rel_s % NSS期間があるなら
        nss_start_s = non_paretic_TO_rel_s;
        nss_end_s = stride_duration_s;
        bg_h = fill([nss_start_s, nss_end_s, nss_end_s, nss_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      [1.0 0.8 0.7], 'EdgeColor', 'none', 'FaceAlpha', 0.5,'HandleVisibility', 'off'); % 薄い橙
        bg_handles = [bg_handles, bg_h];
        text(mean([nss_start_s, nss_end_s]), y_lim(2), 'NSS', 'FontSize', 10, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end
    
    % 全ての背景をグラフの底面に送る
    if ~isempty(bg_handles)
        uistack(bg_handles, 'bottom');
    end
    
    % --- データプロット (ここがメインの波形プロット) ---
    plot(stride_relative_time_s, current_data, 'Color', [0 0.7 0.7], 'LineWidth', 1.5, 'LineStyle', '-'); 

    % --- 各ストライドごとの保存 ---
    % save_filepath_vel_z_stride_plot = fullfile(save_base_folder, sprintf('%s_CoM_Z_Vel_Stride%d_Time.png', filename, s_idx));
    % saveas(fig_stride_plot, save_filepath_vel_z_stride_plot);
    % close(fig_stride_plot);
end

% for lowpass filter
CUTOFF = 10;
FS = 60;


% データの読み込み
data = GaitData(nw_path, '時系列データ 5m'); 

[valid_Rtd_frame, valid_Roff_frame, valid_Ltd_frame, valid_Loff_frame] = ...
    detectValidFootContacts(data.RFootContact, data.LFootContact);

if strcmpi(paretic_side, 'Right')
    paretic_td_frame = valid_Rtd_frame;
    paretic_off_frame = valid_Roff_frame;
    non_paretic_td_frame = valid_Ltd_frame;
    non_paretic_off_frame = valid_Loff_frame;
elseif strcmpi(paretic_side, 'Left')
    paretic_td_frame = valid_Ltd_frame;
    paretic_off_frame = valid_Loff_frame;
    non_paretic_td_frame = valid_Rtd_frame;
    non_paretic_off_frame = valid_Roff_frame;
end

% ストライドの開始フレームは麻痺足の接地フレーム
stride_start_frames = paretic_td_frame;
num_strides_in_file = length(stride_start_frames) - 1; 

% プロットするストライドの範囲 (例: 最初と最後の不安定なストライドを除外)
plot_start_stride_idx = 1; 
plot_end_stride_idx = num_strides_in_file; 

% --- 各ストライドを個別にプロットするループ (ストライドごと) ---
for s_idx = plot_start_stride_idx : plot_end_stride_idx
    start_frame = stride_start_frames(s_idx);
    end_frame = stride_start_frames(s_idx+1) - 1; % 次の麻痺足TDの直前まで

    % データと時間軸を切り出し (cm/s)
    current_data = data.CoM.az(start_frame : end_frame); 
    current_data = lowpass(current_data, CUTOFF, FS);
    current_stride_time_s = (start_frame : end_frame) / Fs; % 横軸は時間[s]
    % X軸の開始を0秒に正規化
    stride_relative_time_s = current_stride_time_s - current_stride_time_s(1);
    
    % --- 各ストライドごとのグラフ生成 ---
    fig_stride_plot = figure('Visible','off');
    hold on;

    ylim([-5 5]); 
    xlim([0 stride_relative_time_s(end)]); 
    yline(0, '-', 'Color', [0.5 0.5 0.5]); 
    
    % グラフのタイトルとラベル
    title(sprintf('%s - Stride %d: CoM Z-Velocity (Time Domain)', filename, s_idx));
    xlabel('Time (s)');
    ylabel('CoM Velocity - VT- [cm/s]'); 
    grid on;
    ax = gca;
    ax.FontSize = 12;
    y_lim = ylim(gca);

    % --- 相の区間を秒単位で動的に計算し、背景とテキストを描画 ---
    % 注意: ここが最も複雑な部分です。
    % 麻痺足基準のストライド内における、健側足のIC/TO、麻痺足のTOフレームを秒で計算します。
    
    % 現在のストライドの絶対フレーム範囲 (R_IC_frame から Next_R_IC_frame - 1)
    current_stride_abs_start_frame = start_frame;
    current_stride_abs_end_frame = end_frame;

    % 関連するイベントフレームを現在のストライドの範囲内から抽出
    % (注意: イベントフレームはソートされている必要があります)
    current_non_paretic_td_frames_in_stride = non_paretic_td_frame(non_paretic_td_frame >= current_stride_abs_start_frame & non_paretic_td_frame <= current_stride_abs_end_frame);
    current_paretic_off_frames_in_stride = paretic_off_frame(paretic_off_frame >= current_stride_abs_start_frame & paretic_off_frame <= current_stride_abs_end_frame);
    current_non_paretic_off_frames_in_stride = non_paretic_off_frame(non_paretic_off_frame >= current_stride_abs_start_frame & non_paretic_off_frame <= current_stride_abs_end_frame);

    % イベントの相対時間 (秒) を計算 (ストライド開始を0とする)
    % 必ずしもイベントが1つだけあるとは限らないが、通常は最初のものを使う
    non_paretic_IC_rel_s = nan; if ~isempty(current_non_paretic_td_frames_in_stride); non_paretic_IC_rel_s = (current_non_paretic_td_frames_in_stride(1) - current_stride_abs_start_frame) / Fs; end
    paretic_TO_rel_s = nan; if ~isempty(current_paretic_off_frames_in_stride); paretic_TO_rel_s = (current_paretic_off_frames_in_stride(1) - current_stride_abs_start_frame) / Fs; end
    non_paretic_TO_rel_s = nan; if ~isempty(current_non_paretic_off_frames_in_stride); non_paretic_TO_rel_s = (current_non_paretic_off_frames_in_stride(1) - current_stride_abs_start_frame) / Fs; end
    
    % ストライドの総持続時間
    stride_duration_s = stride_relative_time_s(end);

    % === 相の区間を秒単位で定義 ===
    % 定義は、麻痺足基準のストライドで行います (麻痺足が0秒でIC)
    % (Xsensデータにおける一般的な歩行相の定義に合わせます)
    
    % 1. Initial Double Support (IDS - 初期両脚支持相)
    %   麻痺足IC から 健側足IC まで
    ids_start = 0;
    ids_end = non_paretic_IC_rel_s; % 健側ICのタイミング
    
    % 2. Affected Single Support (ASS - 麻痺側単脚支持相)
    %   健側足IC から 麻痺足TO まで
    ass_start = non_paretic_IC_rel_s;
    ass_end = paretic_TO_rel_s; % 麻痺足TOのタイミング
    
    % 3. Terminal Double Support (TDS - 終末両脚支持相)
    %   麻痺足TO から 健側足TO まで (または健側足ICまで)
    %   ここでは、麻痺足TOから次の麻痺足IC (ストライド終了)までの間に健側足が接地している期間
    tds_start = paretic_TO_rel_s;
    
    
    % 健側遊脚相 (Non-Paretic Swing - NPS)
    % NPSの開始は通常、麻痺足のTOから健足のTOまで
    nps_start = non_paretic_TO_rel_s;
    nps_end = stride_duration_s; 
    

    % 健側単脚支持 (NSS - Non-Paretic Single Support)
    nss_start = non_paretic_IC_rel_s;
    nss_end = non_paretic_TO_rel_s;
    
    % === イベントの妥当性チェックと NaN 処理 ===
    % イベントが見つからない場合や順序がおかしい場合は NaN が入るので、
    % fill コマンドがエラーにならないように範囲をチェック
    event_times = sort([0, stride_duration_s, non_paretic_IC_rel_s, paretic_TO_rel_s, non_paretic_TO_rel_s]);
    event_times = event_times(~isnan(event_times) & event_times >= 0 & event_times <= stride_duration_s);
    event_times = unique(event_times); % 重複を削除しソート
    
    % === 背景色の描画 ===
    % 色の定義
    color_ds = [0.8 0.7 1.0]; % 紫系 (Double Support)
    color_paretic_ss = [0.7 0.7 1.0]; % 薄い青 (Affected Single Support)
    color_non_paretic_ss = [1.0 0.8 0.7]; % 薄い橙 (Non-Affected Single Support)
    color_swing = [0.9 0.9 0.9]; % 灰色 (遊脚相 - もし片脚支持と区別するなら)
    
    bg_handles = []; % 背景パッチのハンドルを格納するリスト
    
    % 各区間をループで回して背景を描画
    % 0からstride_duration_sまで細かく区切って、各時点でどの相にあるか判別する方が確実
    
    % 各フレームでどの相にあるか判別し、色分けするより簡単な方法
    % 定義した相の境界を使って fill コマンドを呼び出す
    
    % DS1
    if ~isnan(ids_end) && ids_end > ids_start
        bg_h = fill([ids_start, ids_end, ids_end, ids_start], [y_lim(1), y_lim(1), y_lim(2), y_lim(1)], ...
                      color_ds, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'HandleVisibility', 'off'); 
        bg_handles = [bg_handles, bg_h];
        % テキストラベル
        text(mean([ids_start, ids_end]), y_lim(2), 'DS1', 'FontSize', 10, 'Color', [0.5 0.3 0.8], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
    end
    
    % Affected Single Support (ASS)
    if ~isnan(ass_start) && ~isnan(ass_end) && ass_end > ass_start
        bg_h = fill([ass_start, ass_end, ass_end, ass_start], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      color_paretic_ss, 'EdgeColor', 'none','FaceAlpha', 0.5, 'HandleVisibility', 'off'); 
        bg_handles = [bg_handles, bg_h];
        text(mean([ass_start, ass_end]), y_lim(2), 'ASS', 'FontSize', 10, 'Color', [0 0 0.5], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end
    
    % Non-Paretic Single Support (NSS) - 健側単脚支持
    % これには、NSS_start と NSS_end が必要。これらは厳密に計算されるべき
    % 例えば、左足ICから左足TOまで
    if ~isnan(nss_start) && ~isnan(nss_end) && nss_end > nss_start
         bg_h = fill([nss_start, nss_end, nss_end, nss_start], [y_lim(1),y_lim(1),y_lim(2),y_lim(2)], ...
                     color_non_paretic_ss, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'HandleVisibility', 'off');
         bg_handles = [bg_handles, bg_h];
         text(mean([nss_start, nss_end]), y_lim(2), 'NSS', 'FontSize', 10, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end

    % Terminal Double Support (TDS) の定義も複雑
    tds_start_s = paretic_TO_rel_s; % 麻痺足離地
    
    % 次の健側ICを探す (現在のストライドの終わり付近にある場合)
    next_non_paretic_IC_rel_s = nan;
    next_non_paretic_IC_frames = valid_non_paretic_td_frame(valid_non_paretic_td_frame > current_stride_abs_end_frame & valid_non_paretic_td_frame < current_stride_abs_end_frame + Fs*1.0); % 次の1秒以内のIC
    if ~isempty(next_non_paretic_IC_frames)
        next_non_paretic_IC_rel_s = (next_non_paretic_IC_frames(1) - current_stride_abs_start_frame) / Fs;
    end
    
    % DS2 の正確な開始は麻痺側TO (paretic_TO_rel_s)
    % DS2 の正確な終了は健側TO (non_paretic_TO_rel_s) より後の非麻痺側IC?
    % これは非常に複雑なので、通常の4相（DS1, SS_paretic, DS2, SS_non_paretic）に分けるのが一般的

    % --- 各相の定義を正確に追記（Xsensの一般的な出力に基づきます）---
    % 1. Initial Double Support (IDS): 麻痺側IC (0) から健側TO (non_paretic_TO_rel_s) まで
    % 2. Preswing (PSw): 麻痺側TO (paretic_TO_rel_s) から健側TO (non_paretic_TO_rel_s) まで
    % 3. Mid-Stance (MS): 健側IC から 健側TO まで
    
    % 以下の相分けは一般的な健常歩行の左右脚イベントに基づいています。
    % R_IC (0), L_IC, R_TO, L_TO
    %
    % - Initial Double Support (IDS): R_IC to L_IC
    % - Right Single Support (RSS): L_IC to R_TO
    % - Terminal Double Support (TDS): R_TO to L_TO
    % - Left Single Support (LSS): L_TO to R_IC (next stride)

    % これらのイベント時間が正確に計算されている前提で、相分けのロジックを再構築
    
    % === Phase Definition ===
    % 0% - L_IC_rel_s: IDS (Initial Double Support)
    % L_IC_rel_s - R_TO_rel_s: Paretic Single Support (ASS)
    % R_TO_rel_s - L_TO_rel_s: TDS (Terminal Double Support)
    % L_TO_rel_s - stride_duration_s: Non-Paretic Single Support (NSS)
    
    % イベントの存在を確認 (NaNチェック)
    is_ds1 = ~isnan(non_paretic_IC_rel_s); % 左ICがあるなら
    is_ass = ~isnan(non_paretic_IC_rel_s) && ~isnan(paretic_TO_rel_s); % 左ICと右TOがあるなら
    is_tds = ~isnan(paretic_TO_rel_s) && ~isnan(non_paretic_TO_rel_s); % 右TOと左TOがあるなら
    is_nss = ~isnan(non_paretic_TO_rel_s); % 左TOがあるなら

    % 背景色をクリア
    background_handles = [];

    % DS1 (赤系)
    if is_ds1
        ids_start_s = 0;
        ids_end_s = non_paretic_IC_rel_s;
        if ids_end_s > ids_start_s
            bg_h = fill([ids_start_s, ids_end_s, ids_end_s, ids_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                          [1 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
            bg_handles = [bg_handles, bg_h];
            text(mean([ids_start_s, ids_end_s]), y_lim(2), 'DS1', 'FontSize', 10, 'Color', [0.5 0 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
        end
    end
    
    % Affected Single Support (青系)
    if is_ass && paretic_TO_rel_s > non_paretic_IC_rel_s % ASS期間があるなら
        ass_start_s = non_paretic_IC_rel_s;
        ass_end_s = paretic_TO_rel_s;
        bg_h = fill([ass_start_s, ass_end_s, ass_end_s, ass_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      [0.7 0.7 1.0], 'EdgeColor', 'none','FaceAlpha', 0.5, 'HandleVisibility', 'off'); 
        bg_handles = [bg_handles, bg_h];
        text(mean([ass_start_s, ass_end_s]), y_lim(2), 'ASS', 'FontSize', 10, 'Color', [0 0 0.5], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end

    % Terminal Double Support (TDS)
    if is_tds && non_paretic_TO_rel_s > paretic_TO_rel_s % TDS期間があるなら
        tds_start_s = paretic_TO_rel_s;
        tds_end_s = non_paretic_TO_rel_s;
        bg_h = fill([tds_start_s, tds_end_s, tds_end_s, tds_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      [1 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'HandleVisibility', 'off'); % DSと同じ色
        bg_handles = [bg_handles, bg_h];
        text(mean([tds_start_s, tds_end_s]), y_lim(2), 'TDS', 'FontSize', 10, 'Color', [0.5 0 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
    end
    
    % Non-Paretic Single Support (NSS) - 健側単脚支持
    if is_nss && stride_duration_s > non_paretic_TO_rel_s % NSS期間があるなら
        nss_start_s = non_paretic_TO_rel_s;
        nss_end_s = stride_duration_s;
        bg_h = fill([nss_start_s, nss_end_s, nss_end_s, nss_start_s], [y_lim(1), y_lim(1), y_lim(2), y_lim(2)], ...
                      [1.0 0.8 0.7], 'EdgeColor', 'none', 'FaceAlpha', 0.5,'HandleVisibility', 'off'); % 薄い橙
        bg_handles = [bg_handles, bg_h];
        text(mean([nss_start_s, nss_end_s]), y_lim(2), 'NSS', 'FontSize', 10, 'Color', [0.8 0.4 0], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    end
    
    % 全ての背景をグラフの底面に送る
    if ~isempty(bg_handles)
        uistack(bg_handles, 'bottom');
    end
    
    % --- データプロット (ここがメインの波形プロット) ---
    plot(stride_relative_time_s, current_data, 'Color', [0 0.7 0.7], 'LineWidth', 1.5, 'LineStyle', '-'); 

    % --- 各ストライドごとの保存 ---
    % save_filepath_vel_z_stride_plot = fullfile(save_base_folder, sprintf('%s_CoM_Z_Vel_Stride%d_Time.png', filename, s_idx));
    % saveas(fig_stride_plot, save_filepath_vel_z_stride_plot);
    % close(fig_stride_plot);
end
