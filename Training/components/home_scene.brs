sub init() as void
  ? "[home scene] init"
  m.config = {}
  m.modalDialog = m.top.findNode("modal_dialog")
  m.movies = m.top.findNode("movies")
  loadConfig()
end sub

sub loadConfig() as void
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

sub onConfigError(errorMessage as object) as void
  ? "[home ConfigError] ";error
  showDialog({
    "title": m.config.titles.error,
    "message": errorMessage.GetData()
  })
end sub

sub showDialog(dialogData as object) as void
  if dialogData.title <> invalid and dialogData.title <> ""
    m.modalDialog.title = dialogData.title
  end if
  m.modalDialog.message = dialogData.message
  m.modalDialog.visible = true
  m.top.dialog = m.modalDialog
end sub

sub loadMovies(url as string) as void
  m.moviesTask = CreateObject("roSgNode", "load_movies_task")
  m.moviesTask.ObserveField("response", "onLoadMoviesResponse")
  m.moviesTask.ObserveField("error", "onLoadMoviesError")
  m.moviesTask.url = url
  m.moviesTask.control = "RUN"
end sub

sub onLoadMoviesResponse(obj as object) as void
  response = obj.GetData()
  data = ParseJSON(response)
  if data <> invalid
    ' ? "[Home] movies hosts:";m.config.hosts
    m.movies.hosts = m.config.hosts
    m.movies.feed_data = data
  else
    showDialog({
      "title": m.config.titles.error, "message": m.config.messages.empty
    })
  end if
end sub

sub onLoadMoviesError(errorMessage as object) as void
  showDialog({
    "title": m.config.titles.error, "message": errorMessage.GetData()
  })
end sub

function getMarkupGridData() as object
  data = CreateObject("roSGNode", "ContentNode")

  for i = 1 to 6
    dataItem = data.CreateChild("list_node")
    dataItem.poster_url = "http://devtools.web.roku.com/samples/images/Portrait_1.jpg"
    dataItem.label_text = "Grid item" + stri(i)
  end for
  return data
end function

function onFocusChanged() as void
  ? "[Home] focus changed"
  ' print "Focus on item: " + stri(m.simpleMarkupList.itemFocused)
  ' print "Focus on item: " + stri(m.simpleMarkupList.itemUnfocused) + " lost"
end function

' function onKeyEvent(key as string, press as boolean) as boolean
'   ? "[Key Event] ";key
'   handled = false
'   ' if (m.simpleMarkupList.hasFocus() = true) and (key = "right") and (press = true)
'   ' m.simpleMarkupGrid.setFocus(true)
'   ' m.simpleMarkupList.setFocus(false)
'   ' handled = true
'   ' else if (m.simpleMarkupGrid.hasFocus() = true) and (key = "left") and (press = true)
'   ' m.simpleMarkupGrid.setFocus(false)
'   ' m.simpleMarkupList.setFocus(true)
'   ' handled = true
'   ' end if
'   return handled
' end function