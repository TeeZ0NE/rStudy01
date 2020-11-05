function init() as void
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.videoplayer = m.top.findNode("videoplayer")
	m.error_dialog = m.top.findNode("error_modal_dialog")

	m.category_screen.observeField("category_selected", "onCategorySelected")
	m.content_screen.observeField("content_selected", "onContentSelected")
	m.details_screen.observeField("play_button_pressed", "onPlayButtonPressed")

	m.category_screen.setFocus(true)

	initVideoPlayer()
end function

sub onCategorySelected(obj as object) as void
	? "onCategorySelected field: ";obj.getField()
	? "onCategorySelected data: ";obj.getData()
	list = m.category_screen.findNode("category_list")
	? "onCategorySelected checkedItem: ";list.checkedItem
	? "onCategorySelected selected ContentNode: ";list.content.getChild(obj.getData())
	item = list.content.getChild(obj.getData())
	m.content_screen.category_title = item.title
	loadFeed(item.feed_url)
end sub

sub onContentSelected(obj as object) as void
	selected_index = obj.getData()
	? "content selected_index :";selected_index
	' look up the index using this verbose, dumb technique.
	m.selected_media = m.content_screen.findNode("content_grid").content.getChild(selected_index)
	m.details_screen.content = m.selected_media
	m.content_screen.visible = false
	m.details_screen.visible = true

	' m.videoplayer.control = "prebuffer" 'm.videoplayer.content.url
end sub

sub onPlayButtonPressed(obj as object) as void
	m.details_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	m.videoplayer.content = m.selected_media
	m.videoplayer.control = "play"
	' ? "[Play button pressed]- obj ";obj.getData()
end sub

sub loadFeed(url as string) as void
	m.feed_task = createObject("roSGNode", "load_feed_task")
	m.feed_task.observeField("response", "onFeedResponse")
	m.feed_task.url = url
	m.feed_task.control = "RUN"
end sub

sub onFeedResponse(obj as object) as void
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
		? UCase("feed response is empty!")
	end if
end sub

sub initVideoPlayer() as void
	m.videoplayer.enableCookies()
	m.videoplayer.setCertificatesFile("common:/certs/ca-bundle.crt")
	m.videoplayer.initClientCertificates()
	m.videoplayer.notificationInterval = 1
	m.videoplayer.observeFieldScoped("position", "onPlayerPositionChanged")
	m.videoplayer.observeFieldScoped("state", "onPlayerStateChanged")
end sub

sub onPlayerPositionChanged(obj as object) as void
	' TimeLine
	? "Player Position: ";obj.getData()
end sub

sub onPlayerStateChanged(obj as object) as void
	' buffering, playing, paused, error, finished
	state = obj.getData()
	? "Player state: ";state
	if state = "error" then
		errorMessage = m.videoplayer.errorMsg + Chr(10) + "Error Code: " + m.videoplayer.errorCode.toStr()
		showErrorDialog(errorMessage)
	else if state = "finished" then
		closeVideo()
	end if
end sub

sub closeVideo() as void
	m.videoplayer.control = "stop"
	m.videoplayer.visible = false
	m.details_screen.visible = true
end sub

sub showErrorDialog(message as string) as void
	m.error_dialog.title = "ErroR"
	m.error_dialog.message = message
	m.error_dialog.visible = true
	' Set dialog on top
	m.top.dialog = m.error_dialog
end sub


' Main Remote keypress handler
function onKeyEvent(key as string, press as boolean) as boolean
	? "[home_scene] onKeyEvent", key, press
	if press and key = "back"
		if m.content_screen.visible
			m.content_screen.visible = false
			m.category_screen.visible = true
			m.category_screen.setFocus(true)
			return true
		else if m.details_screen.visible
			m.details_screen.visible = false
			m.content_screen.visible = true
			m.content_screen.setFocus(true)
			return true
		else if m.videoplayer.visible
			m.videoplayer.visible = false
			m.details_screen.visible = true
			closeVideo()
			m.details_screen.setFocus(true)
			return true
		end if
	end if
	return false
end function
