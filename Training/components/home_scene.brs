sub init()
  ? "[home scene] init"
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
  selectedIndex = obj.GetData()
  m.selectedMedia = m.movies.findNode("content_grid").content.GetChild(selectedIndex)
  ? "[home] data";m.selectedMedia
  showDetailScreen(m.selectedMedia)

  ' showDialog({
  '   "title": m.selectedMedia.title,
  '   "message": m.config.messages.releaseDate + m.selectedMedia.releaseDate
  ' })
end sub

sub showDetailScreen(mediaData as object)
  m.movies.visible = false
  m.detailScreen = CreateObject("roSGNode", "details_screen")
  m.detailScreen.config = m.config
  m.detailScreen.content = mediaData
  m.top.AppendChild(m.detailScreen)
end sub

function onFocusChanged() as void
  ? "[Home] focus changed"
  ' print "Focus on item: " + stri(m.simpleMarkupList.itemFocused)
  ' print "Focus on item: " + stri(m.simpleMarkupList.itemUnfocused) + " lost"
end function

function onKeyEvent(key as string, press as boolean) as boolean
  ? "[Key Event] ";key
  ? "[key back] movies visible";m.movies.visible
  if press
    if m.movies.visible and key = "back"
      m.top.RemoveChild(m.movies)
      m.movies = invalid
      m.top.SetFocus(true)
      return false
    else if m.detailScreen <> invalid and m.detailScreen.visible and key = "back"
      m.top.RemoveChild(m.detailScreen)
      m.detailScreen = invalid
      m.movies.visible = true
      m.movies.SetFocus(true)
      return true
    end if
  end if
  return false
end function