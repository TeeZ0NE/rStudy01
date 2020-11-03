sub init()
    m.content_grid = m.top.FindNode("content_grid")
    m.header = m.top.FindNode("header")
end sub

sub onFeedChanged(obj)
    feed = obj.getData()
    m.header.text = "My title"
    postercontent = createObject("roSGNode", "ContentNode")
    for each item in feed.data
        node = createObject("roSGNode", "ContentNode")
        node.streamformat = item.albumId
        node.title = item.title
        node.url = item.url
        node.description = item.id
        node.HDGRIDPOSTERURL = item.thumbnailUrl
        node.SHORTDESCRIPTIONLINE1 = item.title
        node.SHORTDESCRIPTIONLINE2 = "Short desc line 2"
        postercontent.appendChild(node)
    end for
    showpostergrid(postercontent)
end sub

sub showpostergrid(content)
    m.content_grid.content = content
    m.content_grid.visible = true
    m.content_grid.setFocus(true)
end sub
