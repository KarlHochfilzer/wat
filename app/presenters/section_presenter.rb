class SectionPresenter < BasePresenter
  presents :section

  def title
    section.title || translate_link 
  end

  def description
    markdown( section.body || translate_link )
  end

  def page_links
    range = can_read?('Admin', 'Maintainer') ? section.pages : section.pages.online
    rc = "<ul class='nav nav-pills'>"
      range.only(:title).each do |page|
        rc += "<li>" + link_to(page.title,page) + "</li>"
      end
    rc += "</ul>"
    rc.html_safe
  end

private
  def translate_link
    link_to( t(:please_translate_to, :lang => I18n.locale), edit_section_path(section) )
  end
end
