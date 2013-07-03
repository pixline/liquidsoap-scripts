# archiver.liq
# dump an audio stream to file, cut every hour
# GPL2+ 2009 pixline

def fakeclock ()
    true
end

escopost = mksafe(input.http("<streaming_source>"))

output.file (%mp3(mono, stereo=false, samplerate=44100, bitrate=80), 
    "/srv/archive/%Y/%m/%d/%Y.%m.%d-%H.%M.%S-archive.mp3", 
    id="archive", 
    reopen_delay = 3600.0, 
    reopen_when = (fakeclock),
    archive)


