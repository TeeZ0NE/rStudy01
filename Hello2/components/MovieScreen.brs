sub init()
    m.buttonPlay = m.top.findNode("buttonPlay")
    m.buttonPlay.observeField("buttonSelected", "onButtonSelected")
end sub

sub setData(data as object)
    m.selectedItem = data.selectedItem
    m.itemsData = data.itemsData
    update()
end sub

function getSelectedItem()
    return m.selectedItem
end function

sub update()
    data = m.itemsData.getChild(m.selectedItem)
    m.top.findNode("poster").uri = data.posterURL
    m.top.findNode("title").text = data.shortdescriptionline1
    m.top.findNode("overview").text = data.overview
    m.top.findNode("releaseDate").text = "Release Data: " + data.releaseDate
    m.top.findNode("voteAverage").text = "Vote Average: " + data.voteAverage.toStr()
end sub

function onButtonSelected()
    showVideo()
end function

function showVideo()
    m.video = createObject("roSGNode", "TestVideo")
    m.top.appendChild(m.video)
    m.video.setFocus(true)
    m.video.observeField("finished", "onVideoFinished")
end function

function onVideoFinished()
    m.top.removeChild(m.video)
    m.video = invalid
end function

function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "<< postscreen.onKeyEvent "; key
        if key = "back" then
            if m.video <> invalid then
                onVideoFinished()
                m.top.setFocus(true)
                m.buttonPlay.setFocus(true)
                return true
            end if
        else if key = "left" then
            m.selectedItem = m.selectedItem - 1
            if m.selectedItem < 0 then
                m.selectedItem = m.itemsData.getChildCount() - 1
            end if
            update()
            return true
        else if key = "right" then
            m.selectedItem = m.selectedItem + 1
            if m.selectedItem = m.itemsData.getChildCount() then
                m.selectedItem = 0
            end if
            update()
            return true
        end if
    end if
    return false
end function