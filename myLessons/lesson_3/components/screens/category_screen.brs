function init()
  m.category_list = m.top.findNode("category_list")
  m.category_list.setFocus(true)

  m.category_list.observeField("itemSelected", "onCategorySelected")
end function

sub onCategorySelected(obj)
  ? "onCategorySelected field: ";obj.getField()
  ? "onCategorySelected data: ";obj.getData()
  ? "onCategorySelected checkedItem: ";m.category_list.checkedItem
  ? "onCategorySelected selected ContentNode: ";m.category_list.content.getChild(obj.getData())
  item = m.category_list.content.getChild(obj.getData())
  loadFeed(item.feed_url)
  ? "Comment: ";item.comment
end sub

sub loadFeed(url) as void
  m.feed_task = CreateObject("roSGNode", "load_feed_task")
  m.feed_task.observeField("response", "onFeedResponse")
  m.feed_task.url = url
  m.feed_task.control = "RUN"
end sub

sub onFeedResponse(obj)
  ? "onFeedResponse: ";obj.getData()
end sub

function onKeyEvent_(key as string, press as boolean) as boolean
  handled = false
  if press then
    handled = true
    ? "Key: ";key, "handled: ";handled
  end if
  return handled
end function
