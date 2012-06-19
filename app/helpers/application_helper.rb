module ApplicationHelper
  # Prints out '6 hours ago, Yesterday, 2 weeks ago, 5 months ago, 1 year ago'
  def recent_activity(past_time)
    return '' unless past_time.kind_of?(Time)
    time_ago_in_words(past_time)
    seconds_ago = (Time.now - past_time)
    color = if seconds_ago < 60.minute then "#6DD1EC"
            elsif seconds_ago < 1.day then "#ADDD1E"
            elsif seconds_ago < 2.day then "#CEDC34"
            elsif seconds_ago < 1.week then "#CEDC34"
            elsif seconds_ago < 1.month then "#DCAA24"
            elsif seconds_ago < 1.year then "#C2692A"
            else "#AA2D2F"
            end
    "<span style='color:#{color};font-weight:bold;font-variant:small-caps;'>#{time_ago_in_words(past_time)} ago</span>".html_safe
  end

  def simple_check(checked)
    image_tag("gentleface/16/#{checked ? 'checkbox_checked' : 'checkbox_unchecked'}.png", alt: '', style: 'vertical-align:text-bottom')
  end
end
