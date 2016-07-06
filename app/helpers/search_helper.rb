module SearchHelper
  def bold_match(s, term, extra_classes = '')
    s.gsub(/#{term}/i) { |sub| "<b class='darker #{extra_classes}'>#{sub}</b>" }.html_safe
  end
end
