sub init() as void
  m.poster = m.top.findNode("poster")
  m.itemText = m.top.findNode("item_text")
end sub

function itemContentChanged() as void
  itemData = m.top.itemContent
  m.poster.uri = itemData.poster_url
  m.itemText.text = itemData.label_text
end function
