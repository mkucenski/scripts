on run argv

    set MSG to item 1 of argv
    set TITLE to item 2 of argv
    set STITLE to item 3 of argv

    display notification MSG with title TITLE subtitle STITLE sound name "Funk.aiff"

end run
