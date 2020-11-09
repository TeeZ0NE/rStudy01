sub init() as void
  m.top.functionName = "load"
end sub

function load() as void
  fileSystem = CreateObject("roFileSystem")
  fileFullPath = "pkg:/" + m.top.filePath
  if m.top.filePath <> "" and fileSystem.Exists(fileFullPath)
    config = ReadAsciiFile(fileFullPath)
    ' ? "[LoadTask] config: ";config
    jsonData = ParseJson(config)
    if jsonData <> invalid
      m.top.filedata = jsonData
    else
      m.top.error = "JSON data is invalid"
    end if
  else m.top.error = "Config file not specified or found"
  end if
end function