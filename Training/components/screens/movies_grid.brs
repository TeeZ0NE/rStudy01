sub init() as void
  m.contentGrid = m.top.findNode("content_grid")
  ? "[movieGrid] init"
end sub

sub onFeedChanged(data as object) as void
  feed = data.GetData()
  hosts = m.top.hosts
  ? "[movies] feed";feed.results
  gridContent = CreateObject("roSGNode", "ContentNode")
  for each item in feed.results
    node = CreateObject("roSGNode", "list_node")
    node.poster_url = hosts.poster_low + item.poster_path
    node.label_text = item.title
    gridContent.appendChild(node)
  end for
  showMarkupGrid(gridContent)
end sub

sub showMarkupGrid(content as object) as void
  m.contentGrid.content = content
  m.contentGrid.visible = true
  m.contentGrid.SetFocus(true)
end sub