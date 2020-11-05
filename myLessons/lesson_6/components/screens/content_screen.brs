sub init()
	m.content_grid = m.top.FindNode("content_grid")
	m.header = m.top.FindNode("header")
	m.top.observeField("visible", "onVisibleChange")
end sub

sub onFeedChanged(obj)
	feed = obj.getData()
	m.header.text = m.top.category_title
	postercontent = createObject("roSGNode", "ContentNode")
	for each item in feed
		node = createObject("roSGNode", "ContentNode")
		node.streamformat = m.top.stream_format
		node.title = item.title
		node.url = m.top.test_video_url
		node.description = item.id
		node.HDGridPosterURL = item.thumbnailUrl
		node.shortDescriptionLine1 = item.title
		node.shortDescriptionLine2 = item.url
		postercontent.appendChild(node)
	end for
	showpostergrid(postercontent)
end sub

sub showpostergrid(content)
	m.content_grid.content = content
	m.content_grid.visible = true
	m.content_grid.setFocus(true)
end sub

' set proper focus to content_grid when we return from Details Screen
sub onVisibleChange()
	if m.top.visible = true then
		m.content_grid.setFocus(true)
	end if
end sub
