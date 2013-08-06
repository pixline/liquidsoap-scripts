#########################################
# streamer & escopost 1.0  	#
#########################################

#set("root.sync",false)
#set("buffering.kind","disk_manyfiles")
#set("alsa.buffer_lenght",6)


# Set correct frame size:
#set("frame.size",940)

#log(' ***** streamer riavviato ***** ')


#stream = mksafe(input.alsa(id='linein'))
stream = (input.alsa(id='linein'):source(2,0,0))
#stream = mksafe(input.pulseaudio)
#stream = mksafe(input.pulseaudio(id='linein'))


stream = rewrite_metadata([("title","Radio")],stream)


output.icecast(%vorbis(quality=0.8, samplerate=44100, channels=2), 
	host="uplink.localhost.dev",
	port=8005,
	mount='uplink.ogg',
	genre='Uplink',
#	restart="true",
	url="localhost",
	description="main uplink",
	timeout=1200.,
	stream
)

#output.icecast(quality=0.7,
#        host="uplink",
#        port=8005,
#        mount='uplink.ogg',
#        genre='Uplink',
#        restart=true,
#        url="localhost",
#        description="main uplink",
#        timeout=1200.,
#        stream
#)




#output.icecast(%vorbis(quality=0.7, mono),
#        host="uplink",
#        port=8005,
#        mount='uplink.ogg',
#        genre='Uplink',
#        restart=true,
#	restart_delay=30,
#        url="localhost",
#        description="main uplink",
#        timeout=600.,
#        stream
#)




#output.harbor(format="audio/ogg",



#output.icecast(%mp3(quality=0.5, mono)
#host="95.142.167.22",
#        port=8001,
#        mount='blackout.mp3',
#        password='porcoddio',
#        genre='Uplink',
#        restart=true,
#        url="http://radioblackout.org",
#        description="Radio Blackout",
#        stream
#)



#def fakeclock ()
#    true
#end


#output.file(%vorbis(quality=0.5, channels=2),"/mnt/storage/archive/%Y/%m/%d/%Y.%m.%d-%H.%M.%S-archive.ogg", 
#	id="escopost", 
#	reopen_delay = 3600.0, reopen_when = (fakeclock),
#	stream
#)
