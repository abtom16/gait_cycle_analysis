function [all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing] = ...
    getFootContactFootoffTiming(all_unaffected_footoff_timing, all_unaffected_contact_timing, all_affected_footoff_timing, ...
    current_contact_frame, next_contact_frame, ...
    current_unaffected_footoff, current_unaffected_contact, current_contact_end)

%{
    概要：
    　・各歩行周期ごとの健側の足部接地のフレームと、足部離地のフレーム、麻痺側足部離地のフレームを判定
      ・それぞれの歩行周期に対するタイミングを算出
%}

frame_in_current_unaffected_footoff = current_contact_frame <= current_unaffected_footoff & current_unaffected_footoff < next_contact_frame;
if any(frame_in_current_unaffected_footoff)
    unaffected_footoff = current_unaffected_footoff(frame_in_current_unaffected_footoff);
    unaffected_footoff = unaffected_footoff(1);
    unaffected_footoff_timing = (unaffected_footoff - current_contact_frame) / ...
        (next_contact_frame - current_contact_frame);
    all_unaffected_footoff_timing = [all_unaffected_footoff_timing, unaffected_footoff_timing];
else
    all_unaffected_footoff_timing = [all_unaffected_footoff_timing, NaN];
end

frame_in_current_unaffected_contact = current_contact_frame <= current_unaffected_contact & current_unaffected_contact < next_contact_frame;
if any(frame_in_current_unaffected_contact)
    unaffected_contact = current_unaffected_contact(frame_in_current_unaffected_contact);
    unaffected_contact = unaffected_contact(1);
    unaffected_contact_timing = (unaffected_contact - current_contact_frame) / ...
        (next_contact_frame - current_contact_frame);
    all_unaffected_contact_timing = [all_unaffected_contact_timing, unaffected_contact_timing];
else
    all_unaffected_contact_timing = [all_unaffected_contact_timing, NaN];
end

frame_in_current_affected_footoff = current_contact_frame <= current_contact_end & current_contact_end < next_contact_frame;
if any(frame_in_current_affected_footoff)
    affected_footoff = current_contact_end(frame_in_current_affected_footoff);
    affected_footoff = affected_footoff(1);
    affected_footoff_timing = (affected_footoff - current_contact_frame) / ...
        (next_contact_frame - current_contact_frame);
    all_affected_footoff_timing = [all_affected_footoff_timing, affected_footoff_timing];
else
    all_affected_footoff_timing = [all_affected_footoff_timing, NaN];
end

end