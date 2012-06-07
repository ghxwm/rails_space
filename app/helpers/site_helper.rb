module SiteHelper
  #验证没通过时,生成的错误信息
  def error_message_for(record)
    if record and record.errors.any?
        header = "#{record.errors.count} errors prohibited this user from beging saved."
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
  def nav_link(text,controller="site",action="index")
    link_to_unless_current text,:controller => controller,:action => action
  end
end
