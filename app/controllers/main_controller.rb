class MainController < UIViewController

  def initWithNibName(name, bundle: bundle)
    super
    @auto_complete_mgr = MJAutoCompleteManager.new
    @auto_complete_mgr.dataSource = self
    @auto_complete_mgr.delegate = self

    items = []
    %w(john paul ringo george jonathan ほげ).each do |name|
      item = MJAutoCompleteItem.new
      item.autoCompleteString = name
      items.push item
    end

    at_trigger = MJAutoCompleteTrigger.alloc.initWithDelimiter('@', autoCompleteItems: items)

    @auto_complete_mgr.addAutoCompleteTrigger(at_trigger)

    self
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = MainStylesheet
    self.title = 'new post'
    rmq(self.view).apply_style :root_view

    @text_view = rmq.append(SZTextView, :text_area).get
    @text_view.delegate = self
    @text_view.inputAccessoryView = tool_bar

    @auto_complete_mgr.container = rmq.append(UIView, :autocomplete_container).get

    rmq(@text_view).on(:swipe_up) { |sender| sender.resignFirstResponder }
    rmq(@text_view).on(:swipe_down) { |sender| sender.resignFirstResponder }

  end

  def viewWillAppear(animated)
    # キーボード開閉を検知するオブザーバを登録
    @keyboard_will_show_observer = App.notification_center.observe(UIKeyboardWillShowNotification) do |notification|
      keyboard_will_show(notification)
    end

    @keyboard_will_hide_observer = App.notification_center.observe(UIKeyboardWillHideNotification) do |notification|
      keyboard_will_hide(notification)
    end
  end

  def viewDidAppear(animated)
    @text_view.becomeFirstResponder
  end

  def viewWillDisappear(animated)
    App.notification_center.unobserve @keyboard_will_show_observer
    App.notification_center.unobserve @keyboard_will_hide_observer
  end

  def viewDidDisappear(animated)
    super
  end



  def tool_bar
    toolbar = rmq.create(UIToolbar, :keyboard_toolbar).get

    camera_icon = FAKIonIcons.cameraIconWithSize 24
    camera_icon.addAttribute(NSForegroundColorAttributeName, value: rmq.color.light_gray)
    camera_icon_image = camera_icon.imageWithSize(CGSizeMake(24, 24))
    camera_button = UIBarButtonItem.alloc.initWithImage(
      camera_icon_image.imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal),
      style: UIBarButtonItemStylePlain,
      target: self,
      action: :open_camera_menu
    )

    video_icon = FAKIonIcons.videocameraIconWithSize 24
    video_icon.addAttribute(NSForegroundColorAttributeName, value: rmq.color.light_gray)
    video_icon_image = video_icon.imageWithSize(CGSizeMake(24, 24))
    video_button = UIBarButtonItem.alloc.initWithImage(
      video_icon_image.imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal),
      style: UIBarButtonItemStylePlain,
      target: self,
      action: :open_video_menu
    )

    music_icon = FAKIonIcons.musicNoteIconWithSize 24
    music_icon.addAttribute(NSForegroundColorAttributeName, value: rmq.color.light_gray)
    music_icon_image = music_icon.imageWithSize(CGSizeMake(24, 24))
    music_button = UIBarButtonItem.alloc.initWithImage(
      music_icon_image.imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal),
      style: UIBarButtonItemStylePlain,
      target: self,
      action: :open_music_menu
    )

    location_icon = FAKIonIcons.locationIconWithSize 24
    location_icon.addAttribute(NSForegroundColorAttributeName, value: rmq.color.light_gray)
    location_icon_image = location_icon.imageWithSize(CGSizeMake(24, 24))
    location_button = UIBarButtonItem.alloc.initWithImage(
      location_icon_image.imageWithRenderingMode(UIImageRenderingModeAlwaysOriginal),
      style: UIBarButtonItemStylePlain,
      target: self,
      action: :open_location_menu
    )

    fixed_spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFixedSpace, target: nil, action: :nil)
    fixed_spacer.width = 12

    toolbar.items = [
      camera_button,
      fixed_spacer,
      video_button,
      fixed_spacer,
      music_button,
      fixed_spacer,
      location_button
    ]

    toolbar
  end

  def open_camera_menu
    puts 'open_camera_menu'
  end

  def open_video_menu
    puts 'open_video_menu'
  end

  def open_music_menu
    puts 'open_music_menu'
  end

  def open_location_menu
    puts 'open_location_menu'
  end

  def keyboard_will_show(notification)
    # キーボードオープンと同時に、textviewの高さを変える
    puts 'keyboard_will_show'
    info = notification.userInfo
    keyboard_rect = info.objectForKey(UIKeyboardFrameEndUserInfoKey).CGRectValue
    duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey).doubleValue

    new_height = rmq.stylesheet.original_text_area_height - keyboard_rect.size.height - 10

    rmq(@text_view).animate(
      duration: duration,
      animations: -> (q) {
        q.style { |st| st.height = new_height }
      }
    )
  end

  def keyboard_will_hide(notification)
    # キーボードクローズと同時に、textviewの高さを変える
    puts 'keyboard_will_hide'
    info = notification.userInfo
    duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey).doubleValue

    rmq(@text_view).animate(
      duration: duration,
      animations: -> (q) {
        q.style { |st| st.height = rmq.stylesheet.original_text_area_height }
      }
    )
  end

  # --- UITextView Delegate methods
  def textViewDidChange(text_view)
    @auto_complete_mgr.processString(@text_view.text)
  end

  # --- UIScrollViewDelegate
  def scrollViewDidEndDragging(scroll_view, willDecelerate: decelerate)
    @text_view.resignFirstResponder
  end

  # --- MJAutoCompleteMgr DataSource Methods
  def autoCompleteManager(manager, filterList: filtered_list, forTrigger: trigger, withString: string)
    if string.present?
      predicate = NSPredicate.predicateWithFormat("autoCompleteString beginswith[cd] %@", string)
      filtered_list.filterUsingPredicate(predicate)
    end
  end

  # --- MJAutoCompleteMgr Delegate methods
  def autoCompleteManager(manager, shouldUpdateToText: new_text)
    puts new_text
    @text_view.text = new_text
  end

end
