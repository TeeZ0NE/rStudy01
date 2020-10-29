sub init()
    m.top.functionName = "getContent"
    m.CONTENT_URL = "http://api.themoviedb.org/3/movie/popular?api_key=4bc08ab955f501a524c27210af4c49f3"
    m.IMAGE_URL = "https://image.tmdb.org/t/p/w500"
end sub

sub getContent()
    content = createObject("roSGNode", "ContentNode")
    urlTransfer = createObject("roUrlTransfer")
    urlTransfer.setUrl(m.CONTENT_URL)
    response = parseJSON(urlTransfer.GetToString())
    
    if (response <> invalid) then
        for each result in response.results
            item = content.createChild("MovieContentNode")
            if result.backdrop_path = invalid then
                posterURL = m.IMAGE_URL + result.poster_path
            else
                posterURL = m.IMAGE_URL + result.backdrop_path
            end if
            item.setFields({
                hdgridposterurl: posterURL,
                sdgridposterurl: posterURL,
                shortdescriptionline1: result.title,
                shortdescriptionline2: result.release_date.toStr() + " Rating: " + result.vote_average.toStr(),
                posterURL: m.IMAGE_URL + result.poster_path,
                overview: result.overview,
                releaseDate: result.release_date,
                voteAverage: result.vote_average.toStr()
            })
        end for
    end if
    
    m.top.content = content
end sub