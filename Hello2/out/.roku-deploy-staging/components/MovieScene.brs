'**
'** Example: Edit a Label size and color with BrightScript
'**

function init()
    ' m.top.backgroundURI = "pkg:/images/bg.jpg"

    ' m.top.overhang.logoUri = "pkg:/images/epam_logo.png"
    ' m.top.overhang.showOptions = true

    ' m.gridPanel = createObject("roSGNode", "MovieGridPanel")
    ' m.gridPanel.grid.observeField("itemSelected", "onItemSelected")
    ' m.top.panelSet.appendChild(m.gridPanel)

    ' m.ps = createObject("roSGNode", "ParticleSystem")
    ' m.top.appendChild(m.ps)
    ' m.ps.callFunc("start")

    m.label1 = createObject("roSGNode", "Label")
    m.label1.text = "11111111111111111111111111"
    m.label2 = createObject("roSGNode", "Label")
    m.label2.text = "22222222222222222222222222"
    m.label2.translation = [0, 100]

    m.scrollableText = createObject("roSGNode", "ScrollableText")
    m.scrollableText.translation = [100, 200]
    m.scrollableText.color = "0xdddddd00"
    m.scrollableText.width = 500
    m.scrollableText.height = 200
    m.scrollableText.text = "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    m.scrollableText.appendChild(m.label1)
    m.scrollableText.appendChild(m.label2)
    m.top.appendChild(m.scrollableText)
    m.scrollableText.setFocus(true)
end function

function onItemSelected(message as object)
    m.movieScreen = createObject("roSGNode", "MovieScreen")
    m.movieScreen.callFunc("setData", {itemsData: m.gridPanel.grid.content, selectedItem: m.gridPanel.grid.itemSelected})
    m.top.appendChild(m.movieScreen)
    m.movieScreen.setFocus(true)
    m.top.panelset.visible = false
end function

function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "<< scene.onKeyEvent "; key
        if key = "back" then
            if m.movieScreen <> invalid then
                m.gridPanel.grid.jumpToItem = m.movieScreen.callFunc("getSelectedItem")
                m.gridPanel.grid.setFocus(true)
                m.top.panelset.visible = true
                m.top.removeChild(m.movieScreen)
                m.movieScreen = invalid
                return true
            end if
        end if
    end if
    return false
end function