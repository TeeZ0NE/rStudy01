sub init()
  m.config = {}
  m.modalDialog = m.top.findNode("modal_dialog")
  m.movies = m.top.findNode("movies")

  m.movies.ObserveField("content_selected", "onContentSelected")

  loadConfig()
end sub

sub loadConfig()
  m.configTask = CreateObject("roSGNode", "load_config_task")
  m.configTask.observeField("filedata", "onConfigResponse")
  m.configTask.observeField("error", "onConfigError")
  m.configTask.filePath = m.top.configFile
  m.configTask.control = "RUN"
end sub

sub onConfigResponse(response as object) as void
  m.config = response.getData()
  url = m.config.hosts.popular_videos + "?api_key=" + m.config.api_key
  loadMovies(url)
end sub

sub onConfigError(errorMessage as object)
  ? "[home ConfigError] ";error
  showDialog({
    "title": m.config.titles.error,
    "message": errorMessage.GetData()
  })
end sub

sub showDialog(dialogData as object)
  if dialogData.title <> invalid and dialogData.title <> ""
    m.modalDialog.title = dialogData.title
  end if
  m.modalDialog.message = dialogData.message
  m.modalDialog.visible = true
  m.top.dialog = m.modalDialog
end sub

sub loadMovies(url as string)
  m.moviesTask = CreateObject("roSgNode", "load_movies_task")
  m.moviesTask.ObserveField("response", "onLoadMoviesResponse")
  m.moviesTask.ObserveField("error", "onLoadMoviesError")
  m.moviesTask.url = url
  m.moviesTask.control = "RUN"
end sub

sub onLoadMoviesResponse(obj as object)
  response = obj.GetData()
  data = ParseJSON(response)
  if data <> invalid
    m.movies.hosts = m.config.hosts
    m.movies.feed_data = data
  else
    showDialog({
      "title": m.config.titles.error, "message": m.config.messages.empty
    })
  end if
end sub

sub onLoadMoviesError(errorMessage as object)
  showDialog({
    "title": m.config.titles.error, "message": errorMessage.GetData()
  })
end sub

sub onContentSelected(obj as object)
  m.selectedIndex = obj.GetData()
  m.selectedMedia = m.movies.findNode("content_grid").content.GetChild(m.selectedIndex)
  showDetailScreen(m.selectedMedia)

  ' showDialog({
  '   "title": m.selectedMedia.title,
  '   "message": m.config.messages.releaseDate + m.selectedMedia.releaseDate
  ' })
end sub

sub showDetailScreen(mediaData as object)
  m.movies.visible = false
  m.detailScreen = CreateObject("roSGNode", "details_screen")
  m.detailScreen.ObserveField("play_button_pressed", "onPlayButtonPressed")
  m.detailScreen.config = m.config
  m.detailScreen.content = mediaData
  m.top.AppendChild(m.detailScreen)
  m.detailScreen.SetFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  if press
    if m.movies.visible and key = "back"
      closeMovies()
      m.top.SetFocus(true)
      return false
    else if m.detailScreen <> invalid and m.detailScreen.visible and key = "back"
      closeDetails()
      return true
    else if m.videoScreen <> invalid and m.videoScreen.visible
      if key = "back"
        closeVideo()
        return true
      else if key = "up" and m.videoPlayer.state = "playing"
        ? "Video screen up pressed"
        showVideoInfo()
        return false
      end if
    end if
  end if
  return false
end function

sub onPlayButtonPressed(obj as object)
  m.videoScreen = CreateObject("roSGNode", "video_screen")
  m.detailScreen.visible = false
  m.top.AppendChild(m.videoScreen)
  m.videoScreen.SetFocus(true)
  m.videoPlayer = m.videoScreen.findNode("video_player")
  configVideoPlayer()
  m.videoPlayer.content = m.selectedMedia
  m.videoPlayer.SetFocus(true)
  m.videoPlayer.control = "play"
end sub

sub configVideoPlayer()
  m.videoPlayer.enableCookies()
  m.videoPlayer.observeField("position", "onPlayerPositionChanged")
  m.videoPlayer.observeField("state", "onPlayerStateChanged")
end sub

sub closeMovies()
  m.top.RemoveChild(m.movies)
  m.movies = invalid
end sub

sub closeVideo()
  m.videoPlayer.control = "stop"
  m.detailScreen.visible = true
  m.top.RemoveChild(m.videoScreen)
  m.videoScreen = invalid
  m.videoPlayer = invalid
  m.detailScreen.SetFocus(true)
end sub

sub closeDetails()
  m.top.RemoveChild(m.detailScreen)
  m.detailScreen = invalid
  m.movies.visible = true
  m.movies.findNode("content_grid").setFocus(true)
end sub

sub showVideoInfo()
  videoInfo = getVideoInfo()
  streamBitrate = getMeasuredBitrate(videoInfo.streamBitrate)
  duration = getDuration(videoInfo.duration)
  durationStr = duration.hours.toStr() + ":" + duration.minutes.toStr() + ":" + duration.seconds.toStr()
  message = m.config.messages.videoFormat + videoInfo.videoFormat + ", " + m.config.messages.audioFormat + videoInfo.audioFormat + "," + chr(10) + m.config.messages.bitrate + videoInfo.measuredBitrate.toStr() + ", " + m.config.messages.streamBitrate + streamBitrate.toStr() + "," + chr(10) + m.config.messages.duration + durationStr
  showDialog({
    "message": message
  })
end sub

function getVideoInfo() as object
  return {
    "videoFormat": m.videoPlayer.videoFormat,
    "audioFormat": m.videoPlayer.audioFormat,
    "duration": m.videoPlayer.duration,
    "streamBitrate": m.videoPlayer.streamInfo.streamBitrate,
    "measuredBitrate": m.videoPlayer.streamInfo.measuredBitrate
  }
end function

function getMeasuredBitrate(value as integer) as integer
  return value / m.config.messages.kilo
end function

function getDuration(value as integer) as object
  hours = FIX(value / 3600)
  minutes = FIX((value - hours * 3600) / 60)
  seconds = value - hours * 3600 - minutes * 60
  return {
    "hours": hours, "minutes": minutes, "seconds": seconds
  }
end function