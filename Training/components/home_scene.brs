sub init() as void
  ? "[home scene] init"
  m.config = {}
  m.modalDialog = m.top.findNode("modal_dialog")

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
  ? "[home ConfigResponse] ";m.config, "url: ";url
  loadMovies(url)
end sub

sub onConfigError(error as object) as void
  ? "[home ConfigError] ";error
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
  data = ParseJSON(obj.GetData())
end sub

sub onLoadMoviesError(obj as object) as void
  ? "[home loadMoviesError]";obj.getData()
end sub