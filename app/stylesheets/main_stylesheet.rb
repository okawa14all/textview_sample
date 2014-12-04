class MainStylesheet < ApplicationStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def original_text_area_height
    app_height - status_bar_height - navbar_height
  end

  def text_area(st)
    st.frame = { l: 5, t: 10, w: app_width - 10, h: original_text_area_height }
    st.background_color = color.white
    st.font = font.xsmall
    st.text_color = color.black
    # SZTextView's properties
    st.view.placeholder = 'いまどうしてる？'
    st.view.placeholderTextColor = color.light_gray
  end

  def keyboard_toolbar(st)
    st.frame = { l: 0, t: 0, w: app_width, h: 44 }
    st.view.barTintColor = color.white
    st.view.clipsToBounds = true
  end

  def autocomplete_container(st)
    st.frame = { l: 0, t: 50, w: app_width, h: 120 }
  end
end
