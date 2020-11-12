sub init()
  m.poster = m.top.findNode("poster")
  m.itemText = m.top.findNode("item_text")
  m.item2Text = m.top.findNode("shortdescriptionline2")
end sub

function itemContentChanged() as void
  itemData = m.top.itemContent
  m.poster.uri = itemData.poster_url
  m.itemText.text = itemData.title
  m.item2Text.text = itemData.description
end function
