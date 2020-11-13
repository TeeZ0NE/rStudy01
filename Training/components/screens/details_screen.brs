sub init()
  m.title = m.top.FindNode("title")
  m.poster = m.top.FindNode("image")
  m.playBtn = m.top.FindNode("play_button")
  m.detailInfo = m.top.FindNode("detail_info")
  m.detailTitle = m.top.FindNode("detail_title")
  m.additionalInfo = m.top.FindNode("additional_info")

  m.top.observeField("visible", "onVisibleChange")
  m.playBtn.SetFocus(true)
end sub

sub onContentChange(mediaData as object)
  item = mediaData.getData()
  config = m.top.config
  m.poster.uri = config.hosts.poster_mid + item.poster_path
  m.title.text = item.title
  m.detailTitle.text = config.details.detailInfo
  m.detailInfo.text = item.overview
  m.additionalInfo.text = config.details.releaseDate + item.releaseDate + chr(10) + config.details.vote + item.vote.toStr()
  m.playBtn.text = config.buttons.play
end sub

sub onVisibleChange()
  if m.top.visible = true then
    m.playBtn.SetFocus(true)
  end if
end sub