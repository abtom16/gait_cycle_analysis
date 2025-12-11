function Phase_Support(mean_unaffected_footoff_timing, mean_unaffected_contact_timing, mean_affected_footoff_timing)
%{
    概要：
        ・健常者のプログラムでは、背景を立脚期と遊脚期の切り替えで表示していたが、これは60%で区切っていた。
        ・片麻痺者では、左右の非対称性から単脚支持の時間や立脚期・遊脚期の時間が変動すると考え、各実験参加者に合わせるためのプログラム
%}

    ax = gca;
    y_lim_current = ax.YLim;
    
    % --- 背景色の描画 ---
    % 両脚支持相1 (DS1: Initial Double Support) 
    bg_ds1 = fill([0, mean_unaffected_footoff_timing, mean_unaffected_footoff_timing, 0], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                  [0.5 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
    
    % 麻痺側片脚支持相 (Affected Single Support) 
    bg_affected_ss = fill([mean_unaffected_footoff_timing, mean_unaffected_contact_timing, mean_unaffected_contact_timing, mean_unaffected_footoff_timing], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                          [0 0 1], 'EdgeColor', 'none','FaceAlpha', 0.05, 'HandleVisibility', 'off');   % 麻痺の時は、麻痺側の色を[0 0 1]
    
    % 両脚支持相2 (DS2: Terminal Double Support)
    bg_ds2 = fill([mean_unaffected_contact_timing, mean_affected_footoff_timing, mean_affected_footoff_timing, mean_unaffected_contact_timing], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                  [0.5 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off'); 
    
    % 健側片脚支持相 (Non-Affected Single Support) 
    bg_non_affected_ss = fill([mean_affected_footoff_timing, 1.0, 1.0, mean_affected_footoff_timing], [y_lim_current(1), y_lim_current(1), y_lim_current(2), y_lim_current(2)], ...
                              [1 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.05,'HandleVisibility', 'off'); 
    
    uistack(bg_ds1, 'bottom');
    uistack(bg_affected_ss, 'bottom');
    uistack(bg_ds2, 'bottom');
    uistack(bg_non_affected_ss, 'bottom');
    
    % --- テキストラベルの描画 ---
    % Y軸のテキスト位置を、グラフの最大値に合わせる
    text_y_top = y_lim_current(2) - (y_lim_current(2)-y_lim_current(1))*0.05;
    
    text_ds1 = text(0.05, text_y_top, 'Double Support', 'FontSize', 12, 'Color', [0.7 0.4 0.4], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90); 
    text_affected_ss = text(mean_unaffected_footoff_timing+0.05, text_y_top, 'Affected Single', 'FontSize', 12, 'Color', [0.9 0.75 0.5], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90);
    text_ds2 = text(mean_unaffected_contact_timing+0.05, text_y_top, 'Double Support', 'FontSize', 12, 'Color', [0.7 0.4 0.4], ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90); 
    text_non_affected_ss = text(mean_affected_footoff_timing+0.05, text_y_top, 'Non-Affected Single', 'FontSize', 12, 'Color', [0.9 0.75 0.5],  ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Rotation', 90);

    uistack(text_ds1, 'bottom');
    uistack(text_affected_ss, 'bottom');
    uistack(text_ds2, 'bottom');
    uistack(text_non_affected_ss, 'bottom');
end