function init() as void
	m.category_list = m.top.findNode("category_list")
	m.category_list.setFocus(true)
	m.top.observeField("visible", "onVisibleChange")
end function

sub onVisibleChange() as void
	if m.top.visible = true then
		m.category_list.setFocus(true)
	end if
end sub

function updateConfig(params as object) as void
	categories = params.config.categories
	contentNode = CreateObject("roSGNode", "contentNode")
	for each category in categories
		node = CreateObject("roSGNode", "category_node")
		node.title = category.title
		node.feed_url = params.config.host + category.feed_url
		node.comment = category.comment
		contentNode.appendChild(node)
	end for
	m.category_list.content = contentNode
end function
