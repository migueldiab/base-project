module ApplicationHelper

  def yield_flash(flash)
    unless flash.empty?
      html = content_tag :div, class: "row" do
        html = ""
        flash.each do |name, msg|
          html += content_tag :div, class: "col-12" do
            content_tag :div, msg.html_safe, :id => "flash_#{name}", class: "alert alert-block"
          end
          html.html_safe
        end
        html.html_safe
      end
      html.html_safe
    end
  end

end
