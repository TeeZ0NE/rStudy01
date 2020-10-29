sub init()
    content = createObject("RoSGNode", "ContentNode")
    content.title = "Example Video"
    content.streamformat = "mp4"
    ' content.streamformat = "hls"
    content.url = "http://roku.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/f8de8daf2ba34aeb90edc55b2d380c3f/b228eeaba0f248c48e01e158f99cd96e/rr_123_segment_1_072715.mp4"
    ' content.url = "http://content-ause4.uplynk.com/preplay2/4e1ecc7dc1554b3d922c559c9c0a6c6a/bc6fdd11fb6495cc99ab67ef05edf1c3/5f6emYZ0WQ1zaQMwqQvvnD6tdxUC9Vol6MslXG1fpd77.m3u8?pbs=4264e24c864c4fe1b5825c84369792bb&euid=4866b12d-7734-4d03-b45d-2d376fa46cf8_000_0_012-3_sf_01-09-97_2.5.145"

    m.video = m.top.findNode("testVideo")
    m.video.content = content
    m.video.control = "play"
    m.video.observeField("state", "onState")

    m.playing = false
end sub

function onState(message as object)
    print "<< video.onState "; message.getData()
    if message.getData() = "playing" then
        m.playing = true
    else if message.getData() = "finished" then
        m.playing = false
    end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "<< video.onKeyEvent "; key
        if key = "up" and m.playing then
            showInfo()
            return true
        end if
    end if
    return false
end function

sub showInfo()
    videoFormat = "Video Format: " + m.video.videoFormat
    audioFormat = ", Audio Format: " + m.video.audioFormat
    measuredBItrate = ", Measured Bitrate: " + m.video.streamInfo.measuredBItrate.toStr()
    streamBitrate = ", Stream Bitrate: " + m.video.streamInfo.streamBitrate.toStr()
    duration = ", Duration: " + m.video.duration.toStr()
    m.dialog = CreateObject("roSGNode", "Dialog")
    m.dialog.title = "Info"
    m.dialog.message = videoFormat + audioFormat + measuredBItrate + streamBitrate + duration
    m.top.getScene().dialog = m.dialog
end sub