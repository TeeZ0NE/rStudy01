sub init()
  m.top.functionname = "load"
end sub

function load() as void
  fileSystem = CreateObject("roFilesystem")
  ' ? "Dirs: ";fileSystem.getDirectoryListing("pkg:/")
  filePath = m.top.filepath
  if fileSystem.Exists("pkg:/" + filePath)
    config = ReadAsciiFile("pkg:/" + filePath)
    ? "[loadConfigTask] Config: ";config
    m.top.filedata = ParseJson(config)
  end if
end function