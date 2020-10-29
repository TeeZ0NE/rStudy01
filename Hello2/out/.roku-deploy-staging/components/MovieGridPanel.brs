sub init()
    m.top.leftPosition = 95
    m.top.optionsAvailable = true
    m.top.overhangTitle = "GridPanel Expamples"
    m.top.grid = m.top.findNode("posterGrid")
    
    readContent()
end sub

sub readContent()
    m.contentReader = createObject("roSGNode", "ContentReader")
    m.contentReader.observeField("content", "onContent")
    m.contentReader.control = "run"
end sub

sub onContent()
    m.top.grid.content = m.contentReader.content
end sub