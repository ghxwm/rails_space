
module SiteHelper
  #验证没通过时,生成的错误信息
  def error_message_for(record)
    if record and record.errors.any?
        count = record.errors.count
        header = t("errors.template.header.other",{:count => count,:model => t("app."<<params[:controller]) })
        errmsg = ""
        record.errors.full_messages.each do |name,msg|
          errmsg << content_tag(:li,"#{name} #{msg}")
        end
        header = content_tag(:h2,header)
        errmsg = content_tag(:ul,errmsg,nil,false)
        content_tag(:div,header << errmsg,{:id => "error_explanation"},false)
    end
  end
  
  #生成导航栏连接
  def nav_link(text,controller="site",action=nil)
    action =  text.downcase if action == nil
    link_to_unless_current t("app.#{text}"),:controller => controller,:action => action
  end
end
