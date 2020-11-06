sub init() as void
	m.title = m.top.FindNode("title")
	m.description = m.top.FindNode("description")
	m.thumbnail = m.top.FindNode("thumbnail")
	m.play_button = m.top.FindNode("play_button")
	m.top.observeField("visible", "onVisibleChange")
	m.play_button.setFocus(true)
end sub

' set proper focus to button in case if return from Video Screen
sub onVisibleChange() as void
	if m.top.visible = true then
		m.play_button.setFocus(true)
	end if
end sub

sub OnContentChange(obj as object) as void
	item = obj.getData()
	? "[details_screen] onContentChange ";item
	m.title.text = item.title
	m.description.text = item.url
	m.thumbnail.uri = item.HDGridPosterURL
end sub
