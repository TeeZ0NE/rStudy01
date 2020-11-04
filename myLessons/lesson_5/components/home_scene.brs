function init()
    ? "[home_scene] init"
    m.category_screen = m.top.findNode("category_screen")
    m.content_screen = m.top.findNode("content_screen")
    m.details_screen = m.top.findNode("details_screen")
    m.videoplayer = m.top.findNode("videoplayer")

    m.category_screen.observeField("category_selected", "onCategorySelected")
    m.content_screen.observeField("content_selected", "onContentSelected")
    m.videoplayer.observeField("play_button_pressed", "onPlayButtonPressed")

    category_label = m.category_screen.findNode("env")
    category_label.text = UCase("Select a category:")
    m.category_screen.setFocus(true)
end function

sub onCategorySelected(obj)
    ? "onCategorySelected field: ";obj.getField()
    ? "onCategorySelected data: ";obj.getData()
    list = m.category_screen.findNode("category_list")
    ? "onCategorySelected checkedItem: ";list.checkedItem
    item = list.content.getChild(obj.getData())
    ? "onCategorySelected selected ContentNode: ";item
    m.content_screen.category_title = item.title
    loadFeed(item.feed_url)
end sub

sub loadFeed(url as string)
    ' create a task
    m.feed_task = createObject("roSGNode", "load_feed_task")
    m.feed_task.observeField("response", "onFeedResponse")
    m.feed_task.url = url
    'tasks have a control field with specific values
    m.feed_task.control = "RUN"
end sub

sub onFeedResponse(obj)
    response = obj.getData()
    'turn the JSON string into an Associative Array
    data = parseJSON(response)
    if data <> invalid
        'hide the category screen and show content screen
        m.category_screen.visible = false
        m.content_screen.visible = true
        ' assign data to content screen
        m.content_screen.feed_data = data
    else
        ? "FEED RESPONSE IS EMPTY!"
    end if
end sub


' Main Remote keypress handler
function onKeyEvent(key as string, press as boolean) as boolean
    if press and key = "back"
        if m.content_screen.visible
            m.content_screen.visible = false
            m.category_screen.visible = true
            m.category_screen.setFocus(true)
            return true
        end if
    end if
    return false
end function

sub onContentSelected(obj)
    selected_index = obj.getData()
    ? "content selected_index: ";selected_index
    item = m.content_screen.findNode("content_grid").content.getChild(selected_index)
    m.details_screen.content = item
    m.content_screen.visible = false
    m.details_screen.visible = true
end sub

sub onPlayButtonPressed(obj)
    m.details_screen.visible = false
    m.videoplayer.visible = true
    m.videoplayer.setFocus(true)
end sub