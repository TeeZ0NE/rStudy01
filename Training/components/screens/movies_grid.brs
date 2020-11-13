sub init()
  m.contentGrid = m.top.findNode("content_grid")
end sub

sub onFeedChanged(data as object)
  feed = data.GetData()
  hosts = m.top.hosts
  gridContent = CreateObject("roSGNode", "ContentNode")
  for each item in feed.results
    node = CreateObject("roSGNode", "list_node")
    node.poster_url = hosts.poster_low + item.poster_path
    node.title = item.title
    node.description = item.release_date + " Raiting: " + item.vote_average.ToStr()
    node.releaseDate = item.release_date
    node.overview = item.overview
    node.vote = item.vote_average
    node.poster_path = item.poster_path
    gridContent.appendChild(node)
  end for
  showMarkupGrid(gridContent)
end sub

sub showMarkupGrid(content as object)
  m.contentGrid.content = content
  m.contentGrid.visible = true
  m.contentGrid.SetFocus(true)
end sub